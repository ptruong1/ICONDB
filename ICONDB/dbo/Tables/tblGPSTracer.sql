CREATE TABLE [dbo].[tblGPSTracer] (
    [FacilityID]    INT           NOT NULL,
    [TraceBy]       TINYINT       NULL,
    [TraceNo]       VARCHAR (15)  NOT NULL,
    [TraceInterval] TINYINT       NULL,
    [InputBy]       VARCHAR (25)  NULL,
    [InputDate]     SMALLDATETIME NULL,
    [ModifyDate]    SMALLDATETIME NULL,
    CONSTRAINT [PK_tblGPSTracer] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [TraceNo] ASC),
    CONSTRAINT [FK_tblGPSTracer_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);

