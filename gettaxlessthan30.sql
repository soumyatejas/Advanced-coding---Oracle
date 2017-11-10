create or replace function gettaxlessthan30(esalary_in number)
return number
is
  tax_out number(10,2);
begin
  tax_out:=0.07*esalary_in;
  return tax_out;  
end;
/