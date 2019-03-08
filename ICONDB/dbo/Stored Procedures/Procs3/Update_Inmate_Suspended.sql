

CREATE PROCEDURE [dbo].[Update_Inmate_Suspended]
(
			@FacilityID int
           ,@InmateID varchar(12)
           ,@SuspendDate datetime
           ,@SuspendType tinyint
           ,@FromDate datetime
           ,@Todate datetime
           ,@SuspendBy varchar(25)
)
AS
	SET NOCOUNT OFF;
	IF(SELECT COUNT(*) FROM [leg_Icon].[dbo].[tblInmateSuspend]
	where (InmateId = @InmateID AND FacilityId = @FacilityId and SuspendType = @SuspendType) ) > 0
	UPDATE leg_Icon.[dbo].[tblInmateSuspend] 
		SET
		   [SuspendDate] = @SuspendDate
           ,[FromDate] = @FromDate
           ,[Todate] = @Todate
           ,[SuspendBy]	= @SuspendBy
		WHERE (InmateId = @InmateID AND FacilityId = @FacilityId and SuspendType = @SuspendType)
		Else
	INSERT INTO [leg_Icon].[dbo].[tblInmateSuspend]
           ([FacilityID]
           ,[InmateID]
           ,[SuspendDate]
           ,[SuspendType]
           ,[FromDate]
           ,[Todate]
           ,[SuspendBy])
     VALUES
           (@FacilityID
           ,@InmateID
           ,@SuspendDate
           ,@SuspendType
           ,@FromDate
           ,@Todate
           ,@SuspendBy)

