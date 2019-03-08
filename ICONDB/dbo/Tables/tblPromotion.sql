CREATE TABLE [dbo].[tblPromotion] (
    [FacilityID]      INT            NOT NULL,
    [PromoteCode]     VARCHAR (10)   NOT NULL,
    [ProductType]     TINYINT        NOT NULL,
    [StartDate]       DATE           NULL,
    [EndDate]         DATE           NULL,
    [InputDate]       DATETIME       NULL,
    [DiscountPercent] NUMERIC (4, 2) CONSTRAINT [DF_tblPromotion_DiscountPercent] DEFAULT ((0)) NOT NULL,
    [DiscountAmount]  NUMERIC (4, 2) CONSTRAINT [DF_tblPromotion_DiscountAmount] DEFAULT ((0)) NOT NULL,
    [InputBy]         VARCHAR (20)   NULL,
    [Status]          TINYINT        NULL,
    CONSTRAINT [PK_tblPromotion] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [PromoteCode] ASC, [ProductType] ASC)
);

