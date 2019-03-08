-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_visit_end] 
	@roomID int,
	@userType char(1)
AS
BEGIN
	UPDATE leg_Icon.dbo.tblVisitEnduserSchedule SET status =5
		where RoomID =@roomID and status =3 and VisitDuration is null ;
	if(@userType ='I')
		UPDATE leg_Icon.dbo.tblVisitOnline SET  [status] =10, InmateVisitEndtime=getdate()	where RoomID =@roomID ;
	else
		UPDATE leg_Icon.dbo.tblVisitOnline SET  [status] =10, VisitorVisitEndtime=getdate()	where RoomID =@roomID ;
END

