create or replace function myfn(id numeric) returns text as
$$
declare
  v_dname text;
  v_sql   text;
begin
  v_sql := 'select glusr_usr_id from glusr_usr where glusr_usr_id = $1';
  execute v_sql into v_dname using id;
  return v_dname;
end;
$$
language plpgsql;

select myfn(null);
