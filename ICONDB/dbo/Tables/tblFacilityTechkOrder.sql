CREATE TABLE [dbo].[tblFacilityTechkOrder] (
    [WorkOrderNo]   INT            NOT NULL,
    [WorkDescrip]   VARCHAR (150)  NULL,
    [WorkAmount]    NUMERIC (8, 2) NULL,
    [WorkStartDate] SMALLDATETIME  NULL,
    [WorkStatus]    TINYINT        NULL,
    [WorkCompDate]  SMALLDATETIME  NULL,
    [TechID]        INT            NULL,
    CONSTRAINT [PK_tblLocWorkOrder] PRIMARY KEY CLUSTERED ([WorkOrderNo] ASC),
    CONSTRAINT [FK_tblFacilityTechkOrder_tblFacilityTechInfo] FOREIGN KEY ([TechID]) REFERENCES [dbo].[tblFacilityTechInfo] ([TechID])
);

