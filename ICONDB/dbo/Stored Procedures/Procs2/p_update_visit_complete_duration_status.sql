-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_visit_complete_duration_status] 
	@RoomID int, 
	@Acctduration smallint,
	@Status tinyint
AS
BEGIN
    if(@Status =5)
	 begin
		UPDATE leg_Icon.dbo.tblVisitEnduserSchedule SET  VisitDuration=@Acctduration,  status =@Status, RecordStatus=1
			where RoomID =@RoomID and [status] <> 9;
		
		UPDATE leg_Icon.dbo.tblVisitEnduserSchedule SET  VisitDuration=@Acctduration,   RecordStatus=1
			where RoomID =@RoomID and [status] = 9;
		insert tblVisits(InmateID,FamilyAcct,FacilityID,VisitDate,VisitType,VisitStatus,VisitDuration,cost)
			select InmateID,EndUserID,FacilityID,ApmDate,visitType,status,isnull(VisitDuration,0), isnull(TotalCharge,0) from tblVisitEnduserSchedule
			where RoomID= @RoomID;

	 end
	else
		UPDATE leg_Icon.dbo.tblVisitEnduserSchedule SET  VisitDuration=0,  status =@Status
			where RoomID =@RoomID and VisitDuration is null and RecordOpt='Y';
END

