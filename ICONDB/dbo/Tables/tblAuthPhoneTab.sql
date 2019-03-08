CREATE TABLE [dbo].[tblAuthPhoneTab] (
    [AuthID]      BIGINT NOT NULL,
    [ListPhone]   BIT    CONSTRAINT [DF_tblAuthPhoneTab_ListPhone] DEFAULT ((1)) NULL,
    [SearchPhone] BIT    CONSTRAINT [DF_tblAuthPhoneTab_SearchPhone] DEFAULT ((1)) NULL,
    [VisitPhone]  BIT    NULL,
    [ListOfATA]   BIT    NULL,
    [LogATA]      BIT    NULL,
    CONSTRAINT [PK_tblAuthPhoneTab] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

