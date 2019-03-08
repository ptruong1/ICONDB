
CREATE PROCEDURE [dbo].[p_SELECT_Inmate_Suspended]
( 
	@FacilityID int,
	@SuspendType int,
	@FromDate datetime,
	@Todate dateTime
)
AS


SELECT  [FacilityID]
      ,I.InmateID
      ,I.SuspendDate
      , T.Descript as description
      ,[FromDate]
      ,[Todate]
      ,[SuspendBy]
  FROM [leg_Icon].[dbo].[tblInmateSuspend] I,
   [leg_Icon].[dbo].[tblSuspendType] T
 
  where I.FacilityID = @facilityID and I.suspendType = T.SuspendType
 
 order by I.InmateID

  

  --select * from [tblActivity] where userName = 'rquinto' 

