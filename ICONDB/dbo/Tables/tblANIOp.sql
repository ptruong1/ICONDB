CREATE TABLE [dbo].[tblANIOp] (
    [ANI]         VARCHAR (10) NOT NULL,
    [Location]    VARCHAR (20) NULL,
    [RatePlanID]  VARCHAR (5)  NULL,
    [SurchargeID] VARCHAR (5)  NULL,
    CONSTRAINT [PK_tblANIOp] PRIMARY KEY CLUSTERED ([ANI] ASC)
);

