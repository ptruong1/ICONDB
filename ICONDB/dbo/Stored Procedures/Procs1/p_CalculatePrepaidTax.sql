
CREATE PROCEDURE  [dbo].[p_CalculatePrepaidTax]
(@PurchaseAmount numeric(7,2), 
@AccountNo varchar(12),
@Tax  numeric(5,2),
@PurchaseNo bigint)
 AS  
BEGIN 
	SET NOCOUNT ON;	
	DECLARE @taxID int, @CurrentDate date, @FacilityID int, @FacilityState Varchar(2), @AccountState varchar(2) ;
	SET @facilityID =1;
	SET @Tax =0;
	Select @AccountState = a.StateCode, @FacilityID = b.FacilityID from tblstates a with(nolock) , tblPrepaid b with(nolock) where a.StateID =b.StateID and b.PhoneNo = @AccountNo; 
	select @FacilityState = [state] from tblfacility with(nolock) where facilityID = @FacilityID;
	SET @CurrentDate = getdate();
	if(@Tax >0)
	 begin
		If( @FacilityState <> @AccountState )
		 begin
			 select @taxID = taxID from tbltaxes with(nolock) where State='US' ;
			 Insert tblTaxesBilled(ReferenceNo, billtype, FedTax, StateTax,LocalTax, BilledDate, BilledStatus, BillToNo,BilledRevenue,state, taxID, CallType)
						Values(@PurchaseNo,'10', @Tax,0,0, getdate(),1,@AccountNo,@PurchaseAmount,'US',  @taxID, 'ST' );
		 end
		 else
		  begin 
			 Declare @stateTax numeric(4,2);
			 DECLARE TaxCurr CURSOR FOR SELECT taxID, (isnull(Amount,0) + @PurchaseAmount * isnull( Rate,0)) as StateTax from tblTaxes with(nolock) 
					where state= @FacilityState and ((startdate <= @CurrentDate and EndDate >= @CurrentDate) or  (startdate <= @CurrentDate and EndDate is null)  or  (startdate is null and EndDate is null))   ;
				 OPEN TaxCurr;
				 FETCH NEXT FROM TaxCurr INTO @taxID, @stateTax;
				 WHILE @@FETCH_STATUS = 0  
					BEGIN  
						if(@stateTax>0)
							Insert tblTaxesBilled(ReferenceNo, billtype, FedTax, StateTax,LocalTax, BilledDate, BilledStatus, BillToNo,BilledRevenue,State, taxID, CallType)
												Values(@PurchaseNo,'10', 0, @StateTax, 0, getdate(),1,@AccountNo,@PurchaseAmount,@FacilityState,  @taxID, 'RL' );
					
						FETCH NEXT FROM TaxCurr INTO @taxID, @stateTax;
					END  
  
				CLOSE TaxCurr;  
				DEALLOCATE TaxCurr;  
			end
		end
END

