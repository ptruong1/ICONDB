CREATE TABLE [dbo].[tblPhoneCalls] (
    [ID]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [FacilityID]   INT            NOT NULL,
    [InmateID]     VARCHAR (12)   NOT NULL,
    [FromNo]       VARCHAR (10)   NOT NULL,
    [ToNo]         VARCHAR (18)   NOT NULL,
    [Billtype]     VARCHAR (2)    NOT NULL,
    [Calltype]     VARCHAR (2)    NOT NULL,
    [CallDuration] SMALLINT       NOT NULL,
    [CallRevenue]  NUMERIC (5, 2) NOT NULL,
    [recordDate]   DATETIME       NULL,
    CONSTRAINT [PK_tblPhoneCalls] PRIMARY KEY CLUSTERED ([ID] ASC)
);

