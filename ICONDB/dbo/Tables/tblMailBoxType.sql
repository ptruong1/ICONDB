CREATE TABLE [dbo].[tblMailBoxType] (
    [SenderTypeID] TINYINT      NOT NULL,
    [Descript]     VARCHAR (20) NULL,
    CONSTRAINT [PK_tblSenderType] PRIMARY KEY CLUSTERED ([SenderTypeID] ASC)
);

