CREATE TABLE [dbo].[tblImateMessageConfig] (
    [FacilityID]              INT          NOT NULL,
    [InmateID]                VARCHAR (12) NOT NULL,
    [ApprovedReq]             BIT          NULL,
    [EmailPerDay]             TINYINT      NULL,
    [EmailPerWeek]            TINYINT      NULL,
    [EmailPerMonth]           TINYINT      NULL,
    [VideoMessagePerDay]      TINYINT      NULL,
    [VideoMessagePerWeek]     TINYINT      NULL,
    [VideoMessagePerMonth]    TINYINT      NULL,
    [PictureExchangePerday]   TINYINT      NULL,
    [PictureExchangePerWeek]  TINYINT      NULL,
    [PictureExchangePerMonty] TINYINT      NULL,
    [EmailDirOpt]             TINYINT      NULL,
    [InputDate]               DATETIME     NULL,
    [ModifyDate]              DATETIME     NULL,
    [UserName]                VARCHAR (25) NULL
);

