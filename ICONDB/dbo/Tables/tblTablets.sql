CREATE TABLE [dbo].[tblTablets] (
    [TabletID]      VARCHAR (15) NOT NULL,
    [FacilityID]    INT          NULL,
    [CenterID]      INT          NULL,
    [InputDate]     DATETIME     NULL,
    [ModifyDate]    DATETIME     NULL,
    [Status]        TINYINT      NULL,
    [InputBy]       VARCHAR (25) NULL,
    [VideoVisitOpt] BIT          NULL,
    CONSTRAINT [PK_tblTablets] PRIMARY KEY CLUSTERED ([TabletID] ASC)
);

