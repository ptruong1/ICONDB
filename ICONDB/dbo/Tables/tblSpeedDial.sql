CREATE TABLE [dbo].[tblSpeedDial] (
    [FacilityID]  INT          NOT NULL,
    [SpeedDial]   VARCHAR (7)  NOT NULL,
    [DNI]         VARCHAR (15) NOT NULL,
    [MaxCallTime] SMALLINT     NULL,
    [Descript]    VARCHAR (20) NULL,
    [billable]    BIT          CONSTRAINT [DF__tblSpeedD__billa__08AB2BC8] DEFAULT ((0)) NULL,
    [Inputdate]   DATETIME     DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblSpeedDial] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [SpeedDial] ASC, [DNI] ASC)
);

