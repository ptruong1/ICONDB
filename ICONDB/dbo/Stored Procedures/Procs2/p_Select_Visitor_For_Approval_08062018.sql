-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[p_Select_Visitor_For_Approval_08062018]
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
		  ,[Phone2]
		  ,[Email]
		  ,V.InmateID
		  ,V.FacilityID
		  ,[RelationshipID]
		  ,[Relationship]
		  ,[EndUserID]
		  ,V.RecordOpt
		  ,FirstName
		  ,LastName
		  ,VisitorID
		  ,Approved
		  ,DriverLicense
	      ,Descript
	      ,I.PIN
		  ,I.DOB
		  ,isnull(V.VImage,' ') as VImage
	  FROM [leg_Icon].[dbo].[tblVisitors] V,  [leg_Icon].[dbo].[tblInmate] I,
	  [leg_Icon].[dbo].[tblVisitorStatus] S
	   
	  where  V.FacilityID = @facilityId
			and V.InmateID = I.InmateID
			and V.FacilityID = I.FacilityID
			and V.Approved = S.Status
			and V.Approved = 'P'
			order by [VLastName]
		end	
	  



