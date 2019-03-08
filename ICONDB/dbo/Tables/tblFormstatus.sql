CREATE TABLE [dbo].[tblFormstatus] (
    [statusID]            SMALLINT      NOT NULL,
    [Descript]            VARCHAR (60)  NULL,
    [FacilityFormID]      INT           NULL,
    [InmateFormEmails]    VARCHAR (500) NULL,
    [MedicalFormEmails]   VARCHAR (500) NULL,
    [GrievanceFormEmails] VARCHAR (500) NULL,
    [LegalFormEmails]     VARCHAR (500) NULL,
    [Program]             VARCHAR (200) NULL,
    [Huber]               VARCHAR (200) NULL,
    CONSTRAINT [PK_tblFormstatus] PRIMARY KEY CLUSTERED ([statusID] ASC)
);

