create or replace function gettaxgreaterthan50(esalary_in number)
return number
is
  tax_out number(10,2);
begin
  tax_out:=0.09*esalary_in;
  return tax_out;  
end;
/