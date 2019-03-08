CREATE TABLE [dbo].[tblFTPFileProcess] (
    [FacilityID]  INT          NOT NULL,
    [FolderName]  VARCHAR (25) NULL,
    [lastUpdate]  DATETIME     NULL,
    [FTPFileName] VARCHAR (25) NULL,
    [FileCount]   INT          NULL,
    CONSTRAINT [PK_tblFTPFileProcess] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_update]
    ON [dbo].[tblFTPFileProcess]([FacilityID] ASC, [lastUpdate] ASC);

