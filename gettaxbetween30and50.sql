create or replace function gettaxbetween30and50(esalary_in number)
return number
is
  tax_out number(10,2);
begin
  tax_out:=0.12*esalary_in;
  return tax_out;  
end;
/