﻿

CREATE PROCEDURE [dbo].[UPDATE_SurchargeDetail]
		(@SurchargeID varchar(5)
           ,@state char(2)
           ,@PIFInterStPerMinCharge decimal(4,2)
           ,@PIFInterStPerCallCharge decimal(10,4)
           ,@PIFInterStPerLimitCharge tinyint
           ,@PIFInterLaPerMinCharge decimal(10,4)
           ,@PIFInterLaPerCallCharge decimal(10,4)
           ,@PIFInterLaPerLimitCharge tinyint
           ,@PIFIntraLaPerMinCharge decimal(10,4)
           ,@PIFIntraLaPerCallCharge decimal(10,4)
           ,@PIFIntraLaPerLimitCharge tinyint
           ,@PIFIntlPerCallcharge decimal(10,4)
           ,@PIFIntlPerMinCharge decimal(10,4)
           ,@PIFIntlLimitCharge tinyint
           ,@NSFInterStPerCallCharge decimal(10,4)
           ,@NSFInterLaPerCallCharge decimal(10,4)
           ,@NSFIntraLaPerCallCharge decimal(10,4)
           ,@NSFIntlPerCallCharge decimal(10,4)
           ,@PSCInterStPerCallCharge decimal(10,4)
           ,@PSCInterLaPerCallCharge decimal(10,4)
           ,@PSCIntraLaPerCallCharge decimal(10,4)
           ,@PSCIntlPerCallCharge decimal(10,4)
           ,@NIFInterStPerCallCharge decimal(10,4)
           ,@NIFInterLaPerCallCharge decimal(10,4)
           ,@NIFIntraLaPerCallCharge decimal(10,4)
           ,@NIFIntlPerCallCharge decimal(10,4)
           ,@BDFInterStPerCallCharge decimal(10,4)
           ,@BDFInterLaPerCallCharge decimal(10,4)
           ,@BDFIntraLaPerCallCharge decimal(10,4)
           ,@BDFIntlPerCallCharge decimal(10,4)
           ,@A4250InterStPerCallCharge decimal(10,4)
           ,@A4250InterLaPerCallCharge decimal(10,4)
           ,@A4250IntraLaPerCallCharge decimal(10,4)
           ,@A4250IntlPerCallCharge decimal(10,4)
           ,@Fee1InterStPerCallCharge decimal(10,4)
           ,@Fee1InterLaPerCallCharge decimal(10,4)
           ,@Fee1IntraLaPerCallCharge decimal(10,4)
           ,@Fee1IntlPerCallCharge decimal(10,4)
           ,@Fee2InterStPerCallCharge decimal(10,4)
           ,@Fee2InterLaPerCallCharge decimal(10,4)
           ,@Fee2IntraLaPerCallCharge decimal(10,4)
           ,@Fee2IntlPerCallCharge decimal(10,4)
           ,@LastUpdate smalldatetime
           ,@UserName varchar(15))
AS

SET NOCOUNT OFF;
UPDATE [leg_Icon].[dbo].[tblSurchargeDetail]
  
   SET [PIFInterStPerMinCharge] = @PIFInterStPerMinCharge
      ,[PIFInterStPerCallCharge] = @PIFInterStPerCallCharge
      ,[PIFInterStPerLimitCharge] = @PIFInterStPerLimitCharge
      ,[PIFInterLaPerMinCharge] = @PIFInterLaPerMinCharge
      ,[PIFInterLaPerCallCharge] = @PIFInterLaPerCallCharge
      ,[PIFInterLaPerLimitCharge] = @PIFInterLaPerLimitCharge
      ,[PIFIntraLaPerMinCharge] = @PIFIntraLaPerMinCharge
      ,[PIFIntraLaPerCallCharge] = @PIFIntraLaPerCallCharge
      ,[PIFIntraLaPerLimitCharge] = @PIFIntraLaPerLimitCharge
      ,[PIFIntlPerCallcharge] = @PIFIntlPerCallcharge
      ,[PIFIntlPerMinCharge] = @PIFIntlPerMinCharge
      ,[PIFIntlLimitCharge] = @PIFIntlLimitCharge
      ,[NSFInterStPerCallCharge] = @NSFInterStPerCallCharge
      ,[NSFInterLaPerCallCharge] = @NSFInterLaPerCallCharge
      ,[NSFIntraLaPerCallCharge] = @NSFIntraLaPerCallCharge
      ,[NSFIntlPerCallCharge] = @NSFIntlPerCallCharge
      ,[PSCInterStPerCallCharge] = @PSCInterStPerCallCharge
      ,[PSCInterLaPerCallCharge] = @PSCInterLaPerCallCharge
      ,[PSCIntraLaPerCallCharge] = @PSCIntraLaPerCallCharge
      ,[PSCIntlPerCallCharge] = @PSCIntlPerCallCharge
      ,[NIFInterStPerCallCharge] = @NIFInterStPerCallCharge
      ,[NIFInterLaPerCallCharge] = @NIFInterLaPerCallCharge
      ,[NIFIntraLaPerCallCharge] = @NIFIntraLaPerCallCharge
      ,[NIFIntlPerCallCharge] = @NIFIntlPerCallCharge
      ,[BDFInterStPerCallCharge] = @BDFInterStPerCallCharge
      ,[BDFInterLaPerCallCharge] = @BDFInterLaPerCallCharge
      ,[BDFIntraLaPerCallCharge] = @BDFIntraLaPerCallCharge
      ,[BDFIntlPerCallCharge] = @BDFIntlPerCallCharge
      ,[A4250InterStPerCallCharge] = @A4250InterStPerCallCharge
      ,[A4250InterLaPerCallCharge] = @A4250InterLaPerCallCharge
      ,[A4250IntraLaPerCallCharge] = @A4250IntraLaPerCallCharge
      ,[A4250IntlPerCallCharge] = @A4250IntlPerCallCharge
      ,[Fee1InterStPerCallCharge] = @Fee1InterStPerCallCharge
      ,[Fee1InterLaPerCallCharge] = @Fee1InterLaPerCallCharge
      ,[Fee1IntraLaPerCallCharge] = @Fee1IntraLaPerCallCharge
      ,[Fee1IntlPerCallCharge] = @Fee1IntlPerCallCharge
      ,[Fee2InterStPerCallCharge] = @Fee2InterStPerCallCharge
      ,[Fee2InterLaPerCallCharge] = @Fee2InterLaPerCallCharge
      ,[Fee2IntraLaPerCallCharge] = @Fee2IntraLaPerCallCharge
      ,[Fee2IntlPerCallCharge] = @Fee2IntlPerCallCharge
      ,[LastUpdate] = @LastUpdate
      ,[UserName] = @UserName
 WHERE  SurchargeID = @SurchargeID and State = @State

