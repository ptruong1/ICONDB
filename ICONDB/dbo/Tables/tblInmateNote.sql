CREATE TABLE [dbo].[tblInmateNote] (
    [NoteID]     INT           NOT NULL,
    [NoteTypeID] TINYINT       NOT NULL,
    [FacilityID] INT           NOT NULL,
    [InmateID]   VARCHAR (12)  NOT NULL,
    [Note]       VARCHAR (200) NULL,
    [InputDate]  DATETIME      NOT NULL,
    [UserName]   VARCHAR (25)  NULL,
    CONSTRAINT [PK_tblInmateNote_1] PRIMARY KEY CLUSTERED ([NoteID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_fa_in_user]
    ON [dbo].[tblInmateNote]([FacilityID] ASC, [InmateID] ASC, [UserName] ASC);

