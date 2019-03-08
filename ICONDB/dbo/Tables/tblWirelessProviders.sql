CREATE TABLE [dbo].[tblWirelessProviders] (
    [wirelessID]   TINYINT      NOT NULL,
    [WirelessName] VARCHAR (25) NULL,
    [Email_ext]    VARCHAR (30) NULL,
    CONSTRAINT [PK_tblWirelessProviders] PRIMARY KEY CLUSTERED ([wirelessID] ASC)
);

