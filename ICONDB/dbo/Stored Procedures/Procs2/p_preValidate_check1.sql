CREATE PROCEDURE [dbo].[p_preValidate_check1]
@ToNo  varchar(10),
@ResponseCode  char(3) Output
 AS
Declare @totalRevenue  numeric(7,2)
SET @ResponseCode = '999'
Set @totalRevenue =0
If ( SELECT count (*) from tblOfficeANI  with(nolock)  WHERE  AuthNo  = @tono ) > 0
 begin
	SET  @ResponseCode = '050'
	Return 0
  end

select  @totalRevenue = sum(isnull(callRevenue,0)  ) from tblcallsbilled  where  tono = @ToNo and billtype ='01'  and complete is null  and dateDiff(d, RecordDate,getdate() ) <1

If (  @totalRevenue  > 200) 
 Begin
	SET  @ResponseCode = '262'
	 return 0
 End
select  @totalRevenue = sum(isnull(callRevenue,0)  ) from tblcallsbilled  where  tono = @ToNo and billtype ='01' and complete is null  and dateDiff(d, RecordDate,getdate() ) <7

If (  @totalRevenue  > 250) 
 Begin
	SET  @ResponseCode = '262'
	 return 0
 End
select  @totalRevenue = sum(isnull(callRevenue,0)  ) from tblcallsbilled  where  tono = @ToNo and billtype ='01'  and complete is null  and dateDiff(d, RecordDate,getdate() ) <30

If (  @totalRevenue  > 300) 
 Begin
	SET  @ResponseCode = '262'
	 return 0
 End

SELECT top 1  @ResponseCode = responseCode  from   tblOncalls   WHERE  tono = @ToNo and billtype ='01' and responsecode not in ('999' ,'262', '283','' )
