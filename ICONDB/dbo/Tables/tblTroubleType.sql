CREATE TABLE [dbo].[tblTroubleType] (
    [TroubleID]     TINYINT       NOT NULL,
    [AgentID]       INT           NOT NULL,
    [Descript]      VARCHAR (30)  NOT NULL,
    [ResponseEmail] VARCHAR (500) NULL,
    CONSTRAINT [PK_tblTrouble] PRIMARY KEY CLUSTERED ([TroubleID] ASC, [AgentID] ASC)
);

