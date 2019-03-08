CREATE TABLE [dbo].[tblAdminPhones] (
    [ID]         INT          IDENTITY (1, 1) NOT NULL,
    [FacilityID] INT          NOT NULL,
    [AdminNo]    VARCHAR (25) NULL,
    [Descript]   VARCHAR (50) NULL,
    CONSTRAINT [PK_tblAdminPhones] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_fac_phone]
    ON [dbo].[tblAdminPhones]([FacilityID] ASC, [AdminNo] ASC);

