

CREATE PROCEDURE [dbo].[p_edit_prepaid_account_info_mobile]
@AccountNo varchar(18),
@FirstName	varchar(25),
@LastName	varchar(25),
@Address	varchar(100),
@City		varchar(30),
@stateID	int,
@CountryID	int,
@Email		varchar(40)
AS

	
Begin
	update tblPrepaid SET
	FirstName = @FirstName	,
	LastName =@LastName,
	Address = @address,
	city = @city,
	StateID= @stateID,
	CountryID = CountryID
	WHERE  PhoneNo =@AccountNo;

	Update tblEndusers set Email = @Email where UserName= @AccountNo;

end
