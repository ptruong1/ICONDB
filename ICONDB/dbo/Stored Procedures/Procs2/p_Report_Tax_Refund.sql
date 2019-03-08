

CREATE PROCEDURE [dbo].[p_Report_Tax_Refund]
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS
 
((SELECT 
	[RefundID]
      ,[BillToNo]
      ,tblBillType.Descript
      ,[RefundAmount]
      ,[FedTaxRef]
      ,[StateTaxRef]
      ,[LocalTaxRef]
      ,[RefundDate]
      
      ,[State]
	  	  ,1 as recordID
  FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock), tblBilltype with(nolock)

  where (RefundDate between @fromDate and dateadd(d,1,@todate) )
  and tblTaxesRefund.Billtype = tblBilltype.billtype
  )
  union

  (SELECT
		Null RefundID 
      ,'Total' [BillToNo]
      ,Null Descript
      ,sum([RefundAmount])
      ,sum([FedTaxRef])
      ,sum([StateTaxRef])
      ,sum([LocalTaxRef])
      ,Null [RefundDate]
      
      ,[State]
	  
	  ,2 as recordID
  FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock), tblBilltype with(nolock)

  where (RefundDate between @fromDate and dateadd(d,1,@todate) )
  and tblTaxesRefund.Billtype = tblBilltype.billtype

  group by State)
  
  Union
  
  (SELECT
		Null RefundID 
      ,'Total All' [BillToNo]
      ,Null Descript
      ,sum([RefundAmount])
      ,sum([FedTaxRef])
      ,sum([StateTaxRef])
      ,sum([LocalTaxRef])
      ,Null [RefundDate]
      
      ,'WW' [State]
	  
	  ,3 as recordID
  FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock), tblBilltype with(nolock)

  where (RefundDate between @fromDate and dateadd(d,1,@todate) )
  and tblTaxesRefund.Billtype = tblBilltype.billtype))

  order by [State], RecordID

