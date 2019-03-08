-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Visitor_Members]
(
			@VisitorID int
		)
AS
		
	SET NOCOUNT OFF;
	  
	  Begin
		  SELECT 
          [FirstName]
      ,[LastName]
      ,V. RelationshipID
	  ,R.Descript as Relationship
      ,[DLID]
      ,[Phone]
      ,[Address]
      ,[City]
      ,[State] as State
	  ,S.StateName
      ,[Zipcode]
      ,isnull(V.Status, 1) as Status
	  ,M.Descript as MemberStatus
	  ,V.MemberId
  FROM [leg_Icon].[dbo].[tblVisitorMembers] V
  inner join [leg_Icon].[dbo].tblStates S On  V.State = S.StateCode
	inner join     [leg_Icon].[dbo].[tblRelationShip] R On  R.RelationshipID = V.RelationshipID	
	inner join     [leg_Icon].[dbo].[tblVisitorMemberStatus] M On  M.Status = V.Status  
	  where  VisitorID = @VisitorID 
		
		end	
 


