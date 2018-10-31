select now()-2; --error
select current_date-2;

select TRUNC(sysdate, 'Q') from dual;


select date_trunc('quarter',  now())::date;

--past n hour/day/month/year
select (now() - '2 hour'::interval)



--last_day

select last_day(sysdate) from dual;

SELECT (date_trunc('MONTH', now()) + INTERVAL '1 MONTH - 1 day')::date;



--next day

select next_day(sysdate,'sun') from dual;


select (current_date - date_part('dow', current_date)::int)::date -'7 day'::interval;


--get iw of current date

select TRUNC(sysdate,'IW') from dual;

select date_trunc('week', current_date)::date;

