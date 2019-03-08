-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Visitor_All_Record_12222016]
(
		@facilityID int
		)
AS
	Declare @ReturnCode   int 
	set @ReturnCode = 0 
	Declare @recordID int ,@flatform  tinyint
		
	SET NOCOUNT OFF;
	  
	  Begin
		  SELECT	[VLastName]
		  ,[VFirstName]
		  ,[VMi]
		  ,[Address]
		  ,[City]
		  ,[State]
		  ,[Zipcode]
		  ,[Phone1]
		  ,isnull(Phone2,'') as Phone2
		  ,[Email]
		  ,A.InmateID
		  ,A.FacilityID
		  ,A.RelationshipID
		  ,A.Relationship
		  ,[RecordOpt]
		  ,FirstName
		  ,LastName
		  ,VisitorID
		  ,Approved
		  ,isnull(DriverLicense,'') as DriverLicense
          ,isnull(A.VNote,'') as VNote
		  ,SusStartDate
		  ,SusEndDate
		  ,isnull(ApprovedReq,0) as VisitApprovedReq
	      ,isNull(EndUserID, Phone1) as EndUserID
	      ,I.PIN
	      ,A.StateID
	      ,S.StateName
	      ,S.Country
	      ,A.CountryID
	      ,isnull(V.VisitPerDay, 0) as VisitPerDay
	      ,isnull(V.VisitPerWeek,0) as VisitPerWeek
	      ,isnull(V.VisitRemain,10) as VisitRemain
		  ,isnull(A.StateBarLicense,'') as StateBarLicense
		  ,isnull(A.VImage,'') as VImage
	      
	  FROM [leg_Icon].[dbo].[tblVisitors] A   
	  Left join [leg_Icon].[dbo].[tblInmate] I on
			 A.InmateID = I.InmateID and A.FacilityID = I.FacilityID
	  Left Join [leg_Icon].[dbo].[tblVisitInmateConfig] V on
			I.facilityID = V.FacilityID and I.InmateID = V.InmateID
	  Left join     [leg_Icon].[dbo].tblStates S On  A.StateID = S.StateID
	 			
	  where  A.FacilityID = @facilityId
						
			order by [VLastName]
		end	
 


