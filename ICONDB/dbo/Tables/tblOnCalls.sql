CREATE TABLE [dbo].[tblOnCalls] (
    [RecordID]       BIGINT       NOT NULL,
    [Calldate]       CHAR (6)     NOT NULL,
    [ConnectTime]    CHAR (6)     NOT NULL,
    [FromNo]         CHAR (10)    NOT NULL,
    [ToNo]           VARCHAR (18) NOT NULL,
    [BillToNo]       VARCHAR (10) NULL,
    [MethodOfRecord] CHAR (2)     NULL,
    [billType]       CHAR (2)     NULL,
    [CallType]       CHAR (2)     NULL,
    [FromState]      CHAR (2)     NULL,
    [FromCity]       VARCHAR (10) NULL,
    [ToState]        CHAR (2)     NULL,
    [ToCity]         VARCHAR (10) NULL,
    [CreditCardType] VARCHAR (10) NULL,
    [CreditCardNo]   VARCHAR (20) NULL,
    [CreditCardExp]  VARCHAR (4)  NULL,
    [CreditCardZip]  VARCHAR (10) NULL,
    [CreditCardCVV]  VARCHAR (4)  NULL,
    [CallPeriod]     CHAR (1)     NULL,
    [LibraryCode]    CHAR (2)     NULL,
    [Indicator19]    CHAR (1)     NULL,
    [SettlementCode] CHAR (1)     NULL,
    [ProjectCode]    CHAR (6)     NULL,
    [complete]       CHAR (1)     NULL,
    [errorCode]      TINYINT      NULL,
    [ratePlanID]     VARCHAR (7)  NULL,
    [firstMinute]    SMALLMONEY   NULL,
    [nextMinute]     SMALLMONEY   NULL,
    [connectFee]     SMALLMONEY   NULL,
    [minDuration]    TINYINT      NULL,
    [RateClass]      CHAR (1)     NULL,
    [userName]       VARCHAR (23) NULL,
    [RecordDate]     DATETIME     NULL,
    [TotalSurcharge] SMALLMONEY   NULL,
    [duration]       INT          NULL,
    [Dberror]        CHAR (1)     NULL,
    [ResponseCode]   CHAR (3)     NULL,
    [AuthName]       VARCHAR (50) NULL,
    [AgentID]        VARCHAR (7)  NULL,
    [RecordFile]     VARCHAR (20) NULL,
    [MinIncrement]   TINYINT      NULL,
    [FolderDate]     CHAR (8)     NULL,
    [Channel]        VARCHAR (5)  NULL,
    [InmateID]       VARCHAR (12) NULL,
    [PIN]            VARCHAR (12) NULL,
    [FacilityID]     INT          NULL,
    [InRecordFile]   VARCHAR (20) NULL,
    [Upload]         BIT          NULL,
    [DivisionId]     INT          NULL,
    [LocationId]     INT          NULL,
    [lastModify]     DATETIME     NULL,
    [PhoneType]      TINYINT      NULL,
    [UserLanguage]   TINYINT      NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_live]
    ON [dbo].[tblOnCalls]([FacilityID] ASC, [FromNo] ASC, [billType] ASC, [CallType] ASC, [InmateID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_RecorID]
    ON [dbo].[tblOnCalls]([RecordID] ASC);

