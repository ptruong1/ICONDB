﻿CREATE TABLE [dbo].[tblSurchargeDetail] (
    [SurchargeID]               VARCHAR (5)     NOT NULL,
    [state]                     CHAR (2)        NOT NULL,
    [PIFInterStPerMinCharge]    DECIMAL (4, 2)  NULL,
    [PIFInterStPerCallCharge]   DECIMAL (10, 4) NULL,
    [PIFInterStPerLimitCharge]  TINYINT         NULL,
    [PIFInterLaPerMinCharge]    DECIMAL (10, 4) NULL,
    [PIFInterLaPerCallCharge]   DECIMAL (10, 4) NULL,
    [PIFInterLaPerLimitCharge]  TINYINT         NULL,
    [PIFIntraLaPerMinCharge]    DECIMAL (10, 4) NULL,
    [PIFIntraLaPerCallCharge]   DECIMAL (10, 4) NULL,
    [PIFIntraLaPerLimitCharge]  TINYINT         NULL,
    [PIFIntlPerCallcharge]      DECIMAL (10, 4) NULL,
    [PIFIntlPerMinCharge]       DECIMAL (10, 4) NULL,
    [PIFIntlLimitCharge]        TINYINT         NULL,
    [NSFInterStPerCallCharge]   DECIMAL (10, 4) NULL,
    [NSFInterLaPerCallCharge]   DECIMAL (10, 4) NULL,
    [NSFIntraLaPerCallCharge]   DECIMAL (10, 4) NULL,
    [NSFIntlPerCallCharge]      DECIMAL (10, 4) NULL,
    [PSCInterStPerCallCharge]   DECIMAL (10, 4) NULL,
    [PSCInterLaPerCallCharge]   DECIMAL (10, 4) NULL,
    [PSCIntraLaPerCallCharge]   DECIMAL (10, 4) NULL,
    [PSCIntlPerCallCharge]      DECIMAL (10, 4) NULL,
    [NIFInterStPerCallCharge]   DECIMAL (10, 4) NULL,
    [NIFInterLaPerCallCharge]   DECIMAL (10, 4) NULL,
    [NIFIntraLaPerCallCharge]   DECIMAL (10, 4) NULL,
    [NIFIntlPerCallCharge]      DECIMAL (10, 4) NULL,
    [BDFInterStPerCallCharge]   DECIMAL (10, 4) NULL,
    [BDFInterLaPerCallCharge]   DECIMAL (10, 4) NULL,
    [BDFIntraLaPerCallCharge]   DECIMAL (10, 4) NULL,
    [BDFIntlPerCallCharge]      DECIMAL (10, 4) NULL,
    [A4250InterStPerCallCharge] DECIMAL (10, 4) NULL,
    [A4250InterLaPerCallCharge] DECIMAL (10, 4) NULL,
    [A4250IntraLaPerCallCharge] DECIMAL (10, 4) NULL,
    [A4250IntlPerCallCharge]    DECIMAL (10, 4) NULL,
    [Fee1InterStPerCallCharge]  DECIMAL (10, 4) NULL,
    [Fee1InterLaPerCallCharge]  DECIMAL (10, 4) NULL,
    [Fee1IntraLaPerCallCharge]  DECIMAL (10, 4) NULL,
    [Fee1IntlPerCallCharge]     DECIMAL (10, 4) NULL,
    [Fee2InterStPerCallCharge]  DECIMAL (10, 4) NULL,
    [Fee2InterLaPerCallCharge]  DECIMAL (10, 4) NULL,
    [Fee2IntraLaPerCallCharge]  DECIMAL (10, 4) NULL,
    [Fee2IntlPerCallCharge]     DECIMAL (10, 4) NULL,
    [LastUpdate]                SMALLDATETIME   NULL,
    [UserName]                  VARCHAR (15)    NULL,
    CONSTRAINT [PK_tblSurchargeDetail] PRIMARY KEY CLUSTERED ([SurchargeID] ASC, [state] ASC)
);
