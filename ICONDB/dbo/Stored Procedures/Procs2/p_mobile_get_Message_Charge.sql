
CREATE PROCEDURE [dbo].[p_mobile_get_Message_Charge]
@facilityID int,
@MessageTypeID tinyint --- 1 -Voice , 2- Email, 3-- Text Message, 4 -- Video Message, 5- Picture Exchange
AS
SET NOCOUNT ON;
Declare @Charge as SmallMoney, @Limittime smallint;
SET @Charge = 1;
SET  @Limittime =0;
if(@MessageTypeID =1) 
	select @Limittime = VoiceLength from tblfacilitymessageconfig with(nolock) where FacilityID = @facilityID ;
else if(@MessageTypeID =2) 
	select @Limittime = TextLength from tblfacilitymessageconfig with(nolock) where FacilityID = @facilityID;
else if(@MessageTypeID =3) 
	select @Limittime = TextLength from tblfacilitymessageconfig with(nolock) where FacilityID = @facilityID;
else if(@MessageTypeID =4) 
	select @Limittime = VideoLength from tblfacilitymessageconfig with(nolock) where FacilityID = @facilityID;
else 
	select @Limittime = ImageSize from tblfacilitymessageconfig with(nolock) where FacilityID = @facilityID;
select @Charge = isnull(Charge,0) +  isnull(ChargePerTrans,0)  from tblMessageRate with(nolock) where  facilityID = @facilityID  and MessageTypeID = @MessageTypeID;

Select  @Charge  as Charge,  @Limittime  as LimitSize; 

return @@Error;

