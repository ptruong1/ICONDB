CREATE TABLE [dbo].[tblInmateSuspend] (
    [FacilityID]  INT          NOT NULL,
    [InmateID]    VARCHAR (12) NOT NULL,
    [SuspendDate] DATETIME     NOT NULL,
    [SuspendType] TINYINT      NOT NULL,
    [FromDate]    DATETIME     NULL,
    [Todate]      DATETIME     NULL,
    [SuspendBy]   VARCHAR (25) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_sus_inmate]
    ON [dbo].[tblInmateSuspend]([FacilityID] ASC, [InmateID] ASC);

