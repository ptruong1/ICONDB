CREATE TABLE [dbo].[tblATAstatusDetail] (
    [ATAIP]       VARCHAR (16) NULL,
    [PingTime]    DATETIME     CONSTRAINT [DF_tblATAstatusDetail_PingTime] DEFAULT (getdate()) NULL,
    [Status]      TINYINT      NULL,
    [ResonseTime] SMALLINT     NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_IP]
    ON [dbo].[tblATAstatusDetail]([ATAIP] ASC);

