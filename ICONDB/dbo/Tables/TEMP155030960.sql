CREATE TABLE [dbo].[TEMP155030960] (
    [RecordID]       VARCHAR (34) NULL,
    [InmateID]       VARCHAR (12) NULL,
    [InmateName]     VARCHAR (50) NULL,
    [ActivityDate]   DATETIME     NULL,
    [CommunityType]  VARCHAR (25) NULL,
    [StationID]      VARCHAR (25) NULL,
    [ContactPhone]   VARCHAR (18) NULL,
    [PhoneType]      VARCHAR (30) NULL,
    [ContactName]    VARCHAR (50) NULL,
    [Duration]       VARCHAR (20) NULL,
    [CommStatus]     VARCHAR (30) NULL,
    [RecordOpt]      VARCHAR (1)  DEFAULT ('Y') NULL,
    [ActivityStatus] VARCHAR (30) NULL,
    [rowNum]         INT          NULL
);

