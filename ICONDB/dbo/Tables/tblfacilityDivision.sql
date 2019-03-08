CREATE TABLE [dbo].[tblfacilityDivision] (
    [DivisionID]       INT           NOT NULL,
    [FacilityID]       INT           NOT NULL,
    [DepartmentName]   VARCHAR (50)  NULL,
    [ContactPhone1]    CHAR (10)     NOT NULL,
    [ContactPhone2]    CHAR (10)     NULL,
    [ContactFirstName] VARCHAR (20)  NULL,
    [ContactLastName]  VARCHAR (50)  NULL,
    [ContactEmail]     VARCHAR (25)  NULL,
    [PINRequired]      BIT           CONSTRAINT [DF_tblfacilityDivision_PINRequired] DEFAULT ((0)) NOT NULL,
    [DayTimeRestrict]  BIT           CONSTRAINT [DF_tblfacilityDivision_DayTimeRestrict] DEFAULT ((0)) NOT NULL,
    [userName]         VARCHAR (25)  NULL,
    [ModifyDate]       SMALLDATETIME NULL,
    [inputDate]        SMALLDATETIME CONSTRAINT [DF_tblfacilityDivision_inputDate] DEFAULT (getdate()) NULL,
    [MaxCallTime]      SMALLINT      NULL,
    [DivisonStatus]    TINYINT       CONSTRAINT [DF__tblfacili__Divis__687E5358] DEFAULT ((1)) NULL,
    [IDRequired]       BIT           NULL,
    CONSTRAINT [PK_tblfacilityDivision_1] PRIMARY KEY CLUSTERED ([DivisionID] ASC),
    CONSTRAINT [FK_tblfacilityDivision_tblfacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);


GO
CREATE NONCLUSTERED INDEX [ind_FacilityID]
    ON [dbo].[tblfacilityDivision]([FacilityID] ASC);

