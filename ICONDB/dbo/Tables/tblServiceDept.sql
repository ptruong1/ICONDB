CREATE TABLE [dbo].[tblServiceDept] (
    [DeptID]     TINYINT       NOT NULL,
    [Department] VARCHAR (30)  NULL,
    [Emails]     VARCHAR (300) NULL,
    CONSTRAINT [PK_tblServiceDept] PRIMARY KEY CLUSTERED ([DeptID] ASC)
);

