CREATE TABLE [dbo].[tblDivisionTimeCallPeriod] (
    [PeriodID]   INT           NOT NULL,
    [FacilityID] INT           NOT NULL,
    [DivisionID] INT           NOT NULL,
    [Day]        TINYINT       NOT NULL,
    [FromTime]   VARCHAR (5)   NOT NULL,
    [ToTime]     VARCHAR (5)   NOT NULL,
    [inputdate]  SMALLDATETIME NULL,
    [modifydate] SMALLDATETIME NULL,
    [userName]   VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblDivisionTimeCallPeriod] PRIMARY KEY CLUSTERED ([PeriodID] ASC, [FacilityID] ASC, [DivisionID] ASC, [Day] ASC)
);

