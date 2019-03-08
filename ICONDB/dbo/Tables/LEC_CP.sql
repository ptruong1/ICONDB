CREATE TABLE [dbo].[LEC_CP] (
    [CAR]        NVARCHAR (4)  NULL,
    [ST]         NVARCHAR (2)  NOT NULL,
    [TELCOID]    NVARCHAR (4)  NOT NULL,
    [SER]        NVARCHAR (6)  NULL,
    [ORIGLCA]    NVARCHAR (5)  NULL,
    [CPNUM]      NVARCHAR (2)  NOT NULL,
    [SEQ]        TINYINT       NULL,
    [TELCOIDALT] NVARCHAR (4)  NULL,
    [CPNUMALT]   NVARCHAR (2)  NULL,
    [CPDEF]      NVARCHAR (80) NULL,
    [BASE]       TINYINT       NULL,
    [PREMIUM]    TINYINT       NULL,
    [ECONOMY]    TINYINT       NULL,
    [RESIDENT]   TINYINT       NULL,
    [ISDN]       TINYINT       NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_state]
    ON [dbo].[LEC_CP]([ST] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_telcoID]
    ON [dbo].[LEC_CP]([TELCOID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_cpnum]
    ON [dbo].[LEC_CP]([CPNUM] ASC);

