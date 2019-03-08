CREATE TABLE [dbo].[tblNonArchiveDNI] (
    [facilityID] INT           NOT NULL,
    [DNI]        VARCHAR (16)  NOT NULL,
    [InputDate]  SMALLDATETIME NULL,
    [UserName]   VARCHAR (25)  NULL,
    CONSTRAINT [PK_tblNonArchiveDNI] PRIMARY KEY CLUSTERED ([facilityID] ASC, [DNI] ASC)
);

