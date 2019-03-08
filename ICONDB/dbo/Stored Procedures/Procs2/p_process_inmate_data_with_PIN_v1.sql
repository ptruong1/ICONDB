
CREATE PROCEDURE [dbo].[p_process_inmate_data_with_PIN_v1]
@InmateID	varchar(12),
@PIN	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@DOB as varchar(10),
@status		tinyint,
@facilityID	int,
@sendStatus	tinyint,
@AtLocation	varchar(20),
@ReleaseDate varchar(12),
@AccountBalance numeric(10,2)


AS
	Declare @digit tinyint,  @PINtype tinyint, @IniFreeCall tinyint, @InmateStatus tinyint;
	SET 	@digit =4;
	SET  @PINtype =0;
	SET @IniFreeCall =0;
	SET  @InmateStatus =0;
	Select   @digit = PINLen,  @PINtype = isnull(PINType,0),@IniFreeCall=isnull(IniFreeCall,0)    from tblFacilityPINconfig with(nolock) where facilityID = @facilityID;

	SET @InmateID = replace(@InmateID,'"','');
	SET @InmateID = RTRIM(ltrim(@InmateID));
	SET @PIN = replace(@PIN,'"','');

	set @PIN = ltrim(rtrim(@PIN));
	if(ISNUMERIC(@PIN)=0  AND LEN(@PIN)>0) 
		Return 0;
	set @firstName	 = ltrim(@firstName);
	SET @lastName = ltrim(@lastName);
	SET @firstName = replace(@firstName,'"','');
	SET @lastName = replace(@lastName,'"','');
	SET @ReleaseDate = ISNULL(@ReleaseDate,'');
	SET @ReleaseDate = LTRIM(rtrim(@ReleaseDate));
	SET  @MidName = replace(@MidName,'"','');
	
	if (len(@PIN) =3)  SET @PIN = '0' + @PIN ;
	if (len(@PIN) =2)  SET @PIN = '00' + @PIN ;
	If(@PIN <>'' and @PIN <>'0' )
		Select @InmateStatus = [status] from  tblInmate  where  PIN = @PIN and FacilityID =   @facilityID and InmateID= @InmateID;
		
	If (@InmateStatus =0 and @PIN <>'' and @PIN <>'0')
 	  Begin
		INSERT tblInmate(InmateID   ,    LastName       ,     FirstName ,MidName  , DOB,  [Status], DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate, modifyDate, FreeCallRemain, SEX  )
			Values( @InmateID,@lastName, @FirstName,@MidName,@DOB, 1, 0,0,0, @facilityID,  @PIN,getdate(),getdate(), @IniFreeCall, 'U') ;

	  End
	else
	 Begin
		if (@status=1)
		 begin
			  If(@InmateStatus > 1)
					UPDATE tblInmate SET  [status] = @status ,  modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, ReBook=1,RebookDate=GETDATE() where  FacilityID = @facilityID and InmateID= @InmateID and PIN = @PIN ;
			  else
					UPDATE tblInmate SET  modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName where  FacilityID = @facilityID and InmateID= @InmateID and PIN = @PIN;
			 
			
		 end
		else
			UPDATE tblInmate SET  [status] = @status , PIN= @PIN,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, modifyDate = getdate(),ReBook=0 ,RebookDate=null  where  inmateID = @InmateID and FacilityID = @facilityID;
	 End

	 
	
