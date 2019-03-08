CREATE TABLE [dbo].[tblVisitInmateConfig] (
    [InmateID]      VARCHAR (12)  NOT NULL,
    [FacilityID]    INT           NOT NULL,
    [ApprovedReq]   BIT           CONSTRAINT [DF_tblVisitInmateConfig_ApprovedReq] DEFAULT ((0)) NOT NULL,
    [AtLocation]    VARCHAR (30)  NULL,
    [ExtID]         VARCHAR (12)  NULL,
    [SusStartDate]  DATE          NULL,
    [SusEndDate]    DATE          NULL,
    [PAV]           BIT           NULL,
    [MaxVisitor]    TINYINT       NULL,
    [VisitPerDay]   TINYINT       CONSTRAINT [DF_tblVisitInmateConfig_VisitPerDay] DEFAULT ((1)) NULL,
    [VisitPerWeek]  TINYINT       CONSTRAINT [DF_tblVisitInmateConfig_VisitPerWeek] DEFAULT ((4)) NULL,
    [VisitPerMonth] TINYINT       CONSTRAINT [DF_tblVisitInmateConfig_VisitPerMonth] DEFAULT ((10)) NULL,
    [LocationID]    INT           NULL,
    [MaxVisitTime]  SMALLINT      NULL,
    [InputDate]     SMALLDATETIME DEFAULT (getdate()) NULL,
    [ModifyDate]    SMALLDATETIME NULL,
    [VNote]         VARCHAR (150) NULL,
    [VisitRemain]   SMALLINT      CONSTRAINT [DF_tblVisitInmateConfig_VisitRemain] DEFAULT ((10)) NULL,
    CONSTRAINT [PK_tblVisitInmateConfig] PRIMARY KEY CLUSTERED ([InmateID] ASC, [FacilityID] ASC),
    CONSTRAINT [FK_tblVisitInmateConfig_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);


GO
CREATE NONCLUSTERED INDEX [ind_location]
    ON [dbo].[tblVisitInmateConfig]([LocationID] ASC);

