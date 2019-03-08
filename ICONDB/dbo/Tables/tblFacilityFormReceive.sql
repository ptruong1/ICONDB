CREATE TABLE [dbo].[tblFacilityFormReceive] (
    [FacilityID]     INT           NOT NULL,
    [FormStatusID]   SMALLINT      NOT NULL,
    [ReceivedEmails] VARCHAR (100) NULL,
    [InputDate]      DATETIME      NULL,
    [ModifyDate]     DATETIME      NULL,
    [UserName]       VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblFacilityFormReceive] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [FormStatusID] ASC),
    CONSTRAINT [FK_tblFacilityFormReceive_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID]),
    CONSTRAINT [FK_tblFacilityFormReceive_tblFormstatus] FOREIGN KEY ([FormStatusID]) REFERENCES [dbo].[tblFormstatus] ([statusID])
);

