
CREATE PROCEDURE [dbo].[p_process_inmate_data_with_autoPIN1]
@InmateID	varchar(12),
@bookingID	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@status		tinyint,
@facilityID	int,
@SendStatus	tinyint
AS

declare 	 @i int, @PIN  varchar(12), @digit tinyint, @PINtype tinyint;
	SET  @digit =5;
	set @firstName	 = ltrim(@firstName);
	SET @lastName = ltrim(@lastName);
	SET @firstName = replace(@firstName,'"','');
	SET @lastName = replace(@lastName,'"','');
	SET @PINtype =0;
	
	Select   @digit = PINLen,  @PINtype = isnull(PINType,0) from tblFacilityPINconfig with(nolock) where facilityID = @facilityID;

	If (select count(*) from  tblInmate with(nolock)  where FacilityID =   @facilityID and InmateID= @InmateID ) =  0
 	  Begin
		exec p_create_new_PIN1  @digit,   @PIN  OUTPUT;
		set @i  = 1;
		while @i = 1
		 Begin
			select  @i = count(*) from tblInmate where PIN = @PIN  and  FacilityID =  @FacilityId;
			If  (@i > 0 ) 
			 Begin
				exec p_create_new_PIN1  @digit,   @PIN  OUTPUT;
				SET @i = 1;
			 end
		 end
        if(@PINtype=1)
			SET @PIN = @InmateID + @PIN;
		INSERT tblInmate(InmateID   ,    LastName       ,     FirstName ,MidName  ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate,modifyDate )
			Values( @InmateID,@lastName, @FirstName,@MidName,@status, 0,0,0, @facilityID,  @PIN,getdate(),getdate());

	  End
	else
	 Begin
		if(@lastName <>'')
			UPDATE tblInmate SET  status = @status , LastName= @lastName, FirstName = @firstName, modifyDate = getdate()  where  inmateID = @InmateID and FacilityID = @facilityID;
		else
			UPDATE tblInmate SET  status = @status ,  modifyDate = getdate()  where  inmateID = @InmateID and FacilityID = @facilityID;
	 End

