CREATE TABLE [dbo].[tblAuthDebitTab] (
    [AuthID]       BIGINT NOT NULL,
    [ListDebit]    BIT    CONSTRAINT [DF_tblAuthDebitTab_ListDebit] DEFAULT ((1)) NULL,
    [SearchDebit]  BIT    CONSTRAINT [DF_tblAuthDebitTab_SearchDebit] DEFAULT ((1)) NULL,
    [TransferFund] BIT    CONSTRAINT [DF_tblAuthDebitTab_TransferFund] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblAuthDebitTab] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

