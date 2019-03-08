CREATE TABLE [dbo].[tblCallsUnbilled] (
    [calldate]     CHAR (6)      NULL,
    [projectcode]  CHAR (6)      NULL,
    [calltime]     CHAR (6)      NULL,
    [fromno]       CHAR (10)     NULL,
    [tono]         VARCHAR (16)  NULL,
    [billtype]     CHAR (2)      NULL,
    [errorType]    TINYINT       NULL,
    [RecordDate]   SMALLDATETIME CONSTRAINT [DF_tblCallsUnbilled_RecordDate] DEFAULT (getdate()) NULL,
    [InmateID]     VARCHAR (12)  NULL,
    [PIN]          VARCHAR (12)  NULL,
    [FacilityID]   INT           NULL,
    [HostName]     VARCHAR (16)  NULL,
    [ResponseCode] VARCHAR (3)   NULL,
    [OpSeqNo]      VARCHAR (6)   NULL,
    [InRecordFile] VARCHAR (20)  NULL,
    [DebitCardNo]  VARCHAR (12)  NULL,
    [PhoneType]    TINYINT       NULL,
    [Calltype]     VARCHAR (2)   NULL,
    [RecordID]     BIGINT        NULL,
    [OutDuration]  SMALLINT      NULL,
    [UserLanguage] TINYINT       NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_tono]
    ON [dbo].[tblCallsUnbilled]([tono] ASC, [PIN] ASC, [FacilityID] ASC, [DebitCardNo] ASC, [RecordDate] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_Factility_Debit_RecordDate]
    ON [dbo].[tblCallsUnbilled]([FacilityID] ASC, [DebitCardNo] ASC, [RecordDate] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_facility_recordDate]
    ON [dbo].[tblCallsUnbilled]([FacilityID] ASC, [RecordDate] ASC);

