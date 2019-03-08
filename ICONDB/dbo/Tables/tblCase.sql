CREATE TABLE [dbo].[tblCase] (
    [CaseID]     INT           NOT NULL,
    [FacilityID] INT           NOT NULL,
    [Descript]   VARCHAR (50)  NULL,
    [OpenDate]   SMALLDATETIME NULL,
    [Status]     TINYINT       NULL,
    [ClosedDate] SMALLDATETIME NULL,
    CONSTRAINT [PK_tblCase] PRIMARY KEY CLUSTERED ([CaseID] ASC, [FacilityID] ASC)
);

