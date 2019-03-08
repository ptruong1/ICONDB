CREATE TABLE [dbo].[tblInmateInfo] (
    [BookingNo]     VARCHAR (12)  NOT NULL,
    [PIN]           VARCHAR (12)  NOT NULL,
    [FacilityID]    INT           NOT NULL,
    [FullName]      CHAR (50)     NULL,
    [BirthDate]     VARCHAR (12)  NULL,
    [Sex]           CHAR (1)      NULL,
    [Race]          VARCHAR (40)  NULL,
    [HairColor]     VARCHAR (8)   NULL,
    [EyeColor]      CHAR (10)     NULL,
    [Height]        VARCHAR (10)  NULL,
    [SSN]           CHAR (9)      NULL,
    [Weight]        SMALLINT      NULL,
    [Age]           SMALLINT      NULL,
    [ArrestDate]    VARCHAR (12)  NULL,
    [ArrestTime]    VARCHAR (10)  NULL,
    [BookingDate]   VARCHAR (12)  NULL,
    [BookingTime]   VARCHAR (10)  NULL,
    [AgencyCaseNo]  VARCHAR (12)  NULL,
    [Agency]        VARCHAR (20)  NULL,
    [Location]      VARCHAR (30)  NULL,
    [HoldType]      VARCHAR (50)  NULL,
    [HoldStartDate] VARCHAR (12)  NULL,
    [Address1]      VARCHAR (100) NULL,
    [City]          VARCHAR (30)  NULL,
    [State]         VARCHAR (2)   NULL,
    [Zip]           VARCHAR (5)   NULL,
    [PictureName]   VARCHAR (70)  NULL,
    [InmateID]      VARCHAR (12)  NULL,
    [RecordDate]    DATETIME      DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblInmateInfo] PRIMARY KEY CLUSTERED ([BookingNo] ASC, [PIN] ASC, [FacilityID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_birthdate]
    ON [dbo].[tblInmateInfo]([PIN] ASC, [FacilityID] ASC, [BirthDate] ASC);

