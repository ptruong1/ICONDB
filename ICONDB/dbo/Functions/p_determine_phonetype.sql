-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION p_determine_phonetype 
(
	@PhoneNo varchar(10)
)
RETURNS tinyint
AS
BEGIN
	Declare @PhoneTypeID tinyint, @replycode varchar(3);
	SET  @PhoneTypeID =3;
	Select @PhoneTypeID= isnull(phonetypeID,3) from tblprepaid with(nolock) where phoneno = @PhoneNo;
	if( @PhoneTypeID =3)
	 begin
		select @replycode = replycode from [TecoData].dbo.tblEndUser with(nolock) where billToNo = @PhoneNo;
		if(@replycode='399')
			SET  @PhoneTypeID =2;
		else if (@replycode in ('050','061','263','898','051'))
			SET  @PhoneTypeID =1;
	 End
	 Return @PhoneTypeID;
END
