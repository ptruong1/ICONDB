CREATE PROCEDURE [dbo].[p_get_Account_Balance_ServiceFee]
@AccountNo	varchar(12)
 AS
SET nocount on;
Declare @balance  numeric(8,2), @status tinyint, @facilityID int,@ServiceFee money, @toCity varchar(10),@toState varchar(2),@MinCallCharge int, @feePerCentage numeric(4,2) ; 

set @balance =0;
set @status =0;
SET @ServiceFee =0;
SET @facilityID =1;
SET @feePerCentage = 0;

if(len(@AccountNo) =11 and left(@AccountNo,1) in ('1','0'))   -- Edit on 12/2/2016 to detect 1 or 0 infront 
 Begin
	SET @AccountNo = right(@AccountNo,10) ;
 End
	

select @balance= balance, @status = [status],@facilityID = FacilityID   from tblprepaid with(nolock) where  phoneno = @AccountNo ;

if(@status =0)
 begin
	 select @facilityID = facilityID, @toState =ToState , @toCity = toCity  from tblOnCalls  with(nolock) where tono = @AccountNo;
	 if(@toState is null or @toState ='')
		select @toState=[state], @toCity=[Place Name] from tblTPM with(nolock) where npa =left(@AccountNo ,3) and nxx = substring(@AccountNo,4,3);
	 EXEC p_register_new_prepaid_Account3
									@FacilityID,	
									@AccountNo,
									'Set up prepaid now',
									@toCity,
									'', 
									@toState,
									1,
									'USA',
									'ICON Transfer',
									'For Prepaid',
									'no@email.com',
									@AccountNo,
									'Auto',
									'NA',
									1,
									0,
									'' ;
 end

if(select COUNT(*) from tblPurchase with(nolock) where AccountNo =@AccountNo) = 0
	 begin
		Select @ServiceFee = FeeAmountAuto +  isnull(FeePercent,0) * 25 from tblFees where FacilityID =@facilityID and FeeDetailID =1;
		if(@ServiceFee =0 or @ServiceFee is null )
			Select @ServiceFee = FeeAmount from tblFees with(nolock) where FacilityID =0 and FeeDetailID =1;
	 end
else
	 begin
		Select @ServiceFee = FeeAmountAuto + isnull(FeePercent,0) * 25 from tblFees where FacilityID =@facilityID and FeeDetailID =5
		if(@ServiceFee =0 or @ServiceFee is null )
			Select @ServiceFee = FeeAmount from tblFees with(nolock) where FacilityID =0 and FeeDetailID =5;
	 end	

--If (@ServiceFee>1) SET @ServiceFee= @ServiceFee-1;  
--- Will Update on Monday
-- EXEC	 [dbo].[p_get_minimum_call_charge]		@AccountNo,	'10', @MinCallCharge OUTPUT   

Select @status as [Status],@balance as Balance, @ServiceFee as ServiceFee, @facilityID as FacilityID --, @MinCallCharge as MinimumPurchase;
