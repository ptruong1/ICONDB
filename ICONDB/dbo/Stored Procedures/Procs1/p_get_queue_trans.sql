-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_queue_trans]
@APItype smallint OUTPUT,
@PIN varchar(12) OUTPUT,
@InmateID varchar(12) OUTPUT,
@FromNo  varchar(12) OUTPUT,
@ToNo	varchar(12) OUTPUT,
@ReferenceNo  varchar(15) OUTPUT,
@Duration smallint OUTPUT,
@Charge	smallmoney OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @APItype  =0;
	select top 1 @APItype= APItype,@PIN = PIN,@InmateID= InmateID,@FromNo= FromNo,@ToNo=ToNo, @ReferenceNo= cast(ReferenceNo as varchar(15)),@Duration= Duration,@Charge =charge 
	from MaineStupQueue with(nolock) where APItype =2 and (Qout is null or Qout =0) order by RecordDate -- and ReferenceNo not in (select ReferenceNo from tblMaineLogs where APIType =2 and DATEDIFF(DAY, recordDate,getdate()) =0)  order  by RecordDate;
	if(@APItype =0)
		select top 1 @APItype= APItype,@PIN = PIN,@InmateID= InmateID,@FromNo= FromNo,@ToNo=ToNo, @ReferenceNo=cast(ReferenceNo as varchar(15)),@Duration= Duration,@Charge =charge from MaineStupQueue 
		 with(nolock) where APItype =3  and (Qout is null or Qout =0) --and ReferenceNo  in (select ReferenceNo from MaineStupQueue where APIType =2 and  DATEDIFF(DAY, recordDate,getdate()) =0) 
		 And ReferenceNo not in (select ReferenceNo from tblMaineLogs where APIType =3 and DATEDIFF(DAY, recordDate,getdate()) =0)
		   order  by RecordDate;
	if( left(@ToNo,3) ='011')
		SET @ToNo = right(@ToNo,10);

   
   select top 1 @APItype= APItype,@PIN = PIN,@InmateID= InmateID,@FromNo= FromNo,@ToNo=ToNo, @ReferenceNo=cast(ReferenceNo as varchar(15)),@Duration=1 ,@Charge =0 from  MaineStupQueue where DATEDIFF (minute, recordDate, getdate()) > 60 and DATEDIFF (minute, recordDate, getdate()) <120 and apiType =2 and ReferenceNo not in 
	(select ReferenceNo from MaineStupQueue where  DATEDIFF (minute, recordDate, getdate()) <120 )
	 order by RecordDate ;

	if(@APItype >0)
		Update MaineStupQueue set  Qout =1 where APIType = @APItype and ReferenceNo = @ReferenceNo;

	If(@Duration =0)
	 begin
		SET @Duration =1;
		SET @Charge =0.0;
	 end
	Else If (@Duration >120)
	 begin
		SET @Duration = 120;
	 End
     
		--truncate table MaineStupQueue
END

