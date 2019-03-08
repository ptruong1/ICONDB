
CREATE PROCEDURE  [dbo].[p_CalculateCallTaxes_v1]
 (@facilityID int,
@CallRevenue numeric(7,2), 
@RecordID  bigint,
@FromState  varchar(2),
@ToState  varchar(2),
@ToCity  varchar(10),
@Calltype varchar(2),
@BillType varchar(2),
@toNo	 varchar(12),
@FedTax numeric(4,2)  OUTPUT, 
@TotalStateTax numeric(4,2) OUTPUT,
@TotalLocalTax numeric(4,2) OUTPUT)
 AS  
BEGIN 
	SET NOCOUNT ON;
	DECLARE @taxID int, @CurrentDate date, @StateTax numeric(4,2) , @LocalTax numeric(4,2);
	SET @FedTax =0;
	SET @StateTax =0;
	SET @LocalTax =0;
	SET @TotalStateTax =0;
	SET @TotalLocalTax =0;
	SET @CurrentDate = getdate();
	If(@Calltype in ('ST', 'IN'))
	 begin
		Select @taxID = taxID, @FedTax = isnull(Amount,0) + @CallRevenue * isnull( Rate,0) from tblTaxes with(nolock)  where State ='US' 
		  and ((startdate <= @CurrentDate and EndDate >= @CurrentDate) or  (startdate <= @CurrentDate and EndDate is null)  or  (startdate is null and EndDate is null))   ;

		If (@FedTax >0 )
		 begin
			Insert tblTaxesBilled(ReferenceNo, billtype, FedTax, StateTax,LocalTax, BilledDate, BilledStatus, BillToNo,BilledRevenue,state, taxID, CallType)
					Values(@RecordID,@BillType, @FedTax, @StateTax, @LocalTax, getdate(),0,@toNo,@CallRevenue,'US',  @taxID,'ST' );
		 end
	 end
	 else
	  begin 
		 If (select count(*) from tblTaxes with(nolock)  where state= @FromState) >0
		  begin
		 
			 DECLARE TaxCurr CURSOR FOR SELECT taxID, (isnull(Amount,0) + @CallRevenue * isnull( Rate,0)) as StateTax from tblTaxes with(nolock) 
				where state= @FromState and ((startdate <= @CurrentDate and EndDate >= @CurrentDate) or  (startdate <= @CurrentDate and EndDate is null)  or  (startdate is null and EndDate is null))   ;
			 OPEN TaxCurr;
			 FETCH NEXT FROM TaxCurr INTO @taxID, @stateTax;
			 WHILE @@FETCH_STATUS = 0  
				BEGIN  
				    if(@stateTax>0)
						Insert tblTaxesBilled(ReferenceNo, billtype, FedTax, StateTax,LocalTax, BilledDate, BilledStatus, BillToNo,BilledRevenue,State, taxID, CallType )
											Values(@RecordID,@BillType, 0, @StateTax, 0, getdate(),0,@toNo,@CallRevenue,@FromState,  @taxID, 'RL' );
					SET @TotalStateTax = @TotalStateTax + @StateTax;
					FETCH NEXT FROM TaxCurr INTO @taxID, @stateTax;
				END  
  
			CLOSE TaxCurr;  
			DEALLOCATE TaxCurr;  
		  end
		end
END

