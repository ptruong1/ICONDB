CREATE TABLE [dbo].[tblFees] (
    [FeeID]         SMALLINT       NOT NULL,
    [FacilityID]    INT            NULL,
    [FeeDetailID]   TINYINT        NULL,
    [PaymenttypeID] TINYINT        NULL,
    [FeeAmount]     NUMERIC (4, 2) NULL,
    [FeePercent]    NUMERIC (6, 4) NULL,
    [modifyDate]    DATETIME       CONSTRAINT [DF_tblFees_modifyDate] DEFAULT (getdate()) NULL,
    [UserName]      VARCHAR (20)   NULL,
    [FeeAmountAuto] NUMERIC (4, 2) NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_Fac_Feedetail]
    ON [dbo].[tblFees]([FacilityID] ASC, [FeeDetailID] ASC);

