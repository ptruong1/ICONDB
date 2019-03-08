CREATE TABLE [dbo].[tblActivityLogArchive] (
    [ActivityLogID] INT           NOT NULL,
    [ActivityID]    TINYINT       NOT NULL,
    [ActTime]       DATETIME      NULL,
    [RecordID]      BIGINT        NULL,
    [FacilityID]    INT           NULL,
    [UserName]      VARCHAR (25)  NULL,
    [UserIP]        VARCHAR (20)  NULL,
    [Reference]     VARCHAR (25)  NULL,
    [UserAction]    VARCHAR (500) NULL
);

