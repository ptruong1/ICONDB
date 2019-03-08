
CREATE PROCEDURE [dbo].[UPDATE_PrepaidAccountByPhoneNo1]
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

