CREATE TABLE [dbo].[tblANIs] (
    [PhoneID]         INT           NOT NULL,
    [ANINo]           CHAR (10)     NOT NULL,
    [StationID]       VARCHAR (50)  NULL,
    [facilityID]      INT           NULL,
    [DivisionID]      SMALLINT      NULL,
    [LocationID]      INT           NULL,
    [AccessTypeID]    TINYINT       NULL,
    [IDrequired]      BIT           CONSTRAINT [DF_tblANIs_IDrequired] DEFAULT ((0)) NULL,
    [PINRequired]     BIT           CONSTRAINT [DF_tblANIs_PINRequird] DEFAULT ((0)) NULL,
    [inputdate]       SMALLDATETIME CONSTRAINT [DF_tblANIs_inputdate] DEFAULT (getdate()) NULL,
    [modifyDate]      SMALLDATETIME NULL,
    [DayTimeRestrict] BIT           NULL,
    [UserName]        VARCHAR (25)  NULL,
    [MaxCallTime]     SMALLINT      NULL,
    [InforOpt]        TINYINT       NULL,
    [IsFree]          BIT           NULL,
    [DebitOpt]        BIT           NULL,
    [ANINoStatus]     TINYINT       CONSTRAINT [DF__tblANIs__ANINoSt__678A2F1F] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblANIs] PRIMARY KEY CLUSTERED ([ANINo] ASC),
    CONSTRAINT [FK_tblANIs_tblFacility] FOREIGN KEY ([facilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);


GO
CREATE NONCLUSTERED INDEX [ind_facility]
    ON [dbo].[tblANIs]([facilityID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_div]
    ON [dbo].[tblANIs]([DivisionID] ASC, [ANINo] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_LocID]
    ON [dbo].[tblANIs]([LocationID] ASC, [ANINo] ASC);

