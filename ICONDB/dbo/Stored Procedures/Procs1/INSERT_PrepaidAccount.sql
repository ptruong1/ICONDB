






CREATE PROCEDURE [dbo].[INSERT_PrepaidAccount]
(
	@PhoneNo char(10),
	@PaymentTypeID tinyint,
	@RelationshipID tinyint,
	@Status tinyint,
	@FirstName varchar(25),
	@LastName varchar(25),
	@MI char(1),
	@Address varchar(75),
	@City varchar(20),
	@State char(2),
	@ZipCode varchar(10),
	@Country varchar(20),
	@Balance numeric(7, 2),
	@Username varchar(20),
	@InmateID	int,
	@InmateName varchar(50),
	@FacilityID int,
	@ccNo		varchar(18),
	@ccExp	varchar(4),
	@ccZip		varchar(5),
	@ccCVV	varchar(4),
	@ccFirstName	varchar(25),
	@ccLastName	varchar(25),
	@checkNo	int,
	@note	varchar(50)
)

AS

SET NOCOUNT OFF;
if(@PaymentTypeID is null)
	SET @PaymentTypeID =1;
IF  (SELECT count( PhoneNo) FROM tblPrepaid  with(nolock) where phoneno =@PhoneNo) >0 
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		INSERT INTO [tblPrepaid] ([FacilityID], [InmateID], [InmateName], [PhoneNo], [PaymentTypeID], [RelationshipID], [status], [FirstName], [LastName], [MI], [Address], [City], [State], [ZipCode], [Country], [Balance], [Username], [ModifyDate]) 
			VALUES (@FacilityID, @InmateID, @InmateName, @PhoneNo, @PaymentTypeID, @RelationshipID, @Status, @FirstName, @LastName, @MI, @Address, @City, @State, @ZipCode, @Country, @Balance, @Username, getdate())
		If(@Balance >0)
			INSERT INTO tblPrepaidPayments(AccountNo,  InmateID ,  FacilityID,  Amount   ,    PaymentTypeID, CheckNo  ,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate ,Note )
				        Values(@PhoneNo,  @inmateID, @FacilityID, @Balance, @PaymentTypeID, @checkno, @ccNo, @ccExp,@ccZip, @ccCVV, @ccFirstName,@ccLastName	,@userName, getdate(),@note)
		RETURN;
	END
