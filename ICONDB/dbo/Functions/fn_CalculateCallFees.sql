
CREATE FUNCTION [dbo].[fn_CalculateCallFees]
 (@facilityID int,@AccountNo varchar(19),@chargeDate varchar(4), @CallRevenue numeric(7,2))
RETURNS   Numeric(5,2) AS  
BEGIN 
	Declare    @transFee numeric(4,2), @billSTFee numeric(4,2)
	select @transFee =  FeeAmount + @CallRevenue*FeePercent from tblFees where facilityID=@facilityID and FeeDetailID=10
	if(@transFee is null)
		select @transFee =  FeeAmount + @CallRevenue*FeePercent from tblFees where facilityID=0 and FeeDetailID=10
	
	If(SELECT count(*)  FROM [tblFeeBilled] where AccountNo=@AccountNo and chargeDate=@chargeDate) =0
	 begin
		select @billSTFee =  FeeAmount + @CallRevenue*FeePercent from tblFees where facilityID=@facilityID and FeeDetailID=9
		if(@billSTFee is null)
			select @billSTFee =  FeeAmount + @CallRevenue*FeePercent from tblFees where facilityID=0 and FeeDetailID=9
	 end
	 
	return isnull(@transFee,0) +  isnull(@billSTFee,0)
END














