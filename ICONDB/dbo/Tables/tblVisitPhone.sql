CREATE TABLE [dbo].[tblVisitPhone] (
    [ExtID]       VARCHAR (15) NOT NULL,
    [StationID]   VARCHAR (25) NULL,
    [LocationID]  INT          NOT NULL,
    [FacilityID]  INT          NOT NULL,
    [RecordOpt]   CHAR (1)     NULL,
    [LimitTime]   SMALLINT     NULL,
    [PinRequired] BIT          NULL,
    [inputDate]   DATETIME     DEFAULT (getdate()) NULL,
    [ModifyDate]  DATETIME     NULL,
    [UserName]    VARCHAR (25) NULL,
    [ChatRoomID]  NCHAR (4)    NULL,
    [LockDown]    BIT          DEFAULT ((0)) NULL,
    [status]      TINYINT      CONSTRAINT [DF_tblVisitPhone_status] DEFAULT ((1)) NULL,
    [StationType] TINYINT      NULL,
    [IDRequired]  BIT          NULL,
    CONSTRAINT [PK_ExtID] PRIMARY KEY CLUSTERED ([ExtID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_location]
    ON [dbo].[tblVisitPhone]([LocationID] ASC, [FacilityID] ASC);

