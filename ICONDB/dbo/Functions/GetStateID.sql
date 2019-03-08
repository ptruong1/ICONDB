create function GetStateID(@StateCode char(2))
returns smallint
begin
	return (select StateID from tblStates where StateCode=@StateCode)
end
