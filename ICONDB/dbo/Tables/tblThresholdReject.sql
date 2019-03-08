CREATE TABLE [dbo].[tblThresholdReject] (
    [billToNo]   VARCHAR (16) NULL,
    [facilityID] INT          NULL,
    [billtype]   VARCHAR (2)  NULL,
    [recordDate] DATETIME     NULL,
    [calldate]   CHAR (6)     NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_billtono]
    ON [dbo].[tblThresholdReject]([billToNo] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_facility]
    ON [dbo].[tblThresholdReject]([facilityID] ASC, [billtype] ASC);

