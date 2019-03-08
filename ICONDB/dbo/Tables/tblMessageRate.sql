CREATE TABLE [dbo].[tblMessageRate] (
    [FacilityID]     INT          NOT NULL,
    [MessageTypeID]  TINYINT      NOT NULL,
    [Charge]         SMALLMONEY   NULL,
    [ChargePerTrans] SMALLMONEY   NULL,
    [Comm]           SMALLMONEY   NULL,
    [InputDate]      DATETIME     NULL,
    [ModifyDate]     DATETIME     NULL,
    [UserName]       VARCHAR (25) NULL,
    CONSTRAINT [PK_tblMessageRate] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [MessageTypeID] ASC)
);

