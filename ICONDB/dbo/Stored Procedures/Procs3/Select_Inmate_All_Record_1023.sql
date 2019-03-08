-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Inmate_All_Record_1023]
(
		@facilityID int
		
        )
AS
	Declare @ReturnCode   int ,@flatform  tinyint
	set @ReturnCode = 0 
	
		
	SET NOCOUNT OFF;
	
 begin 
	 
		 SELECT	[VLastName]
		  ,[VFirstName]
		  ,[VMi]
		  ,[Address]
		  ,[City]
		  ,[State]
		  ,[Zipcode]
		  ,[Phone1]
		  ,[Phone2]
		  ,[Email]
		  ,tblVisitEnduserSchedule.InmateID
		  ,tblVisitors.FacilityID
		  ,[RelationshipID]
		  ,tblVisitors.Relationship
		  ,tblVisitors.RecordOpt
		  ,FirstName
		  ,LastName
		  ,tblVisitEnduserSchedule.VisitorID
		  ,Approved
		  ,isnull(DriverLicense,'') as DriverLicense
		  ,SusStartDate
		  ,SusEndDate
		  ,isnull(ApprovedReq,0) as VisitApprovedReq
		  ,tblInmate.PIN
	      
	      FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule], [leg_Icon].[dbo].[tblVisitors], [leg_Icon].[dbo].[tblInmate]
	      Left Join [leg_Icon].[dbo].[tblVisitInmateConfig] On
	      tblInmate.FacilityId = tblVisitInmateConfig.FacilityID and tblInmate.InmateID = tblVisitInmateConfig.InmateID
		  where 
				tblVisitEnduserSchedule.FacilityID = @facilityID and
				tblVisitEnduserSchedule.facilityID = tblInmate.FacilityID and
				tblVisitEnduserSchedule.InmateID = tblInmate.InmateID and
				tblInmate.Status = 1 and
				tblVisitEnduserSchedule.VisitorID = tblVisitors.VisitorID
				order by LastName
end 
	  
 

