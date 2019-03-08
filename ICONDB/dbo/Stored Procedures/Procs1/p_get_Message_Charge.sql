
CREATE PROCEDURE [dbo].[p_get_Message_Charge]
@facilityID int,
@MessageTypeID tinyint,
@Charge  smallmoney OUTPUT
AS
SET NOCOUNT ON;
SET @Charge = 1;
select @Charge = isnull(Charge,0) +  isnull(ChargePerTrans,0)  from tblMessageRate with(nolock) where  facilityID = @facilityID  and MessageTypeID = @MessageTypeID;

return @@Error;

