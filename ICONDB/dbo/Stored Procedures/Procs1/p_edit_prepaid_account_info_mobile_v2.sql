

CREATE PROCEDURE [dbo].[p_edit_prepaid_account_info_mobile_v2]
@AccountNo varchar(18),
@FirstName	varchar(25),
@LastName	varchar(25),
@Address	varchar(100),
@City		varchar(30),
@stateName	varchar(50),
@CountryName varchar(50),
@Email		varchar(40),
@ZipCode varchar(10),
@Password varchar(20)
AS
Begin
	declare @stateID varchar(50), @CountryID varchar(50)
	select @stateID=StateID from tblStates where StateName = @stateName
	select @CountryID = CountryID from tblCountryCode where CountryName=@CountryName

	update tblPrepaid SET
	FirstName = @FirstName	,
	LastName =@LastName,
	Address = @address,
	city = @city,
	StateID= @stateID,
	ZipCode=@ZipCode,
	CountryID = @CountryID
	WHERE  PhoneNo =@AccountNo;

	update tblVisitors Set
	Email = @Email
	WHERE  EndUserID =@AccountNo;

	IF @Password <> ''
	BEGIN
		UPDATE [tblEndusers] SET [Email] = @Email, [Password] = @Password WHERE UserName= @AccountNo;
		RETURN;
	END
	ELSE
	BEGIN
		Update tblEndusers set Email = @Email where UserName= @AccountNo;
		RETURN;
	END
End
