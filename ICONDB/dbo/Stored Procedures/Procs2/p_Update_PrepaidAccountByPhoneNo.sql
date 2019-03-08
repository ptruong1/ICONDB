
CREATE PROCEDURE [dbo].[p_Update_PrepaidAccountByPhoneNo]
(
	@PhoneNo char(12),
	@Status tinyint,
	@PaymentTypeID tinyint,
	@RelationshipID tinyint,
	@FirstName varchar(25),
	@LastName varchar(25),
	@MI char(1),
	@Address varchar(75),
	@City varchar(20),
	@State char(2),
	@ZipCode varchar(10),
	@Username varchar(20)
)
AS
SET NOCOUNT OFF;

UPDATE [tblPrepaid] SET [status] = @Status, 
			    [PaymentTypeID] = @PaymentTypeID, 
			    [RelationshipID] = @RelationshipID,
			    [FirstName] = @FirstName,
			    [LastName] = @LastName,
			    [MI] = @MI, [Address] = @Address,
			    [City] = @City, [State] = @State,
			    [ZipCode] = @ZipCode, 
			    [Username] = @Username,
			    [ModifyDate] = getdate() 
			WHERE ([PhoneNo] = @PhoneNo)

update [tblVisitors] set VFirstName =@FirstName,
						 VLastName =@LastName,
						 VMi =@MI,
						 Address=@Address,
						 City=@City,
						 Zipcode=@ZipCode,
						 ModifyDate=GETDATE()
			where EndUserID=@PhoneNo



