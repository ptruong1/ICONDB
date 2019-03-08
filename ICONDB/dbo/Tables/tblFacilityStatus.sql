CREATE TABLE [dbo].[tblFacilityStatus] (
    [status]   TINYINT    NOT NULL,
    [Descript] NCHAR (10) NULL,
    CONSTRAINT [PK_tblFacilityStatus] PRIMARY KEY CLUSTERED ([status] ASC)
);

