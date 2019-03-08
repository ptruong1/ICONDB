

CREATE PROCEDURE [dbo].[p_Report_Tax_Billed_01042017]
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS


(SELECT  
		[ReferenceNo]
      ,tblBilltype.Descript  as  BillType
      ,[FedTax]
      ,[StateTax]
      ,[LocalTax]
      ,[BilledDate]
      ,[BilledStatus]
      ,[BillToNo]
      ,[BilledRevenue]
	  ,1 as recordID
	  ,tblTaxesBilled.State
	  ,TaxingJurisName
  FROM [leg_Icon].[dbo].[tblTaxesBilled] with(nolock) 
  left join tblBilltype with(nolock) on tblTaxesBilled.Billtype = tblBilltype.billtype
  left join tblTaxes with(nolock) on  tblTaxesBilled.taxID = tblTaxes.taxID

  where (BilledDate between @fromDate and dateadd(d,1,@todate) )
 
  and BilledStatus = 1

  Union

  SELECT 
		Null [ReferenceNo]
      ,Null BillType
      ,sum( [FedTax])
      ,sum ([StateTax])
      ,sum ([LocalTax])
      ,Null [BilledDate]
      ,1 [BilledStatus]
      ,'Total Juris' [BillToNo]
      ,sum([BilledRevenue])
	  ,2 as RecordID
	  ,tblTaxesBilled.State as State
	  ,TaxingJurisName as TaxingJurisName
  FROM [leg_Icon].[dbo].[tblTaxesBilled] with(nolock) 
  left join tblBilltype with(nolock) on tblTaxesBilled.Billtype = tblBilltype.billtype
  left join tblTaxes with(nolock) on  tblTaxesBilled.TaxID = tblTaxes.taxID

  where (BilledDate between @fromDate and dateadd(d,1,@todate) )
 
  and BilledStatus = 1
  
  group by BilledStatus, tblTaxesBilled.State, TaxingJurisName

   Union

  SELECT 
		Null [ReferenceNo]
      ,Null BillType
      ,sum( [FedTax])
      ,sum ([StateTax])
      ,sum ([LocalTax])
      ,Null [BilledDate]
      ,1 [BilledStatus]
      ,'Total State' [BillToNo]
      ,sum([BilledRevenue])
	  ,3 as RecordID
	  ,tblTaxesBilled.State as State
	  ,'' TaxingJurisName
  FROM [leg_Icon].[dbo].[tblTaxesBilled] with(nolock) 
  left join tblBilltype with(nolock) on tblTaxesBilled.Billtype = tblBilltype.billtype
  
  where (BilledDate between @fromDate and dateadd(d,1,@todate) )
  
  and BilledStatus = 1
  
  group by BilledStatus, tblTaxesBilled.State
  
  Union
  
  SELECT 
		Null [ReferenceNo]
      ,Null BillType
      ,sum( [FedTax])
      ,sum ([StateTax])
      ,sum ([LocalTax])
      ,Null [BilledDate]
      ,1 [BilledStatus]
      ,'Total All' [BillToNo]
      ,sum([BilledRevenue])
	  ,4 as RecordID
	  ,'WW' [State]
	  ,Null TaxingJurisName
  from 

	  

	  (SELECT  [ReferenceNo]
      ,[BillType]
      ,[FedTax]
      ,[StateTax]
      ,[LocalTax]
      ,[BilledDate]
      ,[BilledStatus]
      ,[BillToNo]
      ,[BilledRevenue]
      ,tblTaxesBilled.State
	  ,TaxingJurisName
  FROM [leg_Icon].[dbo].[tblTaxesBilled]
  left join tblTaxes with(nolock) on  tblTaxesBilled.TaxID = tblTaxes.taxID
  where BilledStatus = 1
  and (BilledDate between @fromDate and dateadd(d,1,@todate) ))

  as X
  group by X.BilledStatus
  
  )

  order by BilledStatus, tblTaxesBilled.State, RecordID
