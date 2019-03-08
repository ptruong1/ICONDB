CREATE TABLE [dbo].[tblPrepaid] (
    [PhoneNo]        VARCHAR (12)   NOT NULL,
    [PaymentTypeID]  TINYINT        CONSTRAINT [DF_tblPrepaid_PaymentTypeID] DEFAULT ((0)) NULL,
    [RelationshipID] TINYINT        CONSTRAINT [DF_tblPrepaid_RelationshipID] DEFAULT ((4)) NOT NULL,
    [FirstName]      VARCHAR (25)   NULL,
    [LastName]       VARCHAR (25)   NULL,
    [MI]             CHAR (1)       NULL,
    [Address]        VARCHAR (75)   NULL,
    [City]           VARCHAR (20)   NULL,
    [State]          CHAR (2)       NULL,
    [ZipCode]        VARCHAR (10)   NULL,
    [Country]        VARCHAR (20)   CONSTRAINT [DF_tblPrepaid_Country] DEFAULT ('USA') NULL,
    [Balance]        NUMERIC (7, 2) CONSTRAINT [DF_tblPrepaid_Balance] DEFAULT ((0)) NOT NULL,
    [status]         TINYINT        NULL,
    [inputDate]      SMALLDATETIME  CONSTRAINT [DF_tblPrepaid_inputDate] DEFAULT (getdate()) NULL,
    [ModifyDate]     SMALLDATETIME  NULL,
    [UserName]       VARCHAR (20)   NULL,
    [FacilityID]     INT            NOT NULL,
    [InmateID]       VARCHAR (12)   NULL,
    [note]           VARCHAR (500)  NULL,
    [InmateName]     VARCHAR (50)   NULL,
    [EndUserID]      INT            NULL,
    [CountryCode]    VARCHAR (3)    CONSTRAINT [DF_tblPrepaid_CountryCode] DEFAULT ('1') NULL,
    [CountryID]      SMALLINT       CONSTRAINT [DF_tblPrepaid_CountryID] DEFAULT ((203)) NOT NULL,
    [StateID]        SMALLINT       CONSTRAINT [DF_tblPrepaid_StateID] DEFAULT ((5)) NOT NULL,
    [Address1]       VARCHAR (100)  NULL,
    [PhoneTypeID]    TINYINT        NULL,
    CONSTRAINT [PK_tblPrepaid] PRIMARY KEY CLUSTERED ([PhoneNo] ASC, [FacilityID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_phone_countrycode]
    ON [dbo].[tblPrepaid]([PhoneNo] ASC, [CountryCode] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_stateID_countryID]
    ON [dbo].[tblPrepaid]([CountryID] ASC, [StateID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_EnduserID]
    ON [dbo].[tblPrepaid]([FacilityID] ASC, [EndUserID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_status]
    ON [dbo].[tblPrepaid]([PhoneNo] ASC, [status] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_user_status]
    ON [dbo].[tblPrepaid]([UserName] ASC, [status] ASC);

