CREATE TABLE [dbo].[tblWUPrepaid] (
    [CustSeqNo]   INT          NOT NULL,
    [RecordType]  CHAR (1)     CONSTRAINT [DF_tblWesternUnionPrepaid_RecordType] DEFAULT ('D') NULL,
    [PSCNo]       CHAR (16)    CONSTRAINT [DF_tblWesternUnionPrepaid_PSCNo] DEFAULT ('0000000000000000') NULL,
    [ClientID]    CHAR (9)     CONSTRAINT [DF_tblWesternUnionPrepaid_ClientID] DEFAULT ('ALA467179') NULL,
    [CustAcctNo]  CHAR (23)    NOT NULL,
    [FirstName]   CHAR (16)    NULL,
    [LastName]    CHAR (21)    NULL,
    [Address]     CHAR (40)    NULL,
    [City]        CHAR (24)    NULL,
    [State]       CHAR (2)     NULL,
    [Zip]         CHAR (9)     NULL,
    [Country]     CHAR (3)     NULL,
    [Phone]       VARCHAR (12) NULL,
    [ProcessType] CHAR (1)     NOT NULL,
    [IssueCard]   CHAR (1)     CONSTRAINT [DF_tblWesternUnionPrepaid_IssueCard] DEFAULT ('N') NULL,
    [FacilityID]  INT          NULL,
    [RecordDate]  DATETIME     CONSTRAINT [DF_tblWesternUnionPrepaid_RecordDate] DEFAULT (getdate()) NULL,
    [UploadFTP]   BIT          CONSTRAINT [DF_tblWesternUnionPrepaid_UploadFTP] DEFAULT ((0)) NULL,
    [DownLoadFTP] BIT          CONSTRAINT [DF_tblWesternUnionPrepaid_DownLoadFTP] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblWesternUnionPrepaid] PRIMARY KEY CLUSTERED ([CustAcctNo] ASC, [ProcessType] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_up_down]
    ON [dbo].[tblWUPrepaid]([CustSeqNo] ASC, [UploadFTP] ASC, [DownLoadFTP] ASC);

