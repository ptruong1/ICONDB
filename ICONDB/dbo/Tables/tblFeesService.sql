CREATE TABLE [dbo].[tblFeesService] (
    [FeeID]         SMALLINT       NOT NULL,
    [FacilityID]    INT            NOT NULL,
    [FeeDetailID]   TINYINT        NOT NULL,
    [PaymenttypeID] TINYINT        NULL,
    [FeeAmount]     NUMERIC (4, 2) NULL,
    [FeePercent]    NUMERIC (6, 4) NULL,
    [Calltype]      TINYINT        NOT NULL,
    [modifyDate]    DATETIME       NULL,
    [UserName]      VARCHAR (20)   NULL,
    CONSTRAINT [PK_tblFeesService] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [FeeDetailID] ASC, [Calltype] ASC)
);

