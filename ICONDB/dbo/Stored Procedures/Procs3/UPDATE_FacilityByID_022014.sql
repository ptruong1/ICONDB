
CREATE PROCEDURE [dbo].[UPDATE_FacilityByID_022014]
(
	@FacilityID int,
	@Location varchar(50),
	@Address varchar(50),
	@City varchar(20),
	@State char(2),
	@Zipcode varchar(10),
	@Phone char(10),
	@ContactName varchar(50),
	@ContactPhone varchar(10),
	@ContactEmail varchar(30),
	@English bit,
	@Spanish bit,
	@French bit,
	@DayTimeRestrict bit,
	@UserName varchar(20),
	@MaxCallTime smallint,
	@DebitOpt bit,
	@PINRequired bit,
	@CollectWithCC bit,
	@timeZone smallint,
	@Status int
)
AS
	
SET NOCOUNT OFF;
IF @Phone in (SELECT Phone FROM tblFacility WHERE FacilityID <> @FacilityID)
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		UPDATE [tblFacility] SET [Location] = @Location, 
						[Address] = @Address, 
						[City] = @City, [State] = @State, 
						[Zipcode] = @Zipcode, [Phone] = @Phone, 
						[ContactName] = @ContactName, [ContactPhone] = @ContactPhone, 
						[ContactEmail] = @ContactEmail,  
						[English] = @English, 
						[Spanish] = @Spanish, [French] = @French, 
						[DayTimeRestrict] = @DayTimeRestrict, [UserName] = @UserName,
						[modifyDate] = getdate(), [MaxCallTime] = @MaxCallTime, 
						[DebitOpt] = @DebitOpt, 
						[PINRequired] = @PINRequired,
						[CollectWithCC] = @CollectWithCC,
						[timeZone] = @timeZone,
						[status] = @Status
						
						 
	WHERE ([FacilityID] = @FacilityID);
	END


