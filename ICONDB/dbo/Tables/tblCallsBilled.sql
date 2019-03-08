CREATE TABLE [dbo].[tblCallsBilled] (
    [RecordID]       BIGINT          NOT NULL,
    [Calldate]       CHAR (6)        NOT NULL,
    [ConnectTime]    CHAR (6)        NOT NULL,
    [FromNo]         CHAR (10)       NOT NULL,
    [ToNo]           VARCHAR (18)    NOT NULL,
    [BillToNo]       VARCHAR (10)    NULL,
    [MethodOfRecord] CHAR (2)        NULL,
    [billType]       CHAR (2)        NULL,
    [CallType]       CHAR (2)        NULL,
    [FromState]      CHAR (2)        NULL,
    [FromCity]       VARCHAR (10)    NULL,
    [ToState]        CHAR (2)        NULL,
    [ToCity]         VARCHAR (10)    NULL,
    [CreditCardType] VARCHAR (10)    NULL,
    [CreditCardNo]   VARCHAR (20)    NULL,
    [CreditCardExp]  VARCHAR (4)     NULL,
    [CreditCardZip]  VARCHAR (10)    NULL,
    [CreditCardCVV]  VARCHAR (4)     NULL,
    [CallPeriod]     CHAR (1)        NULL,
    [LibraryCode]    CHAR (2)        NULL,
    [Indicator19]    CHAR (1)        NULL,
    [SettlementCode] CHAR (1)        NULL,
    [ProjectCode]    CHAR (6)        NULL,
    [complete]       CHAR (1)        NULL,
    [errorCode]      TINYINT         NULL,
    [ratePlanID]     VARCHAR (7)     NULL,
    [firstMinute]    SMALLMONEY      NULL,
    [nextMinute]     SMALLMONEY      NULL,
    [connectFee]     SMALLMONEY      NULL,
    [minDuration]    TINYINT         NULL,
    [RateClass]      CHAR (1)        NULL,
    [userName]       VARCHAR (23)    NULL,
    [RecordDate]     DATETIME        NOT NULL,
    [TotalSurcharge] SMALLMONEY      NULL,
    [duration]       INT             NULL,
    [ConnectDate]    CHAR (6)        NULL,
    [Dberror]        CHAR (1)        NULL,
    [ResponseCode]   CHAR (3)        NULL,
    [AuthName]       VARCHAR (50)    NULL,
    [ConfigID]       VARCHAR (5)     NULL,
    [Pif]            NUMERIC (4, 2)  CONSTRAINT [DF__tblCallsBil__Pif__6ABAD62E] DEFAULT ((0)) NULL,
    [NSF]            NUMERIC (4, 2)  CONSTRAINT [DF__tblCallsBil__NSF__6BAEFA67] DEFAULT ((0)) NULL,
    [PSC]            NUMERIC (4, 2)  CONSTRAINT [DF__tblCallsBil__PSC__6CA31EA0] DEFAULT ((0)) NULL,
    [NIF]            NUMERIC (4, 2)  CONSTRAINT [DF__tblCallsBil__NIF__6D9742D9] DEFAULT ((0)) NULL,
    [BDf]            NUMERIC (4, 2)  CONSTRAINT [DF__tblCallsBil__BDf__6E8B6712] DEFAULT ((0)) NULL,
    [RAF]            NUMERIC (4, 2)  CONSTRAINT [DF__tblCallsBil__RAF__6F7F8B4B] DEFAULT ((0)) NULL,
    [BSF]            NUMERIC (4, 2)  CONSTRAINT [DF__tblCallsBil__BSF__7073AF84] DEFAULT ((0)) NULL,
    [OpSeqNo]        VARCHAR (6)     NULL,
    [AgentID]        VARCHAR (7)     NULL,
    [Fee2]           NUMERIC (4, 2)  CONSTRAINT [DF__tblCallsBi__Fee2__7167D3BD] DEFAULT ((0)) NULL,
    [Fee3]           NUMERIC (5, 2)  CONSTRAINT [DF__tblCallsBi__Fee3__725BF7F6] DEFAULT ((0)) NULL,
    [RecordFile]     VARCHAR (20)    NULL,
    [MinIncrement]   TINYINT         CONSTRAINT [DF__tblCallsB__MinIn__73501C2F] DEFAULT ((1)) NULL,
    [FolderDate]     CHAR (8)        NULL,
    [Channel]        VARCHAR (3)     NULL,
    [InmateID]       VARCHAR (12)    NULL,
    [CallRevenue]    NUMERIC (5, 2)  NULL,
    [PIN]            VARCHAR (12)    NULL,
    [FacilityID]     INT             NULL,
    [BadDebtRate]    NUMERIC (4, 2)  NULL,
    [CommRate]       NUMERIC (4, 2)  NULL,
    [InRecordFile]   VARCHAR (20)    NULL,
    [LocationId]     INT             NULL,
    [DivisionId]     INT             NULL,
    [PhoneType]      TINYINT         NULL,
    [CCEncr]         VARBINARY (200) NULL,
    [AcDuration]     SMALLINT        NULL,
    [UserLanguage]   TINYINT         NULL,
    CONSTRAINT [PK_tblcallbilled_record] PRIMARY KEY CLUSTERED ([RecordDate] ASC, [FromNo] ASC, [ToNo] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_billtype]
    ON [dbo].[tblCallsBilled]([FacilityID] ASC, [RecordDate] ASC, [billType] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_id]
    ON [dbo].[tblCallsBilled]([RecordID] ASC, [FacilityID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_facility]
    ON [dbo].[tblCallsBilled]([FacilityID] ASC, [RecordDate] ASC, [FromNo] ASC, [PIN] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_calltype]
    ON [dbo].[tblCallsBilled]([RecordDate] ASC, [FacilityID] ASC, [CallType] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_PIN]
    ON [dbo].[tblCallsBilled]([FacilityID] ASC, [PIN] ASC, [billType] ASC, [RecordDate] ASC);


GO
CREATE NONCLUSTERED INDEX [Ind_debitCard]
    ON [dbo].[tblCallsBilled]([CreditCardNo] ASC, [RecordDate] ASC, [FacilityID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_error]
    ON [dbo].[tblCallsBilled]([complete] ASC, [errorCode] ASC, [RecordDate] ASC, [FacilityID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_InmateID]
    ON [dbo].[tblCallsBilled]([billType] ASC, [CallType] ASC, [RecordDate] ASC, [InmateID] ASC, [FacilityID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_thresthold]
    ON [dbo].[tblCallsBilled]([ToNo] ASC, [complete] ASC, [billType] ASC, [RecordDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCallsBilled_Calldate_errorCode_duration_billType_FacilityID]
    ON [dbo].[tblCallsBilled]([Calldate] ASC, [errorCode] ASC, [duration] ASC, [billType] ASC, [FacilityID] ASC)
    INCLUDE([FromNo], [ToNo], [RecordDate], [AgentID]);

