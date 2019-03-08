CREATE TABLE [dbo].[tblBioMetricProfileOxfordIdentification] (
    [UserID]            VARCHAR (16)   NOT NULL,
    [InputDate]         DATETIME       NULL,
    [ModifyDate]        DATETIME       NULL,
    [ProfileID]         NVARCHAR (100) NOT NULL,
    [RemainEnrollments] INT            NULL,
    [LanguageSelected]  VARCHAR (6)    NULL,
    [BioInmateID]       VARCHAR (12)   NULL,
    [StationId]         VARCHAR (12)   NULL,
    [LocId]             INT            NULL,
    [DivId]             INT            NULL,
    [RecordId]          BIGINT         NULL,
    [EnrolledFilePath]  VARCHAR (75)   NULL
);

