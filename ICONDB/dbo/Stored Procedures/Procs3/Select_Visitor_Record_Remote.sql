-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Visitor_Record_Remote]
(
		@facilityID int,
		@EndUserID varchar(10)
		
        )
AS
 Begin
	SET NOCOUNT OFF;
	Declare @ReturnCode   int 
	Declare @recordID int ,@fl int
		
	
	set @ReturnCode = 0 
	set @fl=1
   SELECT @fl= dbo.fn_determine_flatform(@facilityID)
   if(@fl =1)
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
		  ,isnull(v.InmateID,'') InmateID
		  ,V.FacilityID
		  ,[RelationshipID]
		  ,[RecordOpt]
		  ,I.FirstName
		  ,I.LastName
		  ,VisitorID
		  ,Approved
		  ,DriverLicense
	      
		  FROM [leg_Icon].[dbo].[tblVisitors] V LEFT OUTER JOIN [leg_Icon1].[dbo].[tblInmate]  I
		  ON 		
				V.InmateID = I.InmateID
				and V.FacilityID = I.FacilityID
		   WHERE 
				V.EndUserID = @EndUserID and V.FacilityID = @facilityID
	else
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
		  ,isnull(v.InmateID,'') InmateID
		  ,V.FacilityID
		  ,[RelationshipID]
		  ,[RecordOpt]
		  ,I.FirstName
		  ,I.LastName
		  ,VisitorID
		  ,Approved
		  ,DriverLicense
	      
		  FROM [leg_Icon].[dbo].[tblVisitors] V LEFT OUTER JOIN [leg_Icon2].[dbo].[tblInmate]  I
		  ON 		
				V.InmateID = I.InmateID
				and V.FacilityID = I.FacilityID
		   WHERE 
				V.EndUserID = @EndUserID and V.FacilityID = @facilityID
	end

