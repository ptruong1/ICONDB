CREATE TABLE [dbo].[tblCommunicationType] (
    [CommID]      TINYINT      NOT NULL,
    [Description] VARCHAR (20) NULL,
    CONSTRAINT [PK_tblCommunicationType] PRIMARY KEY CLUSTERED ([CommID] ASC)
);

