
CREATE PROCEDURE [dbo].[p_update_facilityByID]
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
	@Status int,
	@AcctExeID tinyint,
	@ExeName varchar(25),
	@ExeEmail varchar(30),
	@ExeBusPhone varchar(10),
	@ExeCellPhone varchar(10),
	@AcctRepID tinyint,
	@RepName varchar(25),
	@RepEmail varchar(30),
	@RepBusPhone varchar(10),
	@RepCellPhone varchar(10)
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
		Update [tblAccountExecutive] set [AcctExeName] = @ExeName,
										 [Email] =@ExeEmail,
										 [BusPhone] =@ExeBusPhone,
										 [CellPhone] =@ExeCellPhone
			Where [AcctExeID] = @AcctExeID
										 
		Update [tblAccountRepresentative] set [AcctRepName] = @RepName,
											  [Email] = @RepEmail,
											  [BusPhone] =@RepBusPhone,
											  [CellPhone] =@RepCellPhone
			Where [AcctRepID] =@AcctRepID
	END


