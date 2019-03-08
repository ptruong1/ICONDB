CREATE TABLE [dbo].[tblInmateBookInfo] (
    [PIN]            VARCHAR (12)    NOT NULL,
    [FacilityID]     INT             NOT NULL,
    [BookingNO]      VARCHAR (12)    NOT NULL,
    [ChargeCode]     VARCHAR (20)    NOT NULL,
    [ChargeDescript] VARCHAR (200)   NOT NULL,
    [Level]          VARCHAR (20)    NULL,
    [CaseNo]         VARCHAR (25)    NULL,
    [MODIFIER]       VARCHAR (30)    NULL,
    [BAILOUT]        CHAR (1)        NULL,
    [BAILAMOUNT]     NUMERIC (10, 2) NULL,
    [COURT]          VARCHAR (30)    NULL,
    [Visits]         SMALLINT        NULL,
    [Balance]        NUMERIC (7, 2)  NULL,
    [Judge]          VARCHAR (40)    NULL,
    [ApperanceDate]  VARCHAR (30)    NULL,
    [SentenceDate]   VARCHAR (12)    NULL,
    [ReleaseDate]    VARCHAR (12)    NULL,
    [SentenceDays]   VARCHAR (40)    NULL,
    [InmateID]       VARCHAR (12)    NULL,
    [BookRecordDate] DATETIME        DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblInmateBookInfo_1] PRIMARY KEY CLUSTERED ([PIN] ASC, [FacilityID] ASC, [BookingNO] ASC, [ChargeCode] ASC, [ChargeDescript] ASC)
);

