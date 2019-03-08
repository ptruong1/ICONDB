
CREATE PROCEDURE [dbo].[SELECT_SurchargeDetails]
(
	@SurchargeID varchar(5)
)

AS
	SET NOCOUNT ON;
--SELECT [SurchargeID], [state], [PIFInterStPerMinCharge], [PIFInterStPerCallCharge], [PIFInterStPerLimitCharge], [PIFInterLaPerMinCharge], [PIFInterLaPerCallCharge],
--	 [PIFInterLaPerLimitCharge], [PIFIntraLaPerMinCharge], [PIFIntraLaPerCallCharge], [PIFIntraLaPerLimitCharge], [PIFIntlPerCallcharge], [PIFIntlPerMinCharge],
--	 [PIFIntlLimitCharge], [NSFInterStPerCallCharge], [PSCInterLaPerCallCharge], [NSFInterLaPerCallCharge], [PSCIntlPerCallCharge], [BDFInterLaPerCallCharge], 
--	[NIFIntraLaPerCallCharge], [NIFIntlPerCallCharge], [BDFInterStPerCallCharge], [BDFIntraLaPerCallCharge], [NSFIntraLaPerCallCharge], [NSFIntlPerCallCharge],
--	 [PSCInterStPerCallCharge], [PSCIntraLaPerCallCharge], [NIFInterStPerCallCharge], [NIFInterLaPerCallCharge], [BDFIntlPerCallCharge], [Fee1InterLaPerCallCharge], 
--	 [Fee2IntraLaPerCallCharge], [Fee2InterLaPerCallCharge], [A4250InterStPerCallCharge], [Fee2IntlPerCallCharge], [A4250InterLaPerCallCharge],
--	 [Fee1InterStPerCallCharge], [Fee1IntraLaPerCallCharge], [Fee1IntlPerCallCharge], [Fee2InterStPerCallCharge], [A4250IntraLaPerCallCharge], [A4250IntlPerCallCharge],
--	[UserName], [LastUpdate]
--	 FROM [tblSurchargeDetail]
--	 WHERE ([SurchargeID] = @SurchargeID)
SELECT [SurchargeID]
      ,[state]
      ,isnull(PIFInterStPerMinCharge,0) as PIFInterStPerMinCharge
      ,isnull(PIFInterStPerCallCharge,0) as PIFInterStPerCallCharge
      ,isnull(PIFInterStPerLimitCharge,0) as PIFInterStPerLimitCharge
      ,isnull(PIFInterLaPerMinCharge,0) as PIFInterLaPerMinCharge
      ,isnull(PIFInterLaPerCallCharge,0) as PIFInterLaPerCallCharge
      ,isnull(PIFInterLaPerLimitCharge,0) as PIFInterLaPerLimitCharge
      ,isnull(PIFIntraLaPerMinCharge,0) as PIFIntraLaPerMinCharge
      ,isnull(PIFIntraLaPerCallCharge,0) as PIFIntraLaPerCallCharge
      ,isnull(PIFIntraLaPerLimitCharge,0) as PIFIntraLaPerLimitCharge
      ,isnull(PIFIntlPerCallcharge,0) as PIFIntlPerCallcharge
      ,isnull(PIFIntlPerMinCharge,0) as PIFIntlPerMinCharge
      ,isnull(PIFIntlLimitCharge,0) as PIFIntlLimitCharge
      ,isnull(NSFInterStPerCallCharge,0) as NSFInterStPerCallCharge
      ,isnull(NSFInterLaPerCallCharge,0) as NSFInterLaPerCallCharge
      ,isnull(NSFIntraLaPerCallCharge,0) as NSFIntraLaPerCallCharge
      ,isnull(NSFIntlPerCallCharge,0) as NSFIntlPerCallCharge
      ,isnull(PSCInterStPerCallCharge,0) as PSCInterStPerCallCharge
      ,isnull(PSCInterLaPerCallCharge,0) as PSCInterLaPerCallCharge
      ,isnull(PSCIntraLaPerCallCharge,0) as PSCIntraLaPerCallCharge
      ,isnull(PSCIntlPerCallCharge,0) as PSCIntlPerCallCharge
      ,isnull(NIFInterStPerCallCharge,0) as NIFInterStPerCallCharge
      ,isnull(NIFInterLaPerCallCharge,0) as NIFInterLaPerCallCharge
      ,isnull(NIFIntraLaPerCallCharge,0) as NIFIntraLaPerCallCharge
      ,isnull(NIFIntlPerCallCharge,0) as NIFIntlPerCallCharge
      ,isnull(BDFInterStPerCallCharge,0) as BDFInterStPerCallCharge
      ,isnull(BDFInterLaPerCallCharge,0) as BDFInterLaPerCallCharge
      ,isnull(BDFIntraLaPerCallCharge,0) as BDFIntraLaPerCallCharge
      ,isnull(BDFIntlPerCallCharge,0) as BDFIntlPerCallCharge
      ,isnull(A4250InterStPerCallCharge,0) as A4250InterStPerCallCharge
      ,isnull(A4250InterLaPerCallCharge,0) as A4250InterLaPerCallCharge
      ,isnull(A4250IntraLaPerCallCharge,0) as A4250IntraLaPerCallCharge
      ,isnull(A4250IntlPerCallCharge,0) as A4250IntlPerCallCharge
      ,isnull(Fee1InterStPerCallCharge,0) as Fee1InterStPerCallCharge
      ,isnull(Fee1InterLaPerCallCharge,0) as Fee1InterLaPerCallCharge
      ,isnull(Fee1IntraLaPerCallCharge,0) as Fee1IntraLaPerCallCharge
      ,isnull(Fee1IntlPerCallCharge,0) as Fee1IntlPerCallCharge
      ,isnull(Fee2InterStPerCallCharge,0) as Fee2InterStPerCallCharge
      ,isnull(Fee2InterLaPerCallCharge,0) as Fee2InterLaPerCallCharge
      ,isnull(Fee2IntraLaPerCallCharge,0) as Fee2IntraLaPerCallCharge
      ,isnull(Fee2IntlPerCallCharge,0) as Fee2IntlPerCallCharge
      ,[LastUpdate]
      ,[UserName]
  FROM [leg_Icon].[dbo].[tblSurchargeDetail]
 	 WHERE ([SurchargeID] = @SurchargeID)
