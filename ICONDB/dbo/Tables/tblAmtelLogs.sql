CREATE TABLE [dbo].[tblAmtelLogs] (
    [PIN]             VARCHAR (12)   NULL,
    [InmateID]        VARCHAR (12)   NULL,
    [LastName]        VARCHAR (25)   NULL,
    [FirstName]       VARCHAR (25)   NULL,
    [MidName]         VARCHAR (20)   NULL,
    [DOB]             VARCHAR (12)   NULL,
    [PhoneBalance]    NUMERIC (7, 2) NULL,
    [CurrentStatus]   TINYINT        NULL,
    [AmtelFacilityID] INT            NULL,
    [Unit]            VARCHAR (30)   NULL,
    [Pod]             VARCHAR (30)   NULL,
    [Cell]            VARCHAR (30)   NULL,
    [RecordDate]      DATETIME       CONSTRAINT [DF_tblAmtelLogs_RecordDate] DEFAULT (getdate()) NULL,
    [FromNo]          VARCHAR (10)   NULL,
    [ToNo]            VARCHAR (18)   NULL,
    [Charge]          NUMERIC (5, 2) NULL,
    [ReferenceNo]     BIGINT         NULL,
    [Duration]        INT            NULL,
    [Error_ID]        VARCHAR (3)    NULL,
    [APItype]         TINYINT        NULL,
    [FacilityID]      INT            NULL
);

