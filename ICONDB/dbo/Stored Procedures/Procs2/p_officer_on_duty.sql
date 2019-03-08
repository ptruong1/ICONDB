-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_officer_on_duty]
@FacilityID  int,
@ANI  varchar(10),
@BadgeID varchar(12),
@RecordID bigint,
@ServerIP	varchar(17)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @Valid as tinyint ,@timezone smallint,@localtime datetime, @RecordName as varchar(18), @i int ;
	select @timeZone =isnull( timezone,0)  from tblfacility with(nolock) where facilityID =@facilityID;
    Set  @localtime = dateadd(hh, @timeZone,getdate() );
	
	EXEC @i= p_verify_officer_badge @facilityID,@ANI,@BadgeID,@localtime;
    if (@i =1) 
	 begin
		SET  @RecordName  = cast(@RecordID as varchar(12)) + '.WAV' ;
		EXEC p_insert_officer_checkIn_record 	@FacilityID ,	@ANI	 ,	@BadgeID	,	@RecordName	,	@localtime, @ServerIP
		
	 end
	 else 
	  begin
		Select 'Fail' as CheckIn, Convert (varchar(8),@localtime,112) as foderDate;
	  end
	 
END

