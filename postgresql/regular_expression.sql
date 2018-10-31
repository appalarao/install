select length(REGEXP_REPLACE ('hi bheri, ''how are you123?''', '([^[:alpha:]])',' ','g'));

g--for global filter
select length(REGEXP_REPLACE ('hi bheri, ''how are you123?''', '([^[:alpha:]])',' ')) from dual;
