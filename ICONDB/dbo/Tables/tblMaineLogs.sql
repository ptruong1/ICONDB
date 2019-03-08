CREATE TABLE [dbo].[tblMaineLogs] (
    [PIN]            VARCHAR (12)   NULL,
    [InmateID]       VARCHAR (12)   NULL,
    [LastName]       VARCHAR (25)   NULL,
    [FirstName]      VARCHAR (25)   NULL,
    [MidName]        VARCHAR (20)   NULL,
    [DOB]            VARCHAR (12)   NULL,
    [PhoneBalance]   NUMERIC (7, 2) NULL,
    [AllowedMinutes] INT            NULL,
    [CurrentStatus]  TINYINT        NULL,
    [Facility]       VARCHAR (100)  NULL,
    [Unit]           VARCHAR (30)   NULL,
    [Pod]            VARCHAR (30)   NULL,
    [Cell]           VARCHAR (30)   NULL,
    [IsAdult]        BIT            NULL,
    [ReturnValue]    SMALLINT       NULL,
    [Log_ID]         INT            NULL,
    [RecordDate]     DATETIME       CONSTRAINT [DF_tblMaineLogs_RecordDate] DEFAULT (getdate()) NULL,
    [FromNo]         VARCHAR (10)   NULL,
    [ToNo]           VARCHAR (18)   NULL,
    [Charge]         NUMERIC (5, 2) NULL,
    [ReferenceNo]    BIGINT         NULL,
    [Duration]       INT            NULL,
    [Error_ID]       VARCHAR (3)    NULL,
    [APItype]        TINYINT        NULL,
    [FacilityID]     INT            NULL,
    [is_Indigent]    VARCHAR (1)    NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_Ref_API]
    ON [dbo].[tblMaineLogs]([PIN] ASC, [InmateID] ASC, [ReferenceNo] ASC, [APItype] ASC);

