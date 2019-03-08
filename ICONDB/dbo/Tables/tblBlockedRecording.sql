CREATE TABLE [dbo].[tblBlockedRecording] (
    [FacilityID]  INT          NULL,
    [RecordID]    BIGINT       NULL,
    [PIN]         VARCHAR (12) NULL,
    [ToNo]        VARCHAR (15) NULL,
    [BlockedBy]   VARCHAR (25) NULL,
    [BlockedDate] DATETIME     NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_1]
    ON [dbo].[tblBlockedRecording]([FacilityID] ASC, [RecordID] ASC, [PIN] ASC, [ToNo] ASC);

