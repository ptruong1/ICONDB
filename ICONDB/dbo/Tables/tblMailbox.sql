CREATE TABLE [dbo].[tblMailbox] (
    [MailboxID]     BIGINT       NOT NULL,
    [FacilityID]    INT          NOT NULL,
    [InmateID]      VARCHAR (12) NOT NULL,
    [SetupDate]     DATETIME     NULL,
    [status]        TINYINT      NULL,
    [MailBoxTypeID] TINYINT      NULL,
    [AccountNo]     VARCHAR (12) NULL,
    [ID]            INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tblMailbox] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [InmateID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_mailboxID]
    ON [dbo].[tblMailbox]([MailboxID] ASC);

