CREATE TABLE [dbo].[tblCommRate] (
    [FacilityID]      INT            NOT NULL,
    [AgentID]         INT            NOT NULL,
    [BillType]        CHAR (2)       NOT NULL,
    [Calltype]        CHAR (2)       NOT NULL,
    [CommRate]        NUMERIC (6, 4) NULL,
    [PifPaid]         BIT            CONSTRAINT [DF_tblCommRate_PifPaid] DEFAULT (0) NULL,
    [Descript]        VARCHAR (50)   NULL,
    [username]        VARCHAR (25)   NULL,
    [inputDate]       SMALLDATETIME  CONSTRAINT [DF_tblCommRate_inputDate] DEFAULT (getdate()) NULL,
    [modifyDate]      SMALLDATETIME  NULL,
    [CommRatePerCall] NUMERIC (4, 2) DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblCommRate] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [AgentID] ASC, [BillType] ASC, [Calltype] ASC)
);

