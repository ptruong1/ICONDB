

CREATE PROCEDURE [dbo].[p_Report_Tax_Billed_02092017]
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS


Declare @Taxtable table([State] varchar (2), TaxingJurisName varchar(50)
      ,BillTypeDesc varchar(30)
	  ,CallCounts tinyint
	  ,[BilledRevenue] decimal(5,2)
      ,[FedTax] decimal(5,2)
      ,[StateTax] decimal(5,2)
      ,[LocalTax] decimal(5,2)
      ,[BilledDate] SmallDatetime
      ,[BilledStatus] int
      ,[BillToNo] varchar(12)
      
	  ,recordID tinyint
	  ,[ReferenceNo] varchar(12)
	  ,[CallType] varchar(2)
	  ,[TaxID] tinyint
	  )

	  Insert @TaxTable

SELECT case when tblTaxesBilled.State = 'US' then 'WW' else tblTaxesBilled.State end as [State], 
TaxingJurisName,tblBilltype.Descript as BillType, 1 as CallCounts,[BilledRevenue], [FedTax],
case when tblTaxesBilled.State = 'US' then [FedTax] else StateTax end as StateTax,
[LocalTax],[BilledDate],[BilledStatus],
[BillToNo],1 as recordID,[ReferenceNo], Calltype, tblTaxesBilled.TaxID
	  
  FROM [leg_Icon].[dbo].[tblTaxesBilled] with(nolock) 
  left join tblBilltype with(nolock) on tblTaxesBilled.Billtype = tblBilltype.billtype
  left join tblTaxes with(nolock) on  tblTaxesBilled.taxID = tblTaxes.taxID

  where (BilledDate between @fromDate and dateadd(d,1,@todate) )
 
  and BilledStatus = 1 
  order by tblTaxesBilled.State, TaxingJurisName ;

   --Select all

 ( SELECT State,TaxingJurisName,BillTypeDesc, CallCounts,[BilledRevenue], [FedTax],[StateTax],[LocalTax],[BilledDate],[BilledStatus],
  [BillToNo],1 as recordID,[ReferenceNo],[CallType], TaxID

  FROM @Taxtable

  

  union -- Summary by Jurisname

  SELECT State,TaxingJurisName, 'Total Juris' BillTypeDesc, sum(CallCounts),sum([BilledRevenue]), sum([FedTax]),sum([StateTax]),sum([LocalTax]),Null [BilledDate], 1 as [BilledStatus],
  Null [BillToNo],2 as recordID,Null [ReferenceNo], Null [CallType], Null TaxID

  FROM @Taxtable
  
  group by BilledStatus, State, TaxingJurisName

  union -- Summary by State

  SELECT State, 'XXX' TaxingJurisName, 'Total State' BillTypeDesc, sum(CallCounts),sum([BilledRevenue]), sum([FedTax]),sum([StateTax]),sum([LocalTax]),Null [BilledDate], 1 as [BilledStatus],
  Null [BillToNo],3 as recordID,Null [ReferenceNo], Null [CallType], Null TaxID

  FROM @Taxtable
  
  group by BilledStatus, State

  --union -- Summary by All States

  --SELECT 'WW' State, 'WWW' TaxingJurisName, 'Total All States' BillTypeDesc, sum(CallCounts),sum([BilledRevenue]), sum([FedTax]),sum([StateTax]),sum([LocalTax]),Null [BilledDate], 1 as [BilledStatus],
  --Null [BillToNo],4 as recordID,Null [ReferenceNo], Null [CallType], Null TaxID

  --FROM @Taxtable
  
  --group by BilledStatus

  --union -- Summary by Federal

  --SELECT 'ZZ' State, 'ZZZ' TaxingJurisName, 'Total Federal' BillTypeDesc, sum(CallCounts),sum([BilledRevenue]), 
  --sum([FedTax]) as [FedTax],
  --sum([FedTax]) as [StateTax], -- Use State tax column to show Fed tax
  --sum([LocalTax]),Null [BilledDate], 1 as [BilledStatus],
  --Null [BillToNo],4 as recordID,Null [ReferenceNo], NULL [CallType], Null TaxID

  --FROM @Taxtable   where CallType = 'ST' and TaxID = 1
    
  --group by BilledStatus

  )
  order by BilledStatus, State, TaxingJurisName, RecordID
