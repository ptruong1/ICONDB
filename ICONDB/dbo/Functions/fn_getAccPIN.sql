-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_getAccPIN]
(
	@facilityID int,
	@InmateID varchar(12),
	@QuestionID tinyint
)
RETURNS  varchar(10)
AS
BEGIN
	Declare @Ans varchar(10);
	SET @Ans ='';
	if(@questionID =1)
	 begin
		select @Ans= substring(BirthDate,4,2) from tblInmateInfo with(nolock)  where  PIN = @InmateID and  facilityID = @facilityID order by BookingNo;
		if(@Ans='')
			select @Ans= substring(DOB,4,2) from tblInmate with(nolock)  where  InmateID = @InmateID and  facilityID = @facilityID ;
	 end
	else if(@questionID =2)
	 begin
		select @Ans=		left(BirthDate,2) from	tblInmateInfo with(nolock)  where  PIN = @InmateID and  facilityID = @facilityID  order by BookingNo;
		if(@Ans=	'')
			select @Ans=	left(DOB,2)from tblInmate with(nolock)  where  InmateID = @InmateID and  facilityID = @facilityID  ;
	 end
	else if (@questionID =3)
	 begin
		select @Ans= right(BirthDate,4) from tblInmateInfo with(nolock)  where  PIN =@InmateID and  facilityID = @facilityID  order by BookingNo;
		if(@Ans ='')
			select @Ans= right(DOB,4) from tblInmate with(nolock)  where  InmateID = @InmateID and  facilityID = @facilityID  ;
	 end
    else if (@questionID =4)
		select  @Ans=Left(BookingNo ,4) from tblInmateInfo with(nolock)  where  PIN = @InmateID and  facilityID = @facilityID  order by BookingNo;
	else if (@questionID =5)
		select @Ans = right(BookingNo ,3) from tblInmateInfo with(nolock)  where  PIN = @InmateID and  facilityID = @facilityID  order by BookingNo ;
	else if (@questionID =6)
		select @Ans = left(SSN ,3) from tblInmateInfo with(nolock)  where  PIN = @InmateID and  facilityID = @facilityID  order by BookingNo ;
    else if (@questionID =7)
		select @Ans = right(SSN ,4) from tblInmateInfo with(nolock)  where  PIN = @InmateID and  facilityID = @facilityID  order by BookingNo ;
    else if (@questionID =8)
		select @Ans = left(Zip ,5) from tblInmateInfo with(nolock)  where  PIN =@InmateID and  facilityID = @facilityID  order by BookingNo ;
	 else if (@questionID =9)
		select @Ans = left(Address1 ,2) from tblInmateInfo with(nolock)  where  PIN = @InmateID and  facilityID = @facilityID  order by BookingNo ;
     else if (@questionID =10)
		select @Ans = left(BookingDate ,2) from tblInmateInfo with(nolock)  where  PIN = @InmateID and  facilityID = @facilityID  order by BookingNo ;
	 else if (@questionID =11)
		select @Ans =inmateID from tblInmate with(nolock)  where  InmateID = @InmateID and  facilityID = @facilityID  and [status]=1 ;
	 else if (@questionID =12)
		--select @Ans =left(inmateID,3) from tblInmate with(nolock)  where  PIN = @PIN and  facilityID = @facilityID  and [status]=1 ;
		select @Ans =left(@InmateID,3);
	 else if (@questionID =13)
		--select @Ans =right(inmateID,4) from tblInmate with(nolock)  where  PIN = @PIN and  facilityID = @facilityID  and [status]=1 ;
		select @Ans =right(@InmateID,4);
	return  @Ans;


END
