
CREATE PROCEDURE [dbo].[UPDATE_RatePlanDetails1]
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
UPDATE [tblRatePlanDetail] SET [Description] = @Description, [FirstMin] = @FirstMin, [AddlMin] = @AddlMin, [CollectCallFee] = @CollectCallFee, [CallingCardFee] = @CallingCardFee,
                [CreditCardFee] = @CreditCardFee, [ThirdPartyFee] = @ThirdPartyFee, [PerToPerFee] = @PerToPerFee, [ACPCollectCallFee] = @ACPCollectCallFee, [ACPCallingCardFee] = @ACPCallingCardFee,
                 [ACPCreditCardFee] = @ACPCreditCardFee, [ACPDebitFee] = @ACPDebitFee, [MinDuration] = @MinDuration, [MinDurationIntl] = @MinDurationIntl, [MinIncrement] = @MinIncrement, 
               [UserName] = @UserName, [Inputdate] = getdate(), [ModifyDate] = getdate()
               WHERE (([RateID] = @RateID) AND ([Mileagecode] = @Mileagecode) AND ([DayCode] = @DayCode) AND ([PointID] = @PointID) AND ([TYPE] = @TYPE));
	
SELECT RateID, Mileagecode, DayCode, PointID, TYPE, Description, FirstMin, AddlMin, CollectCallFee, CallingCardFee, CreditCardFee, ThirdPartyFee, PerToPerFee, ACPCollectCallFee, 
              ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, UserName, RateDetailID, Inputdate, ModifyDate
              FROM tblRatePlanDetail 
              WHERE (DayCode = @DayCode) AND (Mileagecode = @Mileagecode) AND (PointID = @PointID) AND (RateID = @RateID) AND (TYPE = @TYPE)

