CREATE TABLE [dbo].[tblDebit] (
    [RecordID]        INT            NOT NULL,
    [InmateID]        VARCHAR (12)   CONSTRAINT [DF_tblDebit_InmateID] DEFAULT ('0') NULL,
    [AccountNo]       VARCHAR (12)   NOT NULL,
    [FacilityID]      INT            NULL,
    [ActiveDate]      SMALLDATETIME  NULL,
    [EndDate]         SMALLDATETIME  NULL,
    [PaymentType]     TINYINT        NULL,
    [Balance]         NUMERIC (7, 2) NULL,
    [ReservedBalance] NUMERIC (7, 2) NULL,
    [status]          TINYINT        NULL,
    [Note]            VARCHAR (50)   NULL,
    [inputdate]       SMALLDATETIME  CONSTRAINT [DF_tblDebit_inputdate] DEFAULT (getdate()) NULL,
    [modifyDate]      SMALLDATETIME  NULL,
    [UserName]        VARCHAR (20)   NULL,
    [DebitType]       TINYINT        CONSTRAINT [DF__tblDebit__DebitT__681E60A5] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblDebit] PRIMARY KEY CLUSTERED ([AccountNo] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_facilityID_Inmate]
    ON [dbo].[tblDebit]([InmateID] ASC, [FacilityID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_status]
    ON [dbo].[tblDebit]([AccountNo] ASC, [status] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_username_status]
    ON [dbo].[tblDebit]([UserName] ASC, [status] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_acct_facility]
    ON [dbo].[tblDebit]([AccountNo] ASC, [FacilityID] ASC);

