CREATE TABLE [dbo].[tblPrepaidRate] (
    [RecordID]     INT            NOT NULL,
    [RatePlanID]   VARCHAR (5)    NULL,
    [firstMin]     NUMERIC (4, 2) NULL,
    [NextMin]      NUMERIC (4, 2) NULL,
    [ConnectFee]   NUMERIC (4, 2) NULL,
    [SurchargeFee] NUMERIC (4, 2) NULL,
    [Calltype]     TINYINT        NULL,
    [UserName]     VARCHAR (50)   NULL,
    [InputDate]    SMALLDATETIME  NULL,
    [ModifyDate]   SMALLDATETIME  NULL,
    [MinMinute]    TINYINT        NULL,
    [Increment]    TINYINT        NULL,
    [DayCode]      TINYINT        NULL,
    [PointID]      VARCHAR (2)    NULL
);

