CREATE TABLE [dbo].[tblInmateUpdate] (
    [PIN]         VARCHAR (12)   NOT NULL,
    [FacilityID]  INT            NOT NULL,
    [VisitNo]     INT            NULL,
    [ComBalance]  NUMERIC (8, 2) NULL,
    [AtLocation]  VARCHAR (50)   NULL,
    [releaseDate] VARCHAR (12)   NULL,
    [LastUpdate]  DATETIME       NULL,
    [InmateID]    VARCHAR (12)   NULL,
    CONSTRAINT [PK_tblInmateUpdate] PRIMARY KEY CLUSTERED ([PIN] ASC, [FacilityID] ASC)
);

