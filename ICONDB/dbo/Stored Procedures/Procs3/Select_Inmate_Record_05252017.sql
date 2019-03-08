-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Inmate_Record_05252017]
(
		@facilityID int,
		@InmateID Varchar(12),
		@IFirstName varchar(25),
		@ILastName varchar(25)
        )
AS
	Declare @ReturnCode   int ,@flatform  tinyint
	set @ReturnCode = 0 
	
		
	SET NOCOUNT OFF;
	
 begin 
	  if (@InmateID<>'')
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
		  ,tblVisitors.RelationshipID
		  ,(select Descript from [leg_Icon].[dbo].[tblRelationShip] where tblRelationShip.RelationshipID = tblVisitors.RelationshipID) as Relationship
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
		  --Left join     [leg_Icon].[dbo].[tblRelationShip]  On  tblRelationShip.RelationshipID = tblVisitors.RelationshipID
		  where
				tblVisitEnduserSchedule.FacilityID = @facilityID and
				tblVisitEnduserSchedule.InmateID = @InmateID and
				tblVisitEnduserSchedule.facilityID = tblInmate.FacilityID and
				tblVisitEnduserSchedule.InmateID = tblInmate.InmateID and
				tblInmate.Status = 1 and
				tblVisitEnduserSchedule.VisitorID = tblVisitors.VisitorID
				
				
		 
	   end 
	  else If @IFirstName <> ''
	  Begin
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
		  ,(select Descript from [leg_Icon].[dbo].[tblRelationShip] where tblRelationShip.RelationshipID = tblVisitors.RelationshipID) as Relationship
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
				tblInmate.FirstName like  @IFirstName + '%'  and
				tblInmate.Status = 1 and
				tblVisitEnduserSchedule.VisitorID = tblVisitors.VisitorID
				
		end	
	 else
	   Begin
	   SELECT	[VLastName]
		  ,[VFirstName]
		  ,[VMi]
		  ,[Address]
		  ,[City]
		  ,[State]
		  ,[Zipcode]
		  ,[Phone1]
		  ,isNull(Phone2,'') as Phone2
		  ,[Email]
		  ,tblVisitEnduserSchedule.InmateID
		  ,tblVisitors.FacilityID
		  ,[RelationshipID]
		  ,(select Descript from [leg_Icon].[dbo].[tblRelationShip] where tblRelationShip.RelationshipID = tblVisitors.RelationshipID) as Relationship
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
				tblInmate.LastName like  @ILastName + '%'  and
				tblInmate.Status = 1 and
				tblVisitEnduserSchedule.VisitorID = tblVisitors.VisitorID
				
		end
 end 
 
