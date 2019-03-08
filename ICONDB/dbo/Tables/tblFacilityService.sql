﻿CREATE TABLE [dbo].[tblFacilityService] (
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
    [AgentID]           INT           NULL,
    [RateplanID]        VARCHAR (5)   NULL,
    [SurchargeID]       VARCHAR (5)   NULL,
    [LibraryCode]       VARCHAR (2)   NULL,
    [inputdate]         SMALLDATETIME NULL,
    [English]           BIT           NOT NULL,
    [Spanish]           BIT           NOT NULL,
    [French]            BIT           NOT NULL,
    [LiveOpt]           BIT           NOT NULL,
    [RateQuoteOpt]      BIT           NOT NULL,
    [PromptFileID]      SMALLINT      NULL,
    [tollFreeNo]        CHAR (10)     NULL,
    [DayTimeRestrict]   BIT           NOT NULL,
    [UserName]          VARCHAR (20)  NULL,
    [modifyDate]        SMALLDATETIME NULL,
    [MaxCallTime]       SMALLINT      NULL,
    [DebitOpt]          BIT           NOT NULL,
    [PINRequired]       BIT           NOT NULL,
    [IncidentReportOpt] BIT           NOT NULL,
    [BlockCallerOpt]    BIT           NOT NULL,
    [CollectWithCC]     BIT           NULL,
    [timeZone]          SMALLINT      NULL,
    [Probono]           BIT           NULL,
    [OverLayOpt]        BIT           NULL,
    [TYYOpt]            BIT           NULL,
    [CommOpt]           BIT           NULL,
    [DID]               CHAR (10)     NULL,
    [TrunkNo]           VARCHAR (4)   NULL,
    CONSTRAINT [PK_tblFacilityService] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);
