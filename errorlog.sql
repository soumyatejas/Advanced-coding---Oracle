create table updatetax_log
(err_id varchar2(10),
err_message varchar2(100),
err_date date);

create or replace procedure updatetax_errors(errid_in varchar2, errmessage_in varchar2)
is
  pragma autonomous_transaction;
begin
  insert into updatetax_log
  values(errid_in, errmessage_in,sysdate);
  commit;
end;
/