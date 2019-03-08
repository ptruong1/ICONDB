CREATE TABLE [dbo].[tblFacilityTechOrderDetail] (
    [WorkOrdNo]          INT            NOT NULL,
    [WorkDetailNo]       INT            NOT NULL,
    [WorkDetailDescript] VARCHAR (50)   NULL,
    [WorkDetailHour]     DECIMAL (5, 2) NULL,
    [WorkDetailAmount]   DECIMAL (6, 2) NULL,
    [WorkDetailDate]     SMALLDATETIME  NULL,
    CONSTRAINT [PK_tblLocWorkOrderDetail] PRIMARY KEY CLUSTERED ([WorkOrdNo] ASC, [WorkDetailNo] ASC)
);

