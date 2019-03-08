CREATE PROCEDURE [dbo].[p_Fraud_Alert] 

AS

Declare @totalRevenue  numeric(7,2) ,   @billedPerDay  int,  @billedPerWeek int, @billedPerMonth int


select  @totalRevenue = sum(isnull(callRevenue,0)  )  , @billedPerDay  = count( callRevenue)  from tblcallsbilled with(nolock) where   complete is null   and billtype ='01'  and dateDiff(d, RecordDate,getdate() )  =0

If (  @totalRevenue  >50) 
 Begin
	
	 return 0
 End
select  @totalRevenue = sum(isnull(callRevenue,0)  ) , @billedPerWeek  = count( callRevenue)   from tblcallsbilled with(nolock) where  complete is null   and billtype ='01'  and dateDiff(d, RecordDate,getdate() ) <7

If (  @totalRevenue  >10 ) 
 Begin
	
	 return 0
 End
select  @totalRevenue = sum(isnull(callRevenue,0)  ), @billedPerMonth  = count( callRevenue) from tblcallsbilled with(nolock) where   complete is null   and billtype ='01'  and dateDiff(d, RecordDate,getdate() ) <30

If (  @totalRevenue  > 150) 
 Begin
	
	 return 0
 End
