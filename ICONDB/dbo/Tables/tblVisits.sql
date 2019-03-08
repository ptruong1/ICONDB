CREATE TABLE [dbo].[tblVisits] (
    [ID]            BIGINT         NOT NULL,
    [InmateID]      VARCHAR (12)   NOT NULL,
    [FamilyAcct]    VARCHAR (12)   NOT NULL,
    [FacilityID]    INT            NOT NULL,
    [VisitDate]     DATETIME       NOT NULL,
    [VisitType]     TINYINT        NOT NULL,
    [VisitStatus]   TINYINT        NOT NULL,
    [VisitDuration] SMALLINT       NOT NULL,
    [Cost]          NUMERIC (5, 2) NOT NULL,
    CONSTRAINT [PK_tblVisits] PRIMARY KEY CLUSTERED ([ID] ASC)
);

