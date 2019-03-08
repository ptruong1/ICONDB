

CREATE PROCEDURE [dbo].[p_Report_Tax_Due_01042017]
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS


Declare @Taxtable table([State] varchar(2), [BillToNo] varchar(10), [FedTax] decimal(5,2), [StateTax] decimal(5,2), [LocalTax] decimal(5,2), 
[Revenue] decimal(6,2), [BilledDate] dateTime, [RecordID] int, TransType varchar(25), TaxingJurisName varchar(50));

Insert @TaxTable

SELECT  B.State, BillToNo, [FedTax], [StateTax], [LocalTax],[BilledRevenue],[BilledDate], 1 as recordID, 'Billed', TaxingJurisName 
  FROM [leg_Icon].[dbo].[tblTaxesBilled] B with(nolock)
  left join tblTaxes with(nolock) on  B.TaxID = tblTaxes.taxID
    where (B.BilledDate between @fromDate and dateadd(d,1,@todate) )
   and BilledStatus = 1
  --and B.State = 'CA' 

  Union All

  Select B.State, [BillToNo], ([FedTaxRef] * -1), ([StateTaxRef] * -1), ([LocalTaxRef] * -1), ([RefundAmount] * -1), [RefundDate], 2 as recordID, 
  'Refund/Adjustments', TaxingJurisName 
  FROM [leg_Icon].[dbo].[tblTaxesRefund] B with(nolock)
  left join tblTaxes with(nolock) on  B.StateAccountNameID = tblTaxes.taxID
  --Select [State], [BillToNo], ([FedTaxRef] ), ([StateTaxRef] ), ([LocalTaxRef] ), ([RefundAmount] ), [RefundDate], 2 as recordID, 'Refund/Adjustments'
  --FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock)

  where (RefundDate between @fromDate and dateadd(d,1,@todate))
  
  order by B.State, BillToNo, RecordID;

  (Select State, BillToNo, [FedTax], [StateTax], [LocalTax],[Revenue],[BilledDate], recordID, TransType, TaxingJurisName  
  from @TaxTable

  union

	select State
		,'Total Juris' BillToNo
		,sum(FedTax) as FedTaxDue
		,sum(StateTax) as StateTaxDue
		,Sum(LocalTax) as LocalTaxDue
		,Sum(Revenue) as Revenue
		,Null BilledDate
		,3 RecordID
		,Null TransType
		,TaxingJurisName
		
	  from @TaxTable

	  Group By State, TaxingJurisName
  
  Union

	 select State
		,'Total State' BillToNo
		,sum(FedTax) as FedTaxDue
		,sum(StateTax) as StateTaxDue
		,Sum(LocalTax) as LocalTaxDue
		,Sum(Revenue) as Revenue
		,Null BilledDate
		,4 RecordID
		,Null TransType
		,Null TaxingJurisName
		

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
		,5 RecordID
		,Null TransType
		,Null TaxingJurisName
		
		

	  from @TaxTable

  )

  order by State, recordID
