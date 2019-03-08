CREATE TABLE [dbo].[tblActivityLog] (
    [ActivityLogID] INT           NOT NULL,
    [ActivityID]    TINYINT       NOT NULL,
    [ActTime]       DATETIME      CONSTRAINT [DF_tblActivityLog_ActTime] DEFAULT (getdate()) NULL,
    [RecordID]      BIGINT        NULL,
    [FacilityID]    INT           NULL,
    [UserName]      VARCHAR (25)  NULL,
    [UserIP]        VARCHAR (20)  NULL,
    [Reference]     VARCHAR (25)  NULL,
    [UserAction]    VARCHAR (500) NULL,
    CONSTRAINT [PK_tblActivityLog] PRIMARY KEY CLUSTERED ([ActivityLogID] ASC),
    CONSTRAINT [FK_tblActivityLog_tblActivity] FOREIGN KEY ([ActivityID]) REFERENCES [dbo].[tblActivity] ([ActivityID])
);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[trg_update_live_user] 
   ON dbo.tblActivityLog 
   FOR INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--DECLARE @ActivityTime varchar(25), @ActTime datetime, @UserName varchar(25),@FacilityID int, @ActivityID smallint, @UserAction varchar(500);
    --select @facilityID = facilityID,@ActTime = ActTime,@UserName= UserName, @UserAction = UserAction , @ActivityID= ActivityID   from inserted ;
    -- Insert statements for trigger here
 --   SET @ActivityTime = convert (varchar(25), @ActTime,109);
	--EXEC [172.77.10.22\bigdaddyicon].Leg_LiveCast.dbo.p_update_user_activity @UserName, @FacilityID, @ActivityID, @UserAction,@ActivityTime;
 

END
