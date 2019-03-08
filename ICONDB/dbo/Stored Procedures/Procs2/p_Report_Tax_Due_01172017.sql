

CREATE PROCEDURE [dbo].[p_Report_Tax_Due_01172017]
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS


Declare @Taxtable table([State] varchar(2), [BillToNo] varchar(12), [FedTax] decimal(5,2), [StateTax] decimal(5,2), [LocalTax] decimal(5,2), 
[Revenue] decimal(6,2), [BilledDate] dateTime, [RecordID] int, TransType varchar(25), TaxingJurisName varchar(50), CallCounts int, CallType varchar(2), TaxID tinyint);

Insert @TaxTable

SELECT  B.State, BillToNo, 
--case when B.Calltype = 'ST' then [FedTax] else 0 end as FedTax,
FedTax,
[StateTax], [LocalTax],
--case when B.CallType = 'ST' then [BilledRevenue] else 0 end as BilledRevenue,
BilledRevenue,
[BilledDate], 1 as recordID, 'Billed', TaxingJurisName, 
--case when Calltype = 'ST' then 0 else 1 end as CallCounts, 
1 as CallCounts,
B.CallType,
B.TaxID 
  FROM [leg_Icon].[dbo].[tblTaxesBilled] B with(nolock)
  left join tblTaxes with(nolock) on  B.TaxID = tblTaxes.taxID
    where (B.BilledDate between @fromDate and dateadd(d,1,@todate) )
   and BilledStatus = 1
  --and B.State = 'CA' 

  Union All

  Select B.State, [BillToNo], 
  --case when B.CallType = 'ST' then  ([FedTaxRef] * -1) else 0 end as 
  FedTaxRef,
  ([StateTaxRef] * -1), ([LocalTaxRef] * -1), 
  --case when B.CallType = 'ST' then ([RefundAmount] * -1) else 0 end as RefundAmount,
  ([RefundAmount] * -1) as RefundAmount, 
  [RefundDate], 
  2 as recordID, 
  'Refund/Adjustments', TaxingJurisName, 
  --case when Calltype = 'ST' then 0 else 1 end as CallCounts, 
	1 as CallCounts, 
  B.CallType, B.TaxCategoryID 
  FROM [leg_Icon].[dbo].[tblTaxesRefund] B with(nolock)
  left join tblTaxes with(nolock) on  B.StateAccountNameID = tblTaxes.taxID
  
  where (RefundDate between @fromDate and dateadd(d,1,@todate))
  
  order by B.State, BillToNo, RecordID;

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
  
  -- Union

	 --select State
		--,'Total State' TaxingJurisName
		--,sum(CallCounts) as Calls
		--,Sum(Revenue) as Revenue
		--,sum(FedTax) as FedTaxDue
		--,sum(StateTax) as StateTaxDue
		--,Sum(LocalTax) as LocalTaxDue
		
		--,4 RecordID
		
	
	 -- from @TaxTable

	 -- Group By State
  
	Union

	  select
	    'WW' State
		,'Federal USF' TaxingJurisName
		,sum(CallCounts) as Calls 
		,Sum(Revenue) as Revenue
		,sum(FedTax) as FedTaxDue
		,sum(FedTax) as StateTaxDue --use state column as fed tax due
		,Sum(LocalTax) as LocalTaxDue
		
		,5 RecordID
		,Null taxID		
	  from @TaxTable
	  where CallType = 'ST' and TaxID = 1

  )

  order by State, recordID
