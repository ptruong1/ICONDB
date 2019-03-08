CREATE TABLE [dbo].[tblTimeCall] (
    [InmateID]   BIGINT        NOT NULL,
    [days]       INT           NOT NULL,
    [hours]      BIGINT        NULL,
    [inputdate]  SMALLDATETIME NULL,
    [modifydate] SMALLDATETIME NULL,
    [username]   VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblTimeCall] PRIMARY KEY CLUSTERED ([InmateID] ASC, [days] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_InmateID]
    ON [dbo].[tblTimeCall]([InmateID] ASC);

