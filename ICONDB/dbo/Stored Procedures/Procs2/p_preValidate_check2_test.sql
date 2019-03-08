
CREATE PROCEDURE [dbo].[p_preValidate_check2_test]
@FacilityID	int,
@ToNo  varchar(10),
@ResponseCode  char(3) Output
 AS

SET nocount on
Declare @totalRevenue  numeric(7,2), @CallsPerDay smallint,  @AmtPerDay   numeric(6,2) ,  @CallsPerWeek smallint ,  @AmtPerWeek numeric(6,2),  @CallsPerMonth  smallint , @AmtPerMonth  numeric(6,2),
@billedPerDay  smallint, @billedPerWeek smallint, @billedPerMonth smallint

SET @ResponseCode = '999'
Set @totalRevenue =0
SET @billedPerDay  =0
SET @billedPerWeek =0
SET  @billedPerMonth =0
If ( SELECT count (*) from tblOfficeANI  with(nolock)  WHERE  AuthNo  = @tono ) > 0
 begin
	SET  @ResponseCode = '050'
	Return 0
  end

select  @CallsPerDay =  CallsPerDay,  @AmtPerDay=  AmtPerDay ,   @CallsPerWeek= CallsPerWeek,  @AmtPerWeek=  AmtPerWeek , @CallsPerMonth=  CallsPerMonth,  @AmtPerMonth = AmtPerMonth
	From  tblfacilitybillThreshold with(nolock)   where (facilityID =  @FacilityID  or facilityID = 1)  order by facilityID



select  @totalRevenue = sum(isnull(callRevenue,0)  )  , @billedPerDay  = count( callRevenue)  from tblcallsbilled with(nolock) where  tono = @ToNo and complete is null   and billtype ='01'  and dateDiff(d, RecordDate,getdate() )  =0

If ( ( @totalRevenue  >@AmtPerDay)  Or  (@billedPerDay > @CallsPerDay   ) )
 Begin
	SET  @ResponseCode = '262'
	 return 0
 End
select  @totalRevenue = sum(isnull(callRevenue,0)  ) , @billedPerWeek  = count( callRevenue)   from tblcallsbilled with(nolock) where  tono = @ToNo  and complete is null   and billtype ='01'  and dateDiff(d, RecordDate,getdate() ) <7

If ( ( @totalRevenue  > @AmtPerWeek)  Or  (@billedPerWeek > @CallsPerWeek  )) 
 Begin
	SET  @ResponseCode = '262'
	 return 0
 End
select  @totalRevenue = sum(isnull(callRevenue,0)  ), @billedPerMonth  = count( callRevenue) from tblcallsbilled with(nolock) where  tono = @ToNo  and complete is null   and billtype ='01'  and dateDiff(d, RecordDate,getdate() ) <31

If ( ( @totalRevenue  > @AmtPerMonth ) Or  (@billedPerMonth > @CallsPerMonth)  ) 
 Begin
	SET  @ResponseCode = '262'
	 return 0
 End

SELECT @ResponseCode = replycode  from    Tecodata.dbo.tblEnduser  with(nolock)  WHERE  billtono = @ToNo  and billtype ='01'
