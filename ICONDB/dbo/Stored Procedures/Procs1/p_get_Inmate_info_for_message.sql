-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Inmate_info_for_message] 
	@KioskName	varchar(16),
	@facilityID	int,
	@PIN	varchar(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
   Declare   @inmateID varchar(12),@timeZone tinyint, @localTime datetime, @timePass int,@LocationID int;
   Declare	@InmateName  varchar(50), @EmailDirOpt tinyint, @VideoDirOpt tinyint,@ImageDirOpt tinyint, @TextDirOpt tinyint  ;
   set @inmateID ='';
   SET @InmateName =''; 
   set @EmailDirOpt =0; 
   SET  @VideoDirOpt =0;
   set @ImageDirOpt =0;
   set @TextDirOpt =0;
   IF(@facilityID =0 )
     select @facilityID= FacilityID, @LocationID = LocationID    FROM [leg_Icon].[dbo].tblVisitPhone  with(nolock) where  ExtID =@KioskName;

		
   
   
   select @InmateName =firstName + ' ' + LastName, @inmateID= InmateID from tblInmate with(nolock) where FacilityId =@facilityID and PIN =@PIN and [Status]=1;

   select  @EmailDirOpt = isnull(EmailDirOpt,1) ,@VideoDirOpt = isnull(VideoDirOpt,1), @ImageDirOpt = isnull(ImageDirOpt,1),@TextDirOpt = Isnull(TextDirOpt,1)  from tblFacilityMessageConfig with(nolock) where facilityID =@facilityID;
   
   -- Will add more for inmate opt
  -- if(@EmailDirOpt in (2,3))
	 --set @EmailDirOpt =1;
  -- else
  --   set @EmailDirOpt =0;
   if(@VideoDirOpt in (2,3))
	 set @VideoDirOpt =1;
   else
	   set @VideoDirOpt =0;
  -- if(@ImageDirOpt in (2,3))
	 --set @ImageDirOpt =1;  
  -- else
  --   set @ImageDirOpt =0;  
  -- if(@TextDirOpt in (2,3))
	 --set @TextDirOpt =1; 
  -- else
	 -- set @TextDirOpt =0;  
   select @inmateID as InmateID, @InmateName as InmateName, @EmailDirOpt as EmailDirOpt, @VideoDirOpt as VideoDirOpt, @ImageDirOpt as ImageDirOpt,@TextDirOpt as TextDirOpt ;
		return 0;
	
 End

