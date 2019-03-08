CREATE TABLE [dbo].[tblRecordStack] (
    [RecordID]    BIGINT        NOT NULL,
    [RecordPath]  VARCHAR (100) NULL,
    [KeysWords]   VARCHAR (500) NULL,
    [RequestDate] SMALLDATETIME NULL,
    [priority]    TINYINT       NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_requestDate]
    ON [dbo].[tblRecordStack]([RequestDate] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_recordID]
    ON [dbo].[tblRecordStack]([RecordID] ASC);

