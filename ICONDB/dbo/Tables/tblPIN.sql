CREATE TABLE [dbo].[tblPIN] (
    [PIN]              CHAR (6)      NOT NULL,
    [LastName]         VARCHAR (25)  NULL,
    [FirstName]        VARCHAR (25)  NULL,
    [MidName]          VARCHAR (25)  NULL,
    [Status]           TINYINT       NULL,
    [DNIRestrict]      BIT           NULL,
    [DateTimeRestrict] BIT           NULL,
    [AccessType]       TINYINT       NULL,
    [AlertEmail]       VARCHAR (25)  NULL,
    [AlertPage]        CHAR (10)     NULL,
    [AlertPhone]       CHAR (10)     NULL,
    [DNILimit]         TINYINT       NULL,
    [FacilityId]       INT           NOT NULL,
    [inputdate]        SMALLDATETIME NULL,
    [UserName]         VARCHAR (20)  NULL,
    [ModifyDate]       SMALLDATETIME NULL,
    CONSTRAINT [PK_tblPIN] PRIMARY KEY CLUSTERED ([PIN] ASC, [FacilityId] ASC)
);

