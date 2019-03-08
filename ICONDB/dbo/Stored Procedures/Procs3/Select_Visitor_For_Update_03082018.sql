-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Visitor_For_Update_03082018]
(
		@facilityID int,
		@VisitorID int
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
		  ,A.Address
		  ,A.City
		  ,A.State
		  ,A.Zipcode
		  ,A.Phone1
		  ,isnull(Phone2,'') as Phone2
		  ,[Email]
		  ,A.InmateID
		  ,A.FacilityID
		  ,A.RelationshipID
		  ,A.Relationship
		  ,[RecordOpt]
		  ,I.FirstName
		  ,I.LastName
		  ,A.VisitorID
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
		  ,isnull(A.ApprovedApm,0) as ApprovedApm
	      		  
	  FROM [leg_Icon].[dbo].[tblVisitors] A   
	  Left join [leg_Icon].[dbo].[tblInmate] I on
			 A.InmateID = I.InmateID and A.FacilityID = I.FacilityID
	  Left Join [leg_Icon].[dbo].[tblVisitInmateConfig] V on
			I.facilityID = V.FacilityID and I.InmateID = V.InmateID
	  Left join     [leg_Icon].[dbo].tblStates S On  A.StateID = S.StateID
	  	 			
	  where  A.FacilityID = @facilityID and
			 A.VisitorID = @VisitorID 
		
		end	
 


