CREATE TABLE [dbo].[tblBlockedPhonesBackup] (
    [PhoneNo]     CHAR (10)     NOT NULL,
    [FacilityID]  INT           NOT NULL,
    [ReasonID]    TINYINT       NULL,
    [RequestID]   TINYINT       NULL,
    [UserName]    VARCHAR (25)  NULL,
    [inputDate]   SMALLDATETIME NULL,
    [TimeLimited] SMALLINT      NULL,
    [Descript]    VARCHAR (200) NULL,
    [GroupID]     INT           NULL
);

