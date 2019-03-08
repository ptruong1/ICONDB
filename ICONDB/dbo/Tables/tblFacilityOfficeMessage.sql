CREATE TABLE [dbo].[tblFacilityOfficeMessage] (
    [MessageID]  INT           NOT NULL,
    [FacilityID] INT           NOT NULL,
    [Message]    VARCHAR (500) NOT NULL,
    [PostBy]     VARCHAR (25)  NOT NULL,
    [ModifyBy]   VARCHAR (25)  NULL,
    [PostDate]   DATETIME      NOT NULL,
    [ModifyDate] DATETIME      NULL,
    [FromDate]   DATE          NOT NULL,
    [ToDate]     DATE          NOT NULL,
    CONSTRAINT [PK_tblFacilityOfficeMessage] PRIMARY KEY CLUSTERED ([MessageID] ASC)
);

