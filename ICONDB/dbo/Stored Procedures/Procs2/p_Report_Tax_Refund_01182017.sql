

CREATE PROCEDURE [dbo].[p_Report_Tax_Refund_01182017]
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS
 
Declare @Taxtable table([State] varchar (2), TaxingJurisName varchar(50)
      ,BillTypeDesc varchar(30)
	  ,CallCounts tinyint
	  ,[RefundAmount] decimal(5,2)
      ,[FedTax] decimal(5,2)
      ,[StateTax] decimal(5,2)
      ,[LocalTax] decimal(5,2)
      ,[RefundDate] SmallDatetime
      ,[BillToNo] varchar(12)
      
	  ,recordID tinyint
	  
	  ,[CallType] varchar(2)
	  )

	  Insert @TaxTable

SELECT tblTaxesRefund.State,TaxingJurisName,tblBilltype.Descript as BillType, 1 as CallCounts,[RefundAmount], [FedTaxRef],[StateTaxRef],[LocalTaxRef],[RefundDate],
[BillToNo],1 as recordID,[CallType]
	  
  FROM [leg_Icon].[dbo].[tblTaxesRefund] with(nolock) 
  left join tblBilltype with(nolock) on tblTaxesRefund.Billtype = tblBilltype.billtype
  left join tblTaxes with(nolock) on  tblTaxesRefund.StateAccountNameID = tblTaxes.taxID

  where (RefundDate between @fromDate and dateadd(d,1,@todate) )
 
  order by tblTaxesRefund.State, TaxingJurisName ;

  -- Select all
 ( SELECT State,TaxingJurisName,BillTypeDesc, CallCounts,[RefundAmount], [FedTax],[StateTax],[LocalTax],[RefundDate],
  [BillToNo],1 as recordID,[CallType]

  FROM @Taxtable

  

  union -- Summary by Jurisname

  SELECT State,TaxingJurisName, 'Total Juris' BillTypeDesc, sum(CallCounts),sum([RefundAmount]), sum([FedTax]),sum([StateTax]),sum([LocalTax]),Null [RefundDate],
  Null [BillToNo],2 as recordID,Null [CallType]

  FROM @Taxtable
  
  group by State, TaxingJurisName

  union -- Summary by State

  SELECT State, 'XXX' TaxingJurisName, 'Total State' BillTypeDesc, sum(CallCounts),sum([RefundAmount]), sum([FedTax]),sum([StateTax]),sum([LocalTax]),Null [RefundDate], 
  Null [BillToNo],3 as recordID, Null [CallType]

  FROM @Taxtable
  
  group by State

  union -- Summary by All States

  SELECT 'WW' State, 'WWW' TaxingJurisName, 'Total All' BillTypeDesc, sum(CallCounts),sum([RefundAmount]), sum([FedTax]),sum([StateTax]),sum([LocalTax]),Null [RefundDate],
  Null [BillToNo],4 as recordID,Null [CallType]

  FROM @Taxtable
   

  union -- Summary by Federal

  SELECT 'ZZ' State, 'ZZZ' TaxingJurisName, 'Total All' BillTypeDesc, sum(CallCounts),sum([RefundAmount]), sum([FedTax]),sum([StateTax]),sum([LocalTax]),Null [RefundDate], 
  Null [BillToNo],4 as recordID,Null [CallType]

  FROM @Taxtable   where CallType = 'ST'
    
  

  )
  order by  State, TaxingJurisName, RecordID
