-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_visit_duration] 
	@roomID int,
	@Acctduration smallint
AS
BEGIN
	UPDATE leg_Icon.dbo.tblVisitEnduserSchedule SET VisitDuration = @Acctduration, status =5
	where RoomID =@roomID and status =3 and VisitDuration is null and LimitTime <= @Acctduration +2
END

