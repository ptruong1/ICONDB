CREATE TABLE [dbo].[tblSearchListDetail] (
    [SearchID]        INT           NOT NULL,
    [WatchListID]     INT           NULL,
    [LocationID]      INT           NULL,
    [PhonesID]        VARCHAR (500) NULL,
    [SourceNo]        VARCHAR (10)  NULL,
    [DestinationNo]   VARCHAR (10)  NULL,
    [Complete]        BIT           NULL,
    [Uncomplete]      BIT           NULL,
    [NonRecorded]     BIT           NULL,
    [Threeway]        BIT           NULL,
    [PIN]             INT           NULL,
    [InmateFirstName] VARCHAR (25)  NULL,
    [InmateLastName]  VARCHAR (25)  NULL,
    [FromDate]        DATETIME      NULL,
    [ToDate]          DATETIME      NULL,
    CONSTRAINT [PK_tblSearchListDetail] PRIMARY KEY CLUSTERED ([SearchID] ASC)
);

