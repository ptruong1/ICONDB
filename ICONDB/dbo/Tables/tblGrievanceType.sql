CREATE TABLE [dbo].[tblGrievanceType] (
    [GrievanceType] TINYINT      NOT NULL,
    [Descript]      VARCHAR (30) NULL,
    CONSTRAINT [PK_tblGrievanceType] PRIMARY KEY CLUSTERED ([GrievanceType] ASC)
);

