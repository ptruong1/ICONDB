CREATE PROCEDURE [dbo].[p_verify_AccuPinQuestion]
@PIN	varchar(12),
@facilityID	int,
@questionID	tinyint,
@digitInput	varchar(4)
AS

Declare  @DD char(2), @MM char(2),@YYYY char(4),@bookID4 char(4),  @bookID3 char(3)
SET @digitInput = rtrim(@digitInput)


if(@questionID =1 )
 begin
	SET  @DD =  @digitInput
	if(select count(*) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and substring(BirthDate,4,2) = @DD)  > 0
		return 0
	else
		return -1
 end
else if(@questionID =2 )
 begin
	SET @MM = @digitInput	
	if(select count(*) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and left(BirthDate,2) = @MM)  > 0
		 return 0
	else
		return -1
 end
else if(@questionID =3 )
 begin
	SET @YYYY = @digitInput	
	if(select count(*) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and right(BirthDate,4) = @YYYY)  > 0
		return 0
	else
		return -1
 end
else if(@questionID =4 )
 begin
	SET @bookID4 = @digitInput	
	
	if(select count(*) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and Left(BookingNo ,4) = @bookID4)  > 0
		return 0
	else
		return -1
 end
else if(@questionID =5 )
 begin
	SET @bookID3 = @digitInput	
	if(select count(*) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and right(BookingNo ,3) = @bookID3)  > 0
		return 0
	else
		return -1
 end
