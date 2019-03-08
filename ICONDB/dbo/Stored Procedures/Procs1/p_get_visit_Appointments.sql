-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visit_Appointments]
	-- Add the parameters for the stored procedure here
	(@facilityID int,
	 @InmateID varchar(12))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    If @InmateID <> ''
    
		SELECT tblVisitEnduserSchedule.FacilityID, 
		[RoomID]
      ,[ApmNo]
      ,[InmateID]
      ,[InmateName]
      ,[EndUserID]
      ,[RequestedTime]
      ,[RequestBy]
      ,[ApprovedTime]
      ,[ApprovedBy]
      ,[ApmDate]
      ,[ApmTime]
      ,[CreatedBy]
      ,[visitType]
      ,[LimitTime]
	  ,[MediaServerIP]
	  ,tblVisitType.Descript as VisitTypeDescript
	  ,tblVisitStatus.descript as status
		FROM tblVisitEnduserSchedule  
		INNER JOIN tblAVChatWebsite on tblVisitEnduserSchedule.facilityid = tblAVChatWebsite.facilityid 
		INNER JOIN tblVisitType on tblVisitEnduserSchedule.VisitType = tblVisitType.VisitTypeID 
		INNER JOIN tblVisitStatus on tblVisitEnduserSchedule.Status = tblVisitStatus.StatusID 
		Where (tblVisitEnduserSchedule.FacilityID = @facilityID and InmateID = @InmateID)

    else
    
		SELECT tblVisitEnduserSchedule.FacilityID, 
		[RoomID]
      ,[ApmNo]
      ,[InmateID]
      ,[InmateName]
      ,[EndUserID]
      ,[RequestedTime]
      ,[RequestBy]
      ,[ApprovedTime]
      ,[ApprovedBy]
      ,[ApmDate]
      ,[ApmTime]
      ,[CreatedBy]
      ,[visitType]
      ,[LimitTime]
		,[MediaServerIP]
		,tblVisitType.Descript as VisitTypeDescript
		,tblVisitStatus.descript as status
		FROM tblVisitEnduserSchedule  
		INNER JOIN tblAVChatWebsite on tblVisitEnduserSchedule.facilityid = tblAVChatWebsite.facilityid 
		INNER JOIN tblVisitType on tblVisitEnduserSchedule.VisitType = tblVisitType.VisitTypeID
		INNER JOIN tblVisitStatus on tblVisitEnduserSchedule.Status = tblVisitStatus.StatusID  
		Where (tblVisitEnduserSchedule.FacilityID = @facilityID)
END

