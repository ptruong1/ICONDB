-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Select_Visitor_Approved_Report]
(
		@facilityID int,
		@fromDate	smalldatetime,  -- Required 
		@toDate	smalldatetime  -- Required 
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
		  ,[Phone2]
		  ,[Email]
		  ,V.InmateID
		  ,V.FacilityID
		  ,R.Descript as Relationship
		  ,[EndUserID]
		  ,V.RecordOpt
		  ,FirstName
		  ,LastName
		  ,VisitorID
		  ,Approved
		  ,DriverLicense
	      ,I.PIN
	
	  FROM [leg_Icon].[dbo].[tblVisitors] V,  [leg_Icon].[dbo].[tblInmate] I, 
	  [leg_Icon].[dbo].[tblRelationShip] R 
	  where  V.FacilityID = @facilityId
			and V.InmateID = I.InmateID
			and V.FacilityID = I.FacilityID
			and V.Approved = 'Y'
			and  R.RelationshipID = V.RelationshipID 
			and (V.ApprovedDate between @fromDate and dateadd(d,1,@todate) )
			order by [VLastName]
		end	
	  



