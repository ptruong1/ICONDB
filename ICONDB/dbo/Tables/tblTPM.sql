CREATE TABLE [dbo].[tblTPM] (
    [NPA]             NVARCHAR (3)  NULL,
    [NXX]             NVARCHAR (3)  NULL,
    [BlockID]         NVARCHAR (1)  NULL,
    [filler1]         NVARCHAR (1)  NULL,
    [Range]           NVARCHAR (8)  NULL,
    [NXXTYPE]         NVARCHAR (2)  NULL,
    [filler2]         NVARCHAR (1)  NULL,
    [Effdate_LastChg] SMALLDATETIME NULL,
    [Chg Code]        NVARCHAR (1)  NULL,
    [filler3]         NVARCHAR (1)  NULL,
    [OCN]             NVARCHAR (4)  NULL,
    [AOCN]            NVARCHAR (4)  NULL,
    [Co Code]         NVARCHAR (2)  NULL,
    [Co Type]         NVARCHAR (1)  NULL,
    [Bill to Rao]     NVARCHAR (3)  NULL,
    [Send to Rao]     NVARCHAR (3)  NULL,
    [filler4]         NVARCHAR (1)  NULL,
    [Major V]         NVARCHAR (5)  NULL,
    [Major H]         NVARCHAR (5)  NULL,
    [LATA]            NVARCHAR (3)  NULL,
    [LATA Sub]        NVARCHAR (2)  NULL,
    [RC Name]         NVARCHAR (10) NULL,
    [RC Type]         NVARCHAR (1)  NULL,
    [Place Name]      NVARCHAR (10) NULL,
    [State]           NVARCHAR (2)  NULL,
    [filler5]         NVARCHAR (1)  NULL,
    [TZONE]           NVARCHAR (1)  NULL,
    [D SAVE IND]      NVARCHAR (1)  NULL,
    [PORT IND]        NVARCHAR (1)  NULL,
    [TBP IND]         NVARCHAR (1)  NULL,
    [IDDD]            NVARCHAR (1)  NULL,
    [DIND]            NVARCHAR (1)  NULL,
    [Oth Line RS]     NVARCHAR (2)  NULL,
    [Point ID]        NVARCHAR (1)  NULL,
    [Eff Date Assign] SMALLDATETIME NULL,
    [filler6]         NVARCHAR (11) NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_npa]
    ON [dbo].[tblTPM]([NPA] ASC, [NXX] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_city]
    ON [dbo].[tblTPM]([Place Name] ASC, [State] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_pointID]
    ON [dbo].[tblTPM]([Point ID] ASC);

