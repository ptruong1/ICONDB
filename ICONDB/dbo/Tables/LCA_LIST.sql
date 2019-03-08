CREATE TABLE [dbo].[LCA_LIST] (
    [ORIG_CLUST] NVARCHAR (10) NOT NULL,
    [CPNUM]      NVARCHAR (2)  NOT NULL,
    [TERM_CLUST] NVARCHAR (10) NOT NULL,
    [RLRNUM]     TINYINT       NULL,
    [TERM_PREM]  TINYINT       NULL,
    [CIP]        REAL          NULL,
    [IP]         SMALLINT      NULL,
    [CPMAP]      REAL          NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_clust]
    ON [dbo].[LCA_LIST]([ORIG_CLUST] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_cpnum]
    ON [dbo].[LCA_LIST]([CPNUM] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_term_clust]
    ON [dbo].[LCA_LIST]([TERM_CLUST] ASC);

