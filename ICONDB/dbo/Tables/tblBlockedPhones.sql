CREATE TABLE [dbo].[tblBlockedPhones] (
    [PhoneNo]     CHAR (10)     NOT NULL,
    [FacilityID]  INT           NOT NULL,
    [ReasonID]    TINYINT       NULL,
    [RequestID]   TINYINT       NULL,
    [UserName]    VARCHAR (25)  NULL,
    [inputDate]   SMALLDATETIME CONSTRAINT [DF_tblBlockedPhones_inputDate] DEFAULT (getdate()) NULL,
    [TimeLimited] SMALLINT      NULL,
    [Descript]    VARCHAR (200) NULL,
    [GroupID]     INT           NULL,
    CONSTRAINT [PK_tblBlockedPhones] PRIMARY KEY CLUSTERED ([PhoneNo] ASC, [FacilityID] ASC)
);

