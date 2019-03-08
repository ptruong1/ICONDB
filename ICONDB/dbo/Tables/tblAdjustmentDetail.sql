CREATE TABLE [dbo].[tblAdjustmentDetail] (
    [AdjID]    INT           NOT NULL,
    [Note]     VARCHAR (300) NULL,
    [NoteDate] DATETIME      CONSTRAINT [DF_tblCustServiceDetail_NoteDate] DEFAULT (getdate()) NULL,
    [UserName] VARCHAR (25)  NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_adjID]
    ON [dbo].[tblAdjustmentDetail]([AdjID] ASC);

