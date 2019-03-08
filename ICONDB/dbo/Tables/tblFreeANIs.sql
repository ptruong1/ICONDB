CREATE TABLE [dbo].[tblFreeANIs] (
    [ANI]        CHAR (10)     NOT NULL,
    [FacilityID] INT           NOT NULL,
    [Freetype]   TINYINT       NULL,
    [InputDate]  SMALLDATETIME CONSTRAINT [DF_tblFreeANIs_InputDate] DEFAULT (getdate()) NULL,
    [Calls]      TINYINT       NULL,
    [LimitTime]  SMALLINT      NULL,
    CONSTRAINT [PK_tblFreeANIs] PRIMARY KEY CLUSTERED ([ANI] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_facility_ANI]
    ON [dbo].[tblFreeANIs]([ANI] ASC, [FacilityID] ASC);

