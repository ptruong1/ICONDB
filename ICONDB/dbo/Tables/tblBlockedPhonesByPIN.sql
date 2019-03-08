CREATE TABLE [dbo].[tblBlockedPhonesByPIN] (
    [PhoneNo]     CHAR (10)     NOT NULL,
    [FacilityID]  INT           NOT NULL,
    [PIN]         VARCHAR (12)  NOT NULL,
    [ReasonID]    TINYINT       NULL,
    [RequestID]   TINYINT       NULL,
    [UserName]    VARCHAR (25)  NULL,
    [inputDate]   SMALLDATETIME NULL,
    [TimeLimited] SMALLINT      NULL,
    [Descript]    VARCHAR (200) NULL,
    [InmateID]    VARCHAR (12)  NULL
);

