create table accounts(
  name varchar primary key
);

create table transactions(
  id serial primary key,
  name varchar not null references accounts on update cascade on delete cascade,
  amount numeric(9,2) not null,
  post_time timestamptz not null
);

create index on transactions (name);
create index on transactions (post_time);


create materialized view matview.account_balances as
	select name,coalesce(sum(amount) filter (where post_time <= current_timestamp),0) as balance
	from accounts left join transactions using(name)
	group by name;

create index on matview.account_balances (name);
create index on matview.account_balances (balance);




create table lazy_account_balances_mat(
name varchar primary key references accounts on update cascade on delete cascade,
balance numeric(9,2) not null default 0,
expiration_time timestamptz not null
);


insert into lazy_account_balances_mat(name, expiration_time)
select name, '-Infinity'
from accounts;


create function lazy_account_insert() returns trigger
  security definer
  language plpgsql
as $$
  begin
    insert into lazy_account_balances_mat(name, expiration_time)
      values(new.name, 'Infinity');
    return new;
  end;
$$;

create trigger lazy_account_insert after insert on accounts for each row execute procedure lazy_account_insert();



create function lazy_transaction_insert()
  returns trigger
  security definer
  language plpgsql
as $$
  begin
    update lazy_account_balances_mat
    set expiration_time=new.post_time
    where name=new.name
      and new.post_time < expiration_time;
    return new;
  end;
$$;

create trigger lazy_transaction_insert after insert on transactions for each row execute procedure lazy_transaction_insert();


create function lazy_transaction_update()
  returns trigger
  security definer
  language plpgsql
as $$
  begin
    update accounts
    set expiration_time='-Infinity'
    where name in(old.name, new.name)
      and expiration_time<>'-Infinity';

    return new;
  end;
$$;

create trigger lazy_transaction_update after update on transactions
    for each row execute procedure lazy_transaction_update();


create function lazy_transaction_delete()
  returns trigger
  security definer
  language plpgsql
as $$
  begin
    update lazy_account_balances_mat
    set expiration_time='-Infinity'
    where name=old.name
      and old.post_time <= expiration_time;

    return old;
  end;
$$;

create trigger lazy_transaction_delete after delete on transactions
    for each row execute procedure lazy_transaction_delete();



create function lazy_refresh_account_balance(_name varchar)
  returns lazy_account_balances_mat
  security definer
  language sql
as $$
  with t as (
    select
      coalesce(
        sum(amount) filter (where post_time <= current_timestamp),
        0
      ) as balance,
      coalesce(
        min(post_time) filter (where current_timestamp < post_time),
        'Infinity'
      ) as expiration_time
    from transactions
    where name=_name
  )
  update lazy_account_balances_mat
  set balance = t.balance,
    expiration_time = t.expiration_time
  from t
  where name=_name
  returning lazy_account_balances_mat.*;
$$;


create view lazy_account_balances as
select name, balance
from lazy_account_balances_mat
where current_timestamp < expiration_time
union all
select r.name, r.balance
from lazy_account_balances_mat abm
  cross join lazy_refresh_account_balance(abm.name) r
where abm.expiration_time <= current_timestamp;

select * from lazy_account_balances where balance < 0;

