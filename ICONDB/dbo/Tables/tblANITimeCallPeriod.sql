CREATE TABLE [dbo].[tblANITimeCallPeriod] (
    [PeriodID]   INT           NOT NULL,
    [FacilityID] INT           NOT NULL,
    [ANI]        VARCHAR (10)  NOT NULL,
    [Day]        TINYINT       NOT NULL,
    [FromTime]   VARCHAR (5)   NOT NULL,
    [ToTime]     VARCHAR (5)   NOT NULL,
    [inputdate]  SMALLDATETIME NULL,
    [modifydate] SMALLDATETIME NULL,
    [userName]   VARCHAR (20)  NULL
);

