CREATE TABLE [dbo].[tblVisitLocation] (
    [LocationID]     INT          NOT NULL,
    [LocationName]   VARCHAR (35) NULL,
    [LocationIP]     VARCHAR (20) NULL,
    [FacilityID]     INT          NOT NULL,
    [inputDate]      DATETIME     NULL,
    [ModifyDate]     DATETIME     NULL,
    [userName]       VARCHAR (25) NULL,
    [LimitTime]      SMALLINT     NULL,
    [LockDown]       BIT          NULL,
    [LocationTypeID] TINYINT      NULL,
    [VperDay]        TINYINT      NULL,
    [VperWeek]       TINYINT      NULL,
    [VperMonth]      TINYINT      NULL,
    CONSTRAINT [PK_tblVisitLocation] PRIMARY KEY CLUSTERED ([LocationID] ASC)
);

