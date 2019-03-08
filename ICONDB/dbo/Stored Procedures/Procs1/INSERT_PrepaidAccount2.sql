
CREATE PROCEDURE [dbo].[INSERT_PrepaidAccount2]
(
	@PhoneNo char(12),
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
	@InmateID	varchar(12),
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
declare  @RecordID int;
if(@PaymentTypeID is null)
	SET @PaymentTypeID =1;
SET NOCOUNT OFF;
IF  (SELECT count( PhoneNo) FROM tblPrepaid  with(nolock) where phoneno =@PhoneNo) >0
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		SET @RecordID =(SELECT top 1 enduserID from tblEndUsers  order by EndUserID desc)
		SET @RecordID = @RecordID +1
		Insert  Into tblEndUsers ( enduserID, UserName , Password, Email )
		  
		Values (@RecordID,@PhoneNo, left(@FirstName,1) + right(@PhoneNo,7) ,'user@noemail.com')

		INSERT INTO [tblPrepaid] ([FacilityID], [InmateID], [InmateName], [PhoneNo], [PaymentTypeID], [RelationshipID], [status], [FirstName], [LastName], [MI], [Address], [City], [State], [ZipCode], [Country], [Balance], [Username], [ModifyDate]) 
			VALUES (@FacilityID, @InmateID, @InmateName, @PhoneNo, @PaymentTypeID, @RelationshipID, @Status, @FirstName, @LastName, @MI, @Address, @City, @State, @ZipCode, @Country, 0, @Username, getdate());
		If(@Balance >0)
		Declare  @return_value int, @nextID int, @ID int, @tblFacility nvarchar(32) ;
        EXEC   @return_value = p_create_nextID 'tblPrepaidPayments', @nextID   OUTPUT;
        set           @ID = @nextID ; 
			INSERT INTO tblPrepaidPayments(PaymentID, AccountNo,  InmateID ,  FacilityID,  Amount   ,    PaymentTypeID, CheckNo  ,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate ,Note )
				        Values(@ID, @PhoneNo,  @inmateID, @FacilityID, @Balance, @PaymentTypeID, @checkno, @ccNo, @ccExp,@ccZip, @ccCVV, @ccFirstName,@ccLastName	,@userName, getdate(),@note);
		RETURN;
	
		--INSERT INTO [tblPrepaid] ([FacilityID], [InmateID], [InmateName], [PhoneNo], [PaymentTypeID], [RelationshipID], [status], [FirstName], [LastName], [MI], [Address], [City], [State], [ZipCode], [Country], [Balance], [Username], [ModifyDate] ,EndUserID) 
		--	VALUES (@FacilityID, @InmateID, @InmateName, @PhoneNo, @PaymentTypeID, @RelationshipID, @Status, @FirstName, @LastName, @MI, @Address, @City, @State, @ZipCode, @Country, 0.00, @Username, getdate(),  @RecordID)
		
	END

