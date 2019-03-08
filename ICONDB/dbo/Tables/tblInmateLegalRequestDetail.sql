CREATE TABLE [dbo].[tblInmateLegalRequestDetail] (
    [FormID]         INT           NOT NULL,
    [RequestDocID]   TINYINT       NOT NULL,
    [RequestDoc]     VARCHAR (200) NULL,
    [SendDocType]    TINYINT       NULL,
    [SendDocDescipt] VARCHAR (200) NULL,
    [Pages]          SMALLINT      NULL,
    CONSTRAINT [PK_tblInmateLegalRequestDetail] PRIMARY KEY CLUSTERED ([FormID] ASC, [RequestDocID] ASC)
);

