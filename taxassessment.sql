create or replace package taxassessment  authid definer as
  procedure updatetax;
  function gettaxlessthan30(esalary_in number)return number;
  function gettaxbetween30and50(esalary_in number) return number;
  function gettaxgreaterthan50(esalary_in number)return number;
  procedure updatetax_errors(errid_in varchar2, errmessage_in varchar2);
end taxassessment;

create or replace package body taxassessment as
  procedure  updatetax is
--  authid definer is
    date_30 date:=trunc(sysdate)-(365*30);
    date_50 date:=trunc(sysdate)-(365*50);
    e_salary number(12,2);
    cursor c1 is
    select eid from employee 
    where dateofbirth>date_30
    and enddate is null;
    cursor c2 is
    select eid from employee
    where dateofbirth between date_50 and date_30
    and enddate is null;
    cursor c3 is
    select eid from employee
    where dateofbirth<date_50
    and enddate is null;
  begin
    for r1 in c1
    loop
      select salaryamt
      into e_salary
      from empsalary
      where eid=r1.eid
      and enddate is null;
      insert into emptax values(r1.eid,gettaxlessthan30(e_salary),sysdate);
    end loop;
    for r2 in c2
    loop
      select salaryamt
      into e_salary
      from empsalary
      where eid=r2.eid
      and enddate is null;
      insert into emptax values(r2.eid,gettaxbetween30and50(e_salary),sysdate);
    end loop;
    for r3 in c3
    loop
      select salaryamt
      into e_salary
      from empsalary
      where eid=r3.eid
      and enddate is null;
      insert into emptax values(r3.eid,gettaxgreaterthan50(e_salary),sysdate);
    end loop;
  exception
    when others then
      updatetax_errors(sqlcode,sqlerrm);
      rollback;
      return;
  end updatetax;
  
  function gettaxbetween30and50(esalary_in number)
  return number
  is
    tax_out number(10,2);
  begin
    tax_out:=0.12*esalary_in;
    return tax_out;  
  end gettaxbetween30and50;
  
  function gettaxgreaterthan50(esalary_in number)
  return number
  is
    tax_out number(10,2);
  begin
    tax_out:=0.09*esalary_in;
    return tax_out;  
  end gettaxgreaterthan50;

  function gettaxlessthan30(esalary_in number)
  return number
  is
    tax_out number(10,2);
  begin
    tax_out:=0.07*esalary_in;
    return tax_out;  
  end gettaxlessthan30;

  procedure updatetax_errors(errid_in varchar2, errmessage_in varchar2)
  is
    pragma autonomous_transaction;
  begin
    insert into updatetax_log
    values(errid_in, errmessage_in,sysdate);
    commit;
  end updatetax_errors;
end taxassessment;
/
