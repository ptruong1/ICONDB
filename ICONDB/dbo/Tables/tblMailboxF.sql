CREATE TABLE [dbo].[tblMailboxF] (
    [MailboxID]  BIGINT       NOT NULL,
    [FacilityID] INT          NOT NULL,
    [AccountNo]  VARCHAR (12) NOT NULL,
    [SetupDate]  DATETIME     NULL,
    [status]     TINYINT      NULL,
    [ID]         INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tblMailboxF] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [AccountNo] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ind_MailboxID]
    ON [dbo].[tblMailboxF]([MailboxID] ASC);

