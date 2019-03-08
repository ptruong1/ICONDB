CREATE TABLE [dbo].[tblVisitRate] (
    [RateID]            VARCHAR (7)    NOT NULL,
    [PerMinCharge]      NUMERIC (4, 2) NULL,
    [ConnectFee]        NUMERIC (4, 2) NULL,
    [Descript]          VARCHAR (20)   NULL,
    [VisitType]         TINYINT        NOT NULL,
    [Increment]         TINYINT        CONSTRAINT [DF__tblVisitR__Incre__1328BA3B] DEFAULT ((1)) NULL,
    [CommRate]          NUMERIC (4, 2) NULL,
    [RateQuotaPerMonth] SMALLINT       NULL,
    [InputDate]         DATETIME       NULL,
    [ModifyDate]        DATETIME       NULL,
    [FreePerWeek]       SMALLINT       NULL,
    CONSTRAINT [PK_tblVisitRate_1] PRIMARY KEY CLUSTERED ([RateID] ASC, [VisitType] ASC)
);

