
CREATE PROCEDURE  [dbo].[p_CalculateCallTaxes]
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
@StateTax numeric(4,2) OUTPUT,
@LocalTax numeric(4,2) OUTPUT)
 AS  
BEGIN 
	SET NOCOUNT ON;
	DECLARE @taxID int;
	SET @FedTax =0;
	SET @StateTax =0;
	SET @LocalTax =0;
	If(@Calltype in ('ST', 'IN'))
		Select @taxID = taxID, @FedTax = isnull(Amount,0) + @CallRevenue * isnull( Rate,0) from tblTaxes  where State ='US' and StartDate < GETDATE() AND EndDate > GETDATE() ;

	If (@FedTax >0 or  @StateTax > 0 or  @LocalTax > 0)
		Insert tblTaxesBilled(ReferenceNo, billtype, FedTax, StateTax,LocalTax, BilledDate, BilledStatus, BillToNo,BilledRevenue, taxID, CallType)
				Values(@RecordID,@BillType, @FedTax, @StateTax, @LocalTax, getdate(),0,@toNo,@CallRevenue,  @taxID , 'ST');

END

