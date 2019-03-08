-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_queue]
	@APIType tinyint,
	@PIN  varchar(12),
	@InmateID  varchar(12), 
	@FromNo   varchar(10),
	@ToNo	varchar(16), 
	@ReferenceNo  bigint, 
	@Duration  int, 
	@Charge  smallmoney
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 --   If(@APIType =3 and @Duration =0)
	-- begin
	--	if (select count(*) from MaineStupQueue with(nolock) where ReferenceNo = @ReferenceNo and APIType =2) =1
	--		Insert MaineStupQueue ( APIType, RecordDate, PIN,InmateID, FromNo,ToNo, ReferenceNo, Duration, Charge)
	--						values(@APIType, getdate(), @PIN,@InmateID, @FromNo,@ToNo, @ReferenceNo, @Duration, @Charge);
	-- end
	--else
	--	Insert MaineStupQueue ( APIType, RecordDate, PIN,InmateID, FromNo,ToNo, ReferenceNo, Duration, Charge)
	--						values(@APIType, getdate(), @PIN,@InmateID, @FromNo,@ToNo, @ReferenceNo, @Duration, @Charge);
		 
	If(@APIType =3 and @Duration >0)
	 begin
		Insert MaineStupQueue ( APIType, RecordDate, PIN,InmateID, FromNo,ToNo, ReferenceNo, Duration, Charge)
							values(@APIType, getdate(), @PIN,@InmateID, @FromNo,@ToNo, @ReferenceNo, @Duration, @Charge);
	 end
	select @@ERROR as ErrorCode;
	return 0;
END

