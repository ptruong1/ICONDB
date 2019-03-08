
CREATE PROCEDURE  [dbo].[p_EstimatePrepaidTax]
(@PurchaseAmount numeric(7,2), 
@AccountNo varchar(12),
@Tax  numeric(5,2)  OUTPUT)
 AS  
BEGIN 
	SET NOCOUNT ON;	
	DECLARE @taxID int, @CurrentDate date, @FacilityID int, @FacilityState Varchar(2), @AccountState varchar(2), @counrtyID int ;
	SET @facilityID =1;
	SET @Tax =0;
	SET @counrtyID =203;
	Select @counrtyID = b.CountryID,  @AccountState = a.StateCode, @FacilityID = b.FacilityID from tblstates a with(nolock) , tblPrepaid b with(nolock) where a.StateID =b.StateID and b.PhoneNo = @AccountNo; 
	select @FacilityState = [state] from tblfacility with(nolock) where facilityID = @FacilityID;
	if( @FacilityState ='US' or @counrtyID =0) 
	 begin
		select @AccountState = [state] from tblTPM with(nolock) where  NPA= left(@AccountNo,3);
	 end
	SET @CurrentDate = getdate();
	If( @FacilityState <> @AccountState)
	 begin
		Select  @Tax = isnull(Amount,0) + @PurchaseAmount * isnull( Rate,0) from tblTaxes with(nolock)  where State ='US' 
		  and ((startdate <= @CurrentDate and EndDate >= @CurrentDate) or  (startdate <= @CurrentDate and EndDate is null)  or  (startdate is null and EndDate is null))   ;
	 end
	 else
	  begin 
		 If (select count(*) from tblTaxes with(nolock)  where state= @FacilityState) >0
		  begin
		 
			 Select @tax = Sum((@PurchaseAmount * isnull( Rate,0)) + isnull(Amount,0))  from tblTaxes with(nolock) 
				where state= @FacilityState and ((startdate <= @CurrentDate and EndDate >= @CurrentDate) or  (startdate <= @CurrentDate and EndDate is null)  or  (startdate is null and EndDate is null))   ;
			 
		  end
		  SET @tax  = isnull(@tax ,0);
		end
END

