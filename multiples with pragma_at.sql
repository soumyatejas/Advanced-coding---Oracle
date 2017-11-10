alter session set plsql_warnings='enable:all';

create table multiples
(base_no number(1,0),
multiple number(2,0),
product number(3,0));

drop table time_log_multiple;

create table time_log_multiple
(base_no number(1,0),
time_elapsed number(10,0));

create or replace procedure log_time(baseno_in number,timeelapsed_in integer)
authid definer
is
pragma autonomous_transaction;
begin
  insert into time_log_multiple
  values(baseno_in, timeelapsed_in);
  commit;
end log_time;
/

create or replace procedure generatemultiple
authid definer
is
time_before binary_integer;
time_after binary_integer;
begin
  for i in 1..9
  loop
    time_before:=dbms_utility.get_time;
    for j in 1..10
    loop
      insert into multiples
      values(i,j,i*j);
    end loop;
    time_after:=dbms_utility.get_time;
    log_time(i,time_after-time_before);
  end loop;
  commit;
end generatemultiple;
/