


CREATE PROCEDURE [dbo].[INSERT_BioMetricIdentifyResults]
(			@RecordID int
           ,@FacilityID int
           ,@InmateID varchar(12)
           ,@OriginalUser varChar(15)
           ,@SuspectedUsers varchar(100)
           ,@Probabilities varchar(60)
           ,@Scores varchar(60)
           ,@InputTime datetime
           )
AS
	SET NOCOUNT OFF;

INSERT INTO [leg_Icon].[dbo].[tblBioMetricIdentifyResults]
           ([RecordID]
           ,[FacilityID]
           ,[InmateID]
           ,[OriginalUser]
           ,[SuspectedUsers]
           ,[Probabilities]
           ,[Scores]
           ,[InputTime]
           )
     VALUES
           (@RecordID
           ,@FacilityID
           ,@InmateID
           ,@OriginalUser
           ,@SuspectedUsers
           ,@Probabilities
           ,@Scores
           ,@InputTime)

