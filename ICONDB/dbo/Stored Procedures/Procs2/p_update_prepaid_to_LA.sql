
CREATE PROCEDURE [dbo].[p_update_prepaid_to_LA]
@DNI	varchar(16),
@facilityID	int,
@balance	numeric(6,2) ,
@firstName	varchar(30),
@lastName	varchar(30)

AS
Declare @dialPrefix char(3) ,  @TophoneNo  varchar(12) , @countryCode varchar(4) 


SET @dialPrefix = Left(@DNI,3)

If (@dialPrefix <> '011')
 Begin
	If(select count(*) from tblprepaid where phoneno = @DNI ) = 0
		Insert   tblprepaid ( phoneno, facilityID, paymentTypeID, FirstName, lastName,balance,  status, countryCode)
		Values( @DNI, @facilityID, 0, @firstName	,@lastName	, @balance	, 1,1 )
	Else
		update tblprepaid set balance = @balance where phoneno = @DNI  
	
	Return 0
 End
Else
 Begin
	
	SET @countryCode =   dbo.fn_determine_countryCode(@DNI)
	
	SET  @TophoneNo  = substring ( @DNI,4 + len (@countryCode) , len(@DNI))
	If(select count(*) from tblprepaid where phoneno = @DNI  and countryCode = @countryCode ) = 0 
		Insert   tblprepaid ( phoneno, facilityID, paymentTypeID, FirstName, lastName,balance,  status, countryCode)
		Values( @DNI, @facilityID, 0, @firstName	,@lastName	, @balance	, 1, @countryCode)
	Else	
		update tblprepaid SET balance =@balance  where phoneNo = @TophoneNo  and status =1   and countryCode = @countryCode
		
	
	Return 0
 End

