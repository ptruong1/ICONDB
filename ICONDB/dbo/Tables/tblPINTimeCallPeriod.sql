CREATE TABLE [dbo].[tblPINTimeCallPeriod] (
    [PeriodID]   INT           NOT NULL,
    [FacilityID] INT           NOT NULL,
    [PIN]        VARCHAR (12)  NOT NULL,
    [Day]        TINYINT       NOT NULL,
    [FromTime]   VARCHAR (5)   NOT NULL,
    [ToTime]     VARCHAR (5)   NOT NULL,
    [inputdate]  SMALLDATETIME NULL,
    [modifydate] SMALLDATETIME NULL,
    [userName]   VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblPINTimeCallPeriod] PRIMARY KEY CLUSTERED ([PeriodID] ASC, [FacilityID] ASC, [PIN] ASC, [Day] ASC)
);

