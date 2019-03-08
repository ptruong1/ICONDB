CREATE TABLE [dbo].[tblCommissary] (
    [facilityId]      INT          NOT NULL,
    [CommissaryPhone] VARCHAR (20) NULL,
    [CommissaryIP]    VARCHAR (30) NULL,
    [Client]          VARCHAR (20) NULL,
    CONSTRAINT [PK_tblCommissary] PRIMARY KEY CLUSTERED ([facilityId] ASC),
    CONSTRAINT [FK_tblCommissary_tblFacility] FOREIGN KEY ([facilityId]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);

