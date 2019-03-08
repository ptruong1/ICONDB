CREATE TABLE [dbo].[tblLogUserActivity] (
    [UserID]       VARCHAR (20)  NOT NULL,
    [Activity]     VARCHAR (50)  NULL,
    [URL]          VARCHAR (100) NULL,
    [ActivityDate] DATETIME      NULL,
    [ID]           SMALLINT      NULL
);

