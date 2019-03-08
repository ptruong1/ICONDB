CREATE TABLE [dbo].[tblArrestCode] (
    [FacilityID] INT           NOT NULL,
    [Fstate]     VARCHAR (2)   NOT NULL,
    [ACode]      VARCHAR (40)  NOT NULL,
    [Agency]     VARCHAR (100) NULL,
    [ADescript]  VARCHAR (300) NULL,
    CONSTRAINT [PK_tblArrestCode_1] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [Fstate] ASC, [ACode] ASC)
);

