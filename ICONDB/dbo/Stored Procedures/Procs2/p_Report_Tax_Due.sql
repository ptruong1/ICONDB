

CREATE PROCEDURE [dbo].[p_Report_Tax_Due]
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS


Declare @Taxtable table([State] varchar(2), [BillToNo] varchar(10), [FedTax] decimal(5,2), [StateTax] decimal(5,2), [LocalTax] decimal(5,2), 
[Revenue] decimal(6,2), [BilledDate] dateTime, [RecordID] int, TransType varchar(25));

Insert @TaxTable

SELECT  [State], BillToNo, [FedTax], [StateTax], [LocalTax],[BilledRevenue],[BilledDate], 1 as recordID, 'Billed' 
  FROM [leg_Icon].[dbo].[tblTaxesBilled] B with(nolock)
    where (B.BilledDate between @fromDate and dateadd(d,1,@todate) )
   and BilledStatus = 1
  --and B.State = 'CA' 

  Union All

  Select [State], [BillToNo], ([FedTaxRef] * -1), ([StateTaxRef] * -1), ([LocalTaxRef] * -1), ([RefundAmount] * -1), [RefundDate], 2 as recordID, 'Refund/Adjustments'
  FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock)

  --Select [State], [BillToNo], ([FedTaxRef] ), ([StateTaxRef] ), ([LocalTaxRef] ), ([RefundAmount] ), [RefundDate], 2 as recordID, 'Refund/Adjustments'
  --FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock)

  where (RefundDate between @fromDate and dateadd(d,1,@todate))
  
  order by State, BillToNo, RecordID;

	 (Select * from @TaxTable
		union
	 select State
		,'Total' BillToNo
		,sum(FedTax) as FedTaxDue
		,sum(StateTax) as StateTaxDue
		,Sum(LocalTax) as LocalTaxDue
		,Sum(Revenue) as Revenue
		,Null BilledDate
		,3 RecordID
		,Null TransType
	  from @TaxTable

	  Group By State
	  
	  Union
	  select
	    'WW' State
		,'Total All' BillToNo
		,sum(FedTax) as FedTaxDue
		,sum(StateTax) as StateTaxDue
		,Sum(LocalTax) as LocalTaxDue
		,Sum(Revenue) as Revenue
		,Null BilledDate
		,4 RecordID
		,Null TransType
	  from @TaxTable

	  )

	 order by State, recordID

