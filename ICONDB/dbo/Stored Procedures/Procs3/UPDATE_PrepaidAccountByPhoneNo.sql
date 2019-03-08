


CREATE PROCEDURE [dbo].[UPDATE_PrepaidAccountByPhoneNo]
(
	@PhoneNo char(10),
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
	@Balance numeric(7, 2),
	@Username varchar(20)
)
AS
SET NOCOUNT OFF;
Declare  @LastBalance numeric(7, 2)
select  @LastBalance =  [Balance] from   [tblPrepaid]  with(nolock)  WHERE ([PhoneNo] = @PhoneNo) 
UPDATE [tblPrepaid] SET [status] = @Status, 
			    [PaymentTypeID] = @PaymentTypeID, 
			    [RelationshipID] = @RelationshipID,
			     [FirstName] = @FirstName,
			    [LastName] = @LastName,
			      [MI] = @MI, [Address] = @Address,
			 [City] = @City, [State] = @State,
			 [ZipCode] = @ZipCode, 
			[Balance] = @Balance,
			 [Username] = @Username,
			 [ModifyDate] = getdate() 
			WHERE ([PhoneNo] = @PhoneNo)

INSERT  tblAdjustment( AccountNo,LastBalance, AdjAmount ,  AdjustDate  ,  UserName )
values(  @PhoneNo ,    @LastBalance ,  @Balance -  @LastBalance ,   getdate(),  @Username)

