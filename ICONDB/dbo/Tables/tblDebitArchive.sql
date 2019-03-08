CREATE TABLE [dbo].[tblDebitArchive] (
    [RecordID]        INT            NOT NULL,
    [InmateID]        VARCHAR (12)   NULL,
    [AccountNo]       VARCHAR (12)   NOT NULL,
    [FacilityID]      INT            NULL,
    [ActiveDate]      SMALLDATETIME  NULL,
    [EndDate]         SMALLDATETIME  NULL,
    [PaymentType]     TINYINT        NULL,
    [Balance]         NUMERIC (7, 2) NULL,
    [ReservedBalance] NUMERIC (7, 2) NULL,
    [status]          TINYINT        NULL,
    [Note]            VARCHAR (50)   NULL,
    [inputdate]       SMALLDATETIME  NULL,
    [modifyDate]      SMALLDATETIME  NULL,
    [UserName]        VARCHAR (20)   NULL,
    [DebitType]       TINYINT        NULL
);

