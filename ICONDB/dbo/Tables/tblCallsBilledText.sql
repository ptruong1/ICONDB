CREATE TABLE [dbo].[tblCallsBilledText] (
    [RecordID]    BIGINT         NOT NULL,
    [InmateText]  VARCHAR (5000) NULL,
    [ContactText] VARCHAR (5000) NULL,
    CONSTRAINT [PK_tblCallsBilledText] PRIMARY KEY CLUSTERED ([RecordID] ASC)
);

