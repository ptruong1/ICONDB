CREATE TABLE [dbo].[tblProduct] (
    [ProductTypeID] SMALLINT     NOT NULL,
    [Descript]      VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_tblProduct] PRIMARY KEY CLUSTERED ([ProductTypeID] ASC)
);

