CREATE TABLE [dbo].[tblMessages] (
    [ID]            BIGINT         NOT NULL,
    [InmateID]      VARCHAR (12)   NOT NULL,
    [FamilyAcct]    VARCHAR (12)   NOT NULL,
    [FacilityID]    INT            NOT NULL,
    [MessageType]   TINYINT        NOT NULL,
    [MessageStatus] TINYINT        NOT NULL,
    [Cost]          NUMERIC (5, 2) NOT NULL,
    [MessageDate]   DATETIME       NULL,
    CONSTRAINT [PK_tblMessages] PRIMARY KEY CLUSTERED ([ID] ASC)
);

