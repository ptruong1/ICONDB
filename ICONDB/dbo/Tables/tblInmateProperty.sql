CREATE TABLE [dbo].[tblInmateProperty] (
    [FormID]     INT           NOT NULL,
    [Property]   VARCHAR (500) NULL,
    [AcceptName] VARCHAR (40)  NULL,
    CONSTRAINT [PK_tblInmateProperty] PRIMARY KEY CLUSTERED ([FormID] ASC)
);

