﻿CREATE TABLE [dbo].[LATAST] (
    [ST]   NVARCHAR (2) NOT NULL,
    [LATA] NVARCHAR (3) NOT NULL,
    [CNT]  SMALLINT     NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_state]
    ON [dbo].[LATAST]([ST] ASC);

