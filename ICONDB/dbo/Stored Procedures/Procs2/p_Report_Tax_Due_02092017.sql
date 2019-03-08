

CREATE PROCEDURE [dbo].[p_Report_Tax_Due_02092017]
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS


Declare @Taxtable table([State] varchar(2), [BillToNo] varchar(12), [FedTax] decimal(5,2), [StateTax] decimal(5,2), [LocalTax] decimal(5,2), 
[Revenue] decimal(6,2), [BilledDate] dateTime, [RecordID] int, TransType varchar(25), TaxingJurisName varchar(50), CallCounts int, CallType varchar(2), TaxID tinyint);

Insert @TaxTable

SELECT case when B.State = 'US' then 'WW' else B.State end as [State], 
BillToNo, 
FedTax,
case when B.State = 'US' then [FedTax] else StateTax end as StateTax,
[LocalTax],

BilledRevenue,
[BilledDate], 1 as recordID, 'Billed', TaxingJurisName, 
 
1 as CallCounts,
B.CallType,
B.TaxID 
  FROM [leg_Icon].[dbo].[tblTaxesBilled] B with(nolock)
  left join tblTaxes with(nolock) on  B.TaxID = tblTaxes.taxID
    where (B.BilledDate between @fromDate and dateadd(d,1,@todate) )
   and BilledStatus = 1

   Union All

 Select case when B.State = 'US' then 'WW' else B.State end as [State], [BillToNo], 
  
  FedTaxRef,
  case when B.State = 'US' then (FedTaxRef * -1) else ([StateTaxRef] * -1) end as StateTaxRef,
  ([LocalTaxRef] * -1), 
  
  ([RefundAmount] * -1) as RefundAmount, 
  [RefundDate], 
  2 as recordID, 
  'Refund/Adjustments', TaxingJurisName, 
  
	1 as CallCounts, 
  B.CallType, B.TaxCategoryID 
  FROM [leg_Icon].[dbo].[tblTaxesRefund] B with(nolock)
  left join tblTaxes with(nolock) on  B.StateAccountNameID = tblTaxes.taxID
  
  where (RefundDate between @fromDate and dateadd(d,1,@todate))
  
  --order by B.State, BillToNo, RecordID

 

	(select State
		,TaxingJurisName
		,sum(CallCounts) as Calls
		,Sum(Revenue) as Revenue
		,sum(FedTax) as FedTaxDue
		,sum(StateTax) as StateTaxDue
		,Sum(LocalTax) as LocalTaxDue
		
		,3 RecordID
		,Null taxID	
	  from @TaxTable

	  Group By State, TaxingJurisName
  
  

  )

  order by State, recordID 
