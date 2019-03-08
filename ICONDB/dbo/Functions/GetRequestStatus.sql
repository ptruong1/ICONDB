create function GetRequestStatus(@RequestStatus smallint)
returns varchar(50) 
as
begin
  return (select Descript from tblRequestStatus where RequestStatus=@RequestStatus)
end