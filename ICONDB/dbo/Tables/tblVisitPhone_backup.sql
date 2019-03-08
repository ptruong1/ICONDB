CREATE TABLE [dbo].[tblVisitPhone_backup] (
    [ExtID]       VARCHAR (15) NOT NULL,
    [StationID]   VARCHAR (25) NULL,
    [LocationID]  INT          NOT NULL,
    [FacilityID]  INT          NOT NULL,
    [RecordOpt]   CHAR (1)     NULL,
    [LimitTime]   SMALLINT     NULL,
    [PinRequired] BIT          NULL,
    [inputDate]   DATETIME     NULL,
    [ModifyDate]  DATETIME     NULL,
    [UserName]    VARCHAR (25) NULL,
    [ChatRoomID]  NCHAR (4)    NULL,
    [LockDown]    BIT          NULL,
    [status]      TINYINT      NULL,
    [StationType] TINYINT      NULL,
    [IDRequired]  BIT          NULL
);

