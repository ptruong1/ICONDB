-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Visitor_Record_06162015]
(
		@facilityID int,
		@VFirstName varchar(25),
		@VLastName varchar(25)
        )
AS
	Declare @ReturnCode   int 
	set @ReturnCode = 0 
	Declare @recordID int ,@flatform  tinyint
		
	SET NOCOUNT OFF;

 begin 
	
	  If @VFirstName <> ''
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
		  ,A.InmateID
		  ,A.FacilityID
		  ,[RelationshipID]
		  ,[Relationship]
		  ,[RecordOpt]
		  ,FirstName
		  ,LastName
		  ,VisitorID
		  ,Approved
		  ,isnull(DriverLicense,'') as DriverLicense
		  ,SusStartDate
		  ,SusEndDate
		  ,isnull(ApprovedReq,0) as VisitApprovedReq
	      ,A.VNote
	      ,EndUserID
	      ,PIN
		  ,A.StateID
	      ,S.StateName
	      ,S.Country
	      ,A.CountryID
	      ,isnull(V.VisitPerDay, 0) as VisitPerDay
	      ,isnull(V.VisitPerWeek,0) as VisitPerWeek
	      ,isnull(V.VisitRemain,10) as VisitRemain
	      
	  FROM [leg_Icon].[dbo].[tblVisitors] A   
	  Left join [leg_Icon].[dbo].[tblInmate] I on
			 A.InmateID = I.InmateID and A.FacilityID = I.FacilityID
	  Left Join [leg_Icon].[dbo].[tblVisitInmateConfig] V on
			I.facilityID = V.FacilityID and I.InmateID = V.InmateID
	  Left join     [leg_Icon].[dbo].tblStates S On  A.StateID = S.StateID
	  
	  where A.VFirstName like  @VFirstName +'%' and A.FacilityID = @facilityId
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
		  ,A.InmateID
		  ,A.FacilityID
		  ,[RelationshipID]
		  ,[Relationship]
		  ,[RecordOpt]
		  ,FirstName
		  ,LastName
		  ,VisitorID
		  ,Approved
		  ,isnull(DriverLicense,'') as DriverLicense
		  ,SusStartDate
		  ,SusEndDate
		  ,isnull(ApprovedReq,0) as VisitApprovedReq
		  ,A.VNote
		  ,EndUserID
		  ,PIN
		  ,A.StateID
	      ,S.StateName
	      ,S.Country
	      ,A.CountryID
	      ,isnull(V.VisitPerDay, 0) as VisitPerDay
	      ,isnull(V.VisitPerWeek,0) as VisitPerWeek
	      ,isnull(V.VisitRemain,10) as VisitRemain
	      
	  FROM [leg_Icon].[dbo].[tblVisitors] A   
	  Left join [leg_Icon].[dbo].[tblInmate] I on
			 A.InmateID = I.InmateID and A.FacilityID = I.FacilityID
	  Left Join [leg_Icon].[dbo].[tblVisitInmateConfig] V on
			I.facilityID = V.FacilityID and I.InmateID = V.InmateID
	  Left join     [leg_Icon].[dbo].tblStates S On  A.StateID = S.StateID
	  
	  where A.VLastName like  @VLastName +'%' and A.FacilityID = @facilityId
	  End
 end 
 
