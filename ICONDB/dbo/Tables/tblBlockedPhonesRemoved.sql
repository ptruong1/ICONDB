CREATE TABLE [dbo].[tblBlockedPhonesRemoved] (
    [PhoneNo]     CHAR (10)     NOT NULL,
    [FacilityID]  INT           NOT NULL,
    [ReasonID]    TINYINT       NULL,
    [RequestID]   TINYINT       NULL,
    [UserName]    VARCHAR (25)  NULL,
    [inputDate]   SMALLDATETIME CONSTRAINT [DF_tblBlockedPhonesRemoved_inputDate] DEFAULT (getdate()) NULL,
    [TimeLimited] SMALLINT      NULL,
    [Descript]    VARCHAR (200) NULL,
    [GroupID]     INT           NULL
);

