
CREATE PROCEDURE [dbo].[UPDATE_RatePlanDetails]
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
	@UserName varchar(50),
	@Inputdate smalldatetime,
	@ModifyDate smalldatetime,
	@Original_RateID varchar(5),
	@Original_Mileagecode int,
	@Original_DayCode varchar(2),
	@Original_PointID varchar(2),
	@Original_TYPE char(1)
)
AS
	SET NOCOUNT OFF;
UPDATE [tblRatePlanDetail] SET [RateID] = @RateID, [Mileagecode] = @Mileagecode, [DayCode] = @DayCode, [PointID] = @PointID, [TYPE] = @TYPE, [Description] = @Description, [FirstMin] = @FirstMin, [AddlMin] = @AddlMin, [CollectCallFee] = @CollectCallFee, [CallingCardFee] = @CallingCardFee, [CreditCardFee] = @CreditCardFee, [ThirdPartyFee] = @ThirdPartyFee, [PerToPerFee] = @PerToPerFee, [ACPCollectCallFee] = @ACPCollectCallFee, [ACPCallingCardFee] = @ACPCallingCardFee, [ACPCreditCardFee] = @ACPCreditCardFee, [ACPDebitFee] = @ACPDebitFee, [MinDuration] = @MinDuration, [MinDurationIntl] = @MinDurationIntl, [MinIncrement] = @MinIncrement, [UserName] = @UserName, [Inputdate] = @Inputdate, [ModifyDate] = @ModifyDate WHERE (([RateID] = @Original_RateID) AND ([Mileagecode] = @Original_Mileagecode) AND ([DayCode] = @Original_DayCode) AND ([PointID] = @Original_PointID) AND ([TYPE] = @Original_TYPE));
	
SELECT RateID, Mileagecode, DayCode, PointID, TYPE, Description, FirstMin, AddlMin, CollectCallFee, CallingCardFee, CreditCardFee, ThirdPartyFee, PerToPerFee, ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, UserName, RateDetailID, Inputdate, ModifyDate FROM tblRatePlanDetail WHERE (DayCode = @DayCode) AND (Mileagecode = @Mileagecode) AND (PointID = @PointID) AND (RateID = @RateID) AND (TYPE = @TYPE)

