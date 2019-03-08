

CREATE FUNCTION dbo.fn_getCurrentCommRate (@AgentID int, @FacilityID int,    @BillType char(2),  @Calltype  char(2))
RETURNS numeric(4,2)  AS  
BEGIN 
	Declare  @rate numeric(4,2)
	SET  @rate =0
		Select  @rate =  CommRate from tblCommRate  with(nolock) where  facilityID = @FacilityID and   AgentID = @AgentID  and Billtype = @billtype and Calltype = @calltype
	

	return    @rate
END


