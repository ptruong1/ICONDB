

CREATE PROCEDURE [dbo].[p_Report_Tax_Billed]
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
	  ,[State]
  FROM [leg_Icon].[dbo].[tblTaxesBilled] with(nolock), tblBilltype with(nolock)

  where (BilledDate between @fromDate and dateadd(d,1,@todate) )
  and tblTaxesBilled.Billtype = tblBilltype.billtype
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
      ,'Total' [BillToNo]
      ,sum([BilledRevenue])
	  ,2 as RecordID
	  ,[State]
  FROM [leg_Icon].[dbo].[tblTaxesBilled] with(nolock), tblBilltype with(nolock)

  where (BilledDate between @fromDate and dateadd(d,1,@todate) )
  and tblTaxesBilled.Billtype = tblBilltype.billtype
  and BilledStatus = 1
  
  group by BilledStatus, [State]
  
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
	  ,3 as RecordID
	  ,'WW' [State]
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
      ,[State]
  FROM [leg_Icon].[dbo].[tblTaxesBilled]
  where BilledStatus = 1
  and (BilledDate between @fromDate and dateadd(d,1,@todate) ))

  as X
  group by X.BilledStatus
  )

  order by BilledStatus, [State], RecordID

