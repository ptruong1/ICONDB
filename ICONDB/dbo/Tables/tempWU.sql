CREATE TABLE [dbo].[tempWU] (
    [CustSeqNo]   INT       NULL,
    [RecordType]  CHAR (1)  NULL,
    [PSCNo]       CHAR (16) NULL,
    [ClientID]    CHAR (9)  NULL,
    [CustAcctNo]  CHAR (23) NOT NULL,
    [FirstName]   CHAR (16) NULL,
    [LastName]    CHAR (21) NULL,
    [Address]     CHAR (40) NULL,
    [City]        CHAR (24) NULL,
    [State]       CHAR (2)  NULL,
    [Zip]         CHAR (9)  NULL,
    [Country]     CHAR (3)  NULL,
    [Phone]       CHAR (10) NULL,
    [ProcessType] CHAR (1)  NOT NULL,
    [IssueCard]   CHAR (1)  NULL
);

