
CREATE PROCEDURE  [dbo].[p_CalculateCallFees]
 (@facilityID int,
@AccountNo varchar(19),
@chargeDate varchar(4), 
@CallRevenue numeric(7,2), 
@RecordID  bigint,
@transFee numeric(4,2)  OUTPUT, 
@billSTFee numeric(4,2) OUTPUT)
 AS  
BEGIN 
	SET NOCOUNT ON ;
	Declare @AgentID int;
	Select @AgentID = agentID from tblFacility with(nolock) where FacilityID = @facilityID;

	If(@AgentID =404)
	 begin
		SET @transFee =0;
		SET @billSTFee  = 0;
	 end

	select @transFee =  FeeAmount + @CallRevenue*FeePercent from tblFees where facilityID=@facilityID and FeeDetailID=10;
	if(@transFee is null)
		select @transFee =  FeeAmount + @CallRevenue*FeePercent from tblFees where facilityID=0 and FeeDetailID=10;
	
	If(SELECT count(*)  FROM [tblFeeBilled] where AccountNo=@AccountNo and chargeDate=@chargeDate) =0
	 begin
		select @billSTFee =  FeeAmount + @CallRevenue*FeePercent from tblFees where facilityID=@facilityID and FeeDetailID=9;
		if(@billSTFee is null)
			select @billSTFee =  FeeAmount + @CallRevenue*FeePercent from tblFees where facilityID=0 and FeeDetailID=9;
		if(@billSTFee > 0)
			insert [tblFeeBilled]  values(@AccountNo , 9,@billSTFee, @chargeDate,getdate(),@RecordID,@facilityID );
			

	 end
	 
	SET @transFee = Isnull(@transFee ,0);
	SET @billSTFee  = Isnull(@billSTFee  ,0);
END
