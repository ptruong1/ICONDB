CREATE TABLE [dbo].[tblSurcharge] (
    [SurchargeID] VARCHAR (5)  NOT NULL,
    [Descript]    VARCHAR (50) NULL,
    CONSTRAINT [PK_tblSurcharge] PRIMARY KEY CLUSTERED ([SurchargeID] ASC)
);

