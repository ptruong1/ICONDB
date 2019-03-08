CREATE TABLE [dbo].[tblFacility] (
    [FacilityID]        INT           NOT NULL,
    [Location]          VARCHAR (50)  NULL,
    [Address]           VARCHAR (50)  NULL,
    [City]              VARCHAR (20)  NULL,
    [State]             CHAR (2)      NULL,
    [Zipcode]           VARCHAR (10)  NULL,
    [Phone]             CHAR (10)     NULL,
    [ContactName]       VARCHAR (50)  NULL,
    [ContactPhone]      VARCHAR (10)  NULL,
    [ContactEmail]      VARCHAR (30)  NULL,
    [IPaddress]         VARCHAR (15)  NULL,
    [logo]              VARCHAR (30)  NULL,
    [AgentID]           INT           CONSTRAINT [DF_tblFacility_AgentID] DEFAULT ((0)) NULL,
    [RateplanID]        VARCHAR (5)   NULL,
    [SurchargeID]       VARCHAR (5)   NULL,
    [LibraryCode]       VARCHAR (2)   NULL,
    [inputdate]         SMALLDATETIME CONSTRAINT [DF_tblFacility_inputdate] DEFAULT (getdate()) NULL,
    [English]           BIT           CONSTRAINT [DF_tblFacility_English] DEFAULT ((1)) NOT NULL,
    [Spanish]           BIT           CONSTRAINT [DF_tblFacility_Spanish] DEFAULT ((1)) NOT NULL,
    [French]            BIT           CONSTRAINT [DF_tblFacility_French] DEFAULT ((0)) NOT NULL,
    [LiveOpt]           BIT           CONSTRAINT [DF_tblFacility_LiveOpt] DEFAULT ((0)) NOT NULL,
    [RateQuoteOpt]      BIT           CONSTRAINT [DF_tblFacility_RateQuoteOpt] DEFAULT ((0)) NOT NULL,
    [PromptFileID]      SMALLINT      CONSTRAINT [DF_tblFacility_PromptFileID] DEFAULT ((1)) NULL,
    [tollFreeNo]        CHAR (10)     NULL,
    [DayTimeRestrict]   BIT           CONSTRAINT [DF_tblFacility_DayRestrict] DEFAULT ((0)) NOT NULL,
    [UserName]          VARCHAR (20)  NULL,
    [modifyDate]        SMALLDATETIME NULL,
    [MaxCallTime]       SMALLINT      CONSTRAINT [DF_tblFacility_MaxCallTime] DEFAULT ((15)) NULL,
    [DebitOpt]          BIT           CONSTRAINT [DF_tblFacility_DebitOpt] DEFAULT ((1)) NOT NULL,
    [PINRequired]       BIT           CONSTRAINT [DF_tblFacility_PINRequired] DEFAULT ((0)) NOT NULL,
    [IncidentReportOpt] BIT           CONSTRAINT [DF_tblFacility_IncidentReportOpt] DEFAULT ((0)) NOT NULL,
    [BlockCallerOpt]    BIT           CONSTRAINT [DF_tblFacility_BlockCallerOpt] DEFAULT ((0)) NOT NULL,
    [CollectWithCC]     BIT           CONSTRAINT [DF_tblFacility_CollectWithCC] DEFAULT ((0)) NULL,
    [timeZone]          SMALLINT      NULL,
    [Probono]           BIT           CONSTRAINT [DF_tblFacility_Probono] DEFAULT ((0)) NULL,
    [OverLayOpt]        BIT           CONSTRAINT [DF_tblFacility_OverLayOpt] DEFAULT ((0)) NULL,
    [TYYOpt]            BIT           CONSTRAINT [DF__tblFacili__TYYOp__1E45672C] DEFAULT ((0)) NULL,
    [CommOpt]           BIT           CONSTRAINT [DF__tblFacili__CommO__76C185B7] DEFAULT ((0)) NULL,
    [DID]               CHAR (10)     NULL,
    [status]            TINYINT       CONSTRAINT [DF_tblFacility_status] DEFAULT ((1)) NULL,
    [BlockedByHour]     BIT           NULL,
    [flatform]          TINYINT       NULL,
    [RecordOpt]         VARCHAR (1)   CONSTRAINT [DF__tblfacili__Recor__19B5BC39] DEFAULT ('Y') NULL,
    [AcctExeID]         TINYINT       CONSTRAINT [DF__tblFacili__AcctE__3667D4D7] DEFAULT ((1)) NULL,
    [AcctRepID]         TINYINT       CONSTRAINT [DF__tblFacili__AcctR__375BF910] DEFAULT ((1)) NULL,
    [GroupID]           INT           NULL,
    [PasswordPolicyId]  INT           NULL,
    CONSTRAINT [PK_tblFacility] PRIMARY KEY CLUSTERED ([FacilityID] ASC),
    CONSTRAINT [FK_tblFacility_tblAgent] FOREIGN KEY ([AgentID]) REFERENCES [dbo].[tblAgent] ([AgentID]),
    CONSTRAINT [FK_tblFacility_tblLibraryCode] FOREIGN KEY ([LibraryCode]) REFERENCES [dbo].[tblLibraryCode] ([LibraryCode]),
    CONSTRAINT [FK_tblFacility_tblPhonesStatus] FOREIGN KEY ([status]) REFERENCES [dbo].[tblPhoneStatus] ([StatusID]),
    CONSTRAINT [FK_tblFacility_tblSurcharge] FOREIGN KEY ([SurchargeID]) REFERENCES [dbo].[tblSurcharge] ([SurchargeID]),
    CONSTRAINT [FK_tblFacility_tblTimezone] FOREIGN KEY ([timeZone]) REFERENCES [dbo].[tblTimeZone] ([ZoneCode])
);


GO
CREATE NONCLUSTERED INDEX [ind_tollFee]
    ON [dbo].[tblFacility]([tollFreeNo] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_PromptID]
    ON [dbo].[tblFacility]([PromptFileID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_AgentID]
    ON [dbo].[tblFacility]([AgentID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_state]
    ON [dbo].[tblFacility]([State] ASC);


GO
CREATE TRIGGER [dbo].[trg_insert_default_inmate] ON dbo.tblFacility 
FOR INSERT
AS
Declare @facilityID int;

select @facilityID = facilityID from inserted ;

Insert tblInmate (InmateID,PIN,facilityID,Status) values('0','0',@facilityID,2);
