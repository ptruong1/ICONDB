CREATE TABLE [dbo].[tblLocal] (
    [FacilityID] INT           NULL,
    [FrNPANXX]   CHAR (6)      NULL,
    [NPA]        CHAR (3)      NULL,
    [NXX]        CHAR (3)      NULL,
    [LATA]       NVARCHAR (3)  NULL,
    [RC Name]    NVARCHAR (50) NULL,
    [Local]      CHAR (1)      NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_facilityID]
    ON [dbo].[tblLocal]([FrNPANXX] ASC, [NPA] ASC, [NXX] ASC, [Local] ASC);

