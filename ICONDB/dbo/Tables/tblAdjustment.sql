CREATE TABLE [dbo].[tblAdjustment] (
    [AdjID]       INT            NOT NULL,
    [AdjTypeID]   TINYINT        CONSTRAINT [DF_tblAdjustment_AdjTypeID] DEFAULT ((1)) NULL,
    [AccountNo]   VARCHAR (18)   NULL,
    [LastBalance] NUMERIC (7, 2) NULL,
    [AdjAmount]   NUMERIC (7, 2) NULL,
    [Descript]    VARCHAR (200)  NULL,
    [AdjustDate]  DATETIME       NULL,
    [UserName]    VARCHAR (25)   NULL,
    [status]      TINYINT        CONSTRAINT [DF_tblAdjustment_status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblAdjustment] PRIMARY KEY CLUSTERED ([AdjID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ind_account]
    ON [dbo].[tblAdjustment]([AccountNo] ASC, [AdjID] ASC);

