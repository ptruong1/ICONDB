CREATE TABLE [dbo].[tblFacilityArchiveInfo] (
    [FacilityID]      INT           NOT NULL,
    [BeginDate]       SMALLDATETIME NULL,
    [EndDate]         SMALLDATETIME NULL,
    [CDRArchive]      SMALLINT      NULL,
    [RecordArchive]   SMALLINT      NULL,
    [StoragePeriod]   SMALLINT      NULL,
    [StorageLocation] VARCHAR (20)  NULL,
    [InputDate]       SMALLDATETIME NULL,
    [UserName]        VARCHAR (25)  NULL,
    CONSTRAINT [PK_tblFacilityArchiveInfo] PRIMARY KEY CLUSTERED ([FacilityID] ASC),
    CONSTRAINT [FK_tblFacilityArchiveInfo_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);

