CREATE TABLE [dbo].[tblRatePlan] (
    [RateID]    VARCHAR (5)   NOT NULL,
    [Descript]  VARCHAR (50)  NULL,
    [userName]  VARCHAR (25)  NULL,
    [InputDate] SMALLDATETIME NULL,
    [RecordID]  INT           NOT NULL,
    CONSTRAINT [PK_tblRatePlan_1] PRIMARY KEY CLUSTERED ([RateID] ASC)
);

