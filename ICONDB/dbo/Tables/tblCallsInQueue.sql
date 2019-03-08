CREATE TABLE [dbo].[tblCallsInQueue] (
    [PIN]         VARCHAR (12) NULL,
    [InmateID]    VARCHAR (12) NULL,
    [FromNo]      VARCHAR (12) NULL,
    [ToNo]        VARCHAR (18) NULL,
    [ProcessType] TINYINT      NULL,
    [Duration]    SMALLINT     NULL,
    [Charge]      SMALLMONEY   NULL,
    [RecordID]    BIGINT       NULL,
    [InputTime]   DATETIME     NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_RecordID_inputTime]
    ON [dbo].[tblCallsInQueue]([RecordID] ASC, [InputTime] ASC);

