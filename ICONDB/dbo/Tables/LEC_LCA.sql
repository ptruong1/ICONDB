CREATE TABLE [dbo].[LEC_LCA] (
    [TELNUM]      NVARCHAR (6)  NOT NULL,
    [LOW]         NVARCHAR (4)  NULL,
    [STATUS]      NVARCHAR (1)  NULL,
    [EFFDATE]     SMALLDATETIME NULL,
    [SPLITNXX]    TINYINT       NULL,
    [ILEC]        TINYINT       NULL,
    [PREMIUM]     TINYINT       NULL,
    [MAST_FLAG]   TINYINT       NULL,
    [COTYPE]      NVARCHAR (1)  NULL,
    [CLUST]       NVARCHAR (10) NULL,
    [ST]          NVARCHAR (2)  NULL,
    [TELCOID]     NVARCHAR (4)  NULL,
    [OVERALL_OCN] NVARCHAR (4)  NULL,
    [TELCO]       NVARCHAR (4)  NULL,
    [ALTTELCOID]  NVARCHAR (4)  NULL,
    [ALTCLUST]    NVARCHAR (10) NULL,
    [CITY]        NVARCHAR (30) NULL,
    [RCNAME]      NVARCHAR (10) NULL,
    [LCAPLANS]    INT           NULL,
    [RLCAPLANS]   INT           NULL,
    [CP_BUS]      NVARCHAR (2)  NULL,
    [CP_RES]      NVARCHAR (2)  NULL,
    [LATA]        NVARCHAR (5)  NULL,
    [RCV]         SMALLINT      NULL,
    [RCH]         SMALLINT      NULL,
    [DIALPATTRN]  TINYINT       NULL,
    [LCA_ALRC]    SMALLINT      NULL,
    [LCA_DENS]    SMALLINT      NULL,
    [LATITUDE]    FLOAT (53)    NULL,
    [LONGITUDE]   FLOAT (53)    NULL,
    [ZIPCODE]     NVARCHAR (10) NULL,
    [TN_LCA]      NVARCHAR (6)  NULL,
    [CLLI]        NVARCHAR (11) NULL,
    [WCV]         SMALLINT      NULL,
    [WCH]         SMALLINT      NULL,
    [ALAddBus]    FLOAT (53)    NULL,
    [ALAddRes]    FLOAT (53)    NULL,
    [ZONE]        SMALLINT      NULL,
    [ZONE0]       SMALLINT      NULL,
    [ORIG5]       NVARCHAR (5)  NULL,
    [ORIG6]       NVARCHAR (5)  NULL,
    [ORIG8]       NVARCHAR (5)  NULL,
    [ORIGSA5]     NVARCHAR (5)  NULL,
    [ORIGSA6]     NVARCHAR (5)  NULL,
    [ORIGSA8]     NVARCHAR (5)  NULL,
    [ORIGLCA]     NVARCHAR (5)  NULL,
    [IBUSPLANS]   INT           NULL,
    [IRESPLANS]   INT           NULL,
    [CP_IBUS]     NVARCHAR (2)  NULL,
    [CP_IRES]     NVARCHAR (2)  NULL,
    [NPATYPE]     TINYINT       NULL,
    [PORTABLE]    TINYINT       NULL,
    [RCV_LOCAL]   REAL          NULL,
    [RCH_LOCAL]   REAL          NULL,
    CONSTRAINT [PK_LEC_LCA] PRIMARY KEY CLUSTERED ([TELNUM] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_clust]
    ON [dbo].[LEC_LCA]([CLUST] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_state]
    ON [dbo].[LEC_LCA]([ST] ASC);

