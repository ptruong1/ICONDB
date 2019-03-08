CREATE TABLE [dbo].[tblBadDebt] (
    [FacilityID] INT            NOT NULL,
    [AgentID]    INT            NOT NULL,
    [BillType]   CHAR (2)       NOT NULL,
    [Calltype]   CHAR (2)       NOT NULL,
    [Rate]       NUMERIC (6, 4) NULL,
    [UserName]   VARCHAR (25)   NULL,
    [InputDate]  SMALLDATETIME  CONSTRAINT [DF_tblBabDebt_InputDate] DEFAULT (getdate()) NULL,
    [ModifyDate] SMALLDATETIME  NULL,
    CONSTRAINT [PK_tblBabDebt] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [AgentID] ASC, [BillType] ASC, [Calltype] ASC)
);

