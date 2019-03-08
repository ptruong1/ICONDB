CREATE TABLE [dbo].[tblFeesDetail] (
    [FeeDetailID] SMALLINT      NOT NULL,
    [Descript]    VARCHAR (500) NULL,
    [FeeType]     VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblFeesDetail] PRIMARY KEY CLUSTERED ([FeeDetailID] ASC)
);

