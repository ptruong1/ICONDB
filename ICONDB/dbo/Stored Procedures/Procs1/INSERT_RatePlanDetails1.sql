
CREATE PROCEDURE [dbo].[INSERT_RatePlanDetails1]
(
	@RateID varchar(5),
	@Mileagecode int,
	@DayCode varchar(2),
	@PointID varchar(2),
	@TYPE char(1),
	@Description nvarchar(20),
	@FirstMin decimal(4, 2),
	@AddlMin decimal(4, 2),
	@CollectCallFee decimal(4, 2),
	@CallingCardFee decimal(4, 2),
	@CreditCardFee decimal(4, 2),
	@ThirdPartyFee decimal(4, 2),
	@PerToPerFee decimal(4, 2),
	@ACPCollectCallFee decimal(4, 2),
	@ACPCallingCardFee decimal(4, 2),
	@ACPCreditCardFee decimal(4, 2),
	@ACPDebitFee decimal(4, 2),
	@MinDuration tinyint,
	@MinDurationIntl tinyint,
	@MinIncrement smallint,
	@UserName varchar(50)
	
)
AS
	SET NOCOUNT OFF;
INSERT INTO [tblRatePlanDetail] ([RateID], [Mileagecode], [DayCode], [PointID], [TYPE], [Description], [FirstMin], [AddlMin], [CollectCallFee], [CallingCardFee], [CreditCardFee], 
                        [ThirdPartyFee], [PerToPerFee], [ACPCollectCallFee], [ACPCallingCardFee], [ACPCreditCardFee], [ACPDebitFee], [MinDuration], [MinDurationIntl], [MinIncrement], [UserName], [Inputdate])
                        VALUES
                       (@RateID, @Mileagecode, @DayCode, @PointID, @TYPE, @Description, @FirstMin, @AddlMin, @CollectCallFee, @CallingCardFee, @CreditCardFee,
                       @ThirdPartyFee, @PerToPerFee, @ACPCollectCallFee, @ACPCallingCardFee, @ACPCreditCardFee, @ACPDebitFee, @MinDuration, @MinDurationIntl, @MinIncrement, @UserName, Getdate());
	
SELECT RateID, Mileagecode, DayCode, PointID, TYPE, Description, FirstMin, AddlMin, CollectCallFee, CallingCardFee, CreditCardFee, ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee,
               ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, UserName, RateDetailID, Inputdate, ModifyDate
               FROM tblRatePlanDetail 
               WHERE               (DayCode = @DayCode) AND (Mileagecode = @Mileagecode) AND (PointID = @PointID) AND (RateID = @RateID) AND (TYPE = @TYPE)

