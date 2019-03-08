

CREATE PROCEDURE [dbo].[p_Report_Tax_Refund_01042017]
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
      ,1 as recordID
	  ,tblTaxesRefund.State
	  ,TaxingJurisName
  FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock)
  left join tblBilltype with(nolock) on tblTaxesRefund.Billtype = tblBilltype.billtype
  left join tblTaxes with(nolock) on  tblTaxesRefund.StateAccountNameID = tblTaxes.taxID

  where (RefundDate between @fromDate and dateadd(d,1,@todate) )
  
  )
  union

  (SELECT 
		Null RefundID 
      ,'Total Juris' [BillToNo]
      ,Null Descript
      ,sum([RefundAmount])
      ,sum([FedTaxRef])
      ,sum([StateTaxRef])
      ,sum([LocalTaxRef])
      ,Null [RefundDate]
      ,2 as recordID
	  ,tblTaxesRefund.State
	  ,TaxingJurisName
  FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock)
  left join tblBilltype with(nolock) on tblTaxesRefund.Billtype = tblBilltype.billtype
  left join tblTaxes with(nolock) on  tblTaxesRefund.StateAccountNameID = tblTaxes.taxID

  where (RefundDate between @fromDate and dateadd(d,1,@todate) )
  
  group by tblTaxesRefund.State, TaxingJurisName)

   Union

  (SELECT
		Null RefundID 
      ,'Total State' [BillToNo]
      ,Null Descript
      ,sum([RefundAmount])
      ,sum([FedTaxRef])
      ,sum([StateTaxRef])
      ,sum([LocalTaxRef])
      ,Null [RefundDate]
      ,3 as recordID
	  ,tblTaxesRefund.State
	  ,'' TaxingJurisName

  FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock)
  left join tblBilltype with(nolock) on tblTaxesRefund.Billtype = tblBilltype.billtype
  left join tblTaxes with(nolock) on  tblTaxesRefund.StateAccountNameID = tblTaxes.taxID


  where (RefundDate between @fromDate and dateadd(d,1,@todate) )
  
  group by tblTaxesRefund.State)
  
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
      ,4 as recordID
	  ,'' TaxingJurisName
      ,'WW' [State]
  
  FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock), tblBilltype with(nolock)

  where (RefundDate between @fromDate and dateadd(d,1,@todate) )
  and tblTaxesRefund.Billtype = tblBilltype.billtype))

  order by  RecordID
