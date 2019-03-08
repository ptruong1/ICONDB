CREATE TABLE [dbo].[tblFacilityLocation] (
    [LocationID]      INT           NOT NULL,
    [DivisionID]      INT           NOT NULL,
    [Descript]        VARCHAR (50)  NULL,
    [DayTimeRestrict] BIT           CONSTRAINT [DF_tblFacilityLocation_DayTimeRestrict] DEFAULT ((0)) NOT NULL,
    [PINrequired]     BIT           CONSTRAINT [DF_tblFacilityLocation_PINrequired] DEFAULT ((0)) NOT NULL,
    [UserName]        VARCHAR (25)  NULL,
    [Inputdate]       SMALLDATETIME CONSTRAINT [DF_tblFacilityLocation_Inputdate] DEFAULT (getdate()) NULL,
    [ModifyDate]      SMALLDATETIME NULL,
    [MaxCallTime]     SMALLINT      NULL,
    [UseFor]          TINYINT       NULL,
    [LocationStatus]  TINYINT       CONSTRAINT [DF__tblFacili__Locat__66960AE6] DEFAULT ((1)) NULL,
    [IDRequired]      BIT           NULL,
    CONSTRAINT [PK_tblFacilityLocation] PRIMARY KEY CLUSTERED ([LocationID] ASC, [DivisionID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_DivID]
    ON [dbo].[tblFacilityLocation]([DivisionID] ASC);

