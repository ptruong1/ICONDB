CREATE TABLE [dbo].[tblCaseDetail] (
    [FacilityID]  INT           NULL,
    [CaseID]      INT           NULL,
    [RecordID]    BIGINT        NULL,
    [InquiryNote] VARCHAR (150) NULL,
    [InquiryDate] SMALLDATETIME NULL,
    [InmateID]    VARCHAR (12)  NULL,
    [InquiryBy]   VARCHAR (25)  NULL,
    [NoteID]      BIGINT        NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_caseID]
    ON [dbo].[tblCaseDetail]([FacilityID] ASC, [CaseID] ASC);

