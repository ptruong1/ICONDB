CREATE TABLE [dbo].[tblBioMetricIdentifyResults] (
    [RecordID]       BIGINT        NOT NULL,
    [FacilityID]     INT           NOT NULL,
    [InmateID]       VARCHAR (12)  NOT NULL,
    [OriginalUser]   VARCHAR (15)  NOT NULL,
    [SuspectedUsers] VARCHAR (100) NULL,
    [Probabilities]  VARCHAR (60)  NULL,
    [Scores]         VARCHAR (60)  NULL,
    [InputTime]      DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_biometric_facility_inmateID_recordID]
    ON [dbo].[tblBioMetricIdentifyResults]([RecordID] ASC, [FacilityID] ASC, [InmateID] ASC);

