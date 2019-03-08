CREATE TABLE [dbo].[tblDebitRate] (
    [RecordID]     INT            NOT NULL,
    [RatePlanID]   VARCHAR (5)    NOT NULL,
    [firstMin]     NUMERIC (4, 2) NULL,
    [NextMin]      NUMERIC (4, 2) NULL,
    [ConnectFee]   NUMERIC (4, 2) NULL,
    [SurchargeFee] NUMERIC (4, 2) NULL,
    [Calltype]     TINYINT        NOT NULL,
    [UserName]     VARCHAR (50)   NULL,
    [InputDate]    SMALLDATETIME  CONSTRAINT [DF_tblDebitRate_InputDate] DEFAULT (getdate()) NULL,
    [ModifyDate]   SMALLDATETIME  NULL,
    [MinMinute]    TINYINT        CONSTRAINT [DF_tblDebitRate_MinMinute] DEFAULT ((1)) NULL,
    [Increment]    TINYINT        CONSTRAINT [DF_tblDebitRate_Increment] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblDebitRate] PRIMARY KEY CLUSTERED ([RatePlanID] ASC, [Calltype] ASC)
);

