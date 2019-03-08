CREATE TABLE [dbo].[tblAuth] (
    [authID]      INT           NOT NULL,
    [admin]       BIT           NULL,
    [monitor]     BIT           NULL,
    [finance]     BIT           NULL,
    [dataEntry]   BIT           NULL,
    [Description] VARCHAR (50)  NULL,
    [inputdate]   SMALLDATETIME CONSTRAINT [DF_tblAuth_inputdate] DEFAULT (getdate()) NULL,
    [controler]   BIT           CONSTRAINT [DF__tblAuth__control__507BE13E] DEFAULT ((0)) NULL,
    [UserDefined] BIT           CONSTRAINT [DF__tblAuth__UserDef__29E20261] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblAuth] PRIMARY KEY CLUSTERED ([authID] ASC)
);

