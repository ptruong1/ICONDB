

CREATE FUNCTION dbo.fn_getCurrentBadDebt (@AgentID int, @facilityID	int,     @BillType char(2),  @Calltype  char(2))
RETURNS numeric(4,2)  AS  
BEGIN 
	Declare  @rate numeric(4,2)
	SET  @rate =0
		Select  @rate =  Rate from tblBadDebt with(nolock) where  AgentID = @AgentID  and Billtype = @billtype and Calltype = @calltype
	

	return    @rate
END



