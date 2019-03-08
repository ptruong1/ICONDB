CREATE TABLE [dbo].[tblFacilityOfficeMessageToInmate] (
    [MessageID]  INT           NOT NULL,
    [FacilityID] INT           NOT NULL,
    [Message]    VARCHAR (500) NOT NULL,
    [InmateID]   VARCHAR (12)  NOT NULL,
    [PostBy]     VARCHAR (25)  NOT NULL,
    [ModifyBy]   VARCHAR (25)  NULL,
    [PostDate]   DATETIME      NOT NULL,
    [ModifyDate] DATETIME      NULL,
    [FromDate]   DATE          NOT NULL,
    [ToDate]     DATE          NOT NULL,
    CONSTRAINT [PK_tblFacilityOfficeMessageToInmate] PRIMARY KEY CLUSTERED ([MessageID] ASC)
);

