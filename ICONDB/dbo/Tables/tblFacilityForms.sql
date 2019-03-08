CREATE TABLE [dbo].[tblFacilityForms] (
    [FacilityID]              INT           NOT NULL,
    [MedicalKite]             BIT           NULL,
    [InmateKite]              BIT           NULL,
    [Grievance]               BIT           NULL,
    [MedicalKiteReceiveEmail] VARCHAR (500) NULL,
    [InmateKiteReceiveEmail]  VARCHAR (500) NULL,
    [GrievanceReceiveEmail]   VARCHAR (500) NULL,
    [MedProvider]             VARCHAR (20)  NULL,
    [Template]                INT           NULL,
    [LegalForm]               BIT           NULL,
    [MedTemplate]             INT           NULL,
    [InmateTemplate]          INT           NULL,
    [LegalTemplate]           INT           NULL,
    [GrievanceTemplate]       INT           NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_facilityID_form]
    ON [dbo].[tblFacilityForms]([FacilityID] ASC);

