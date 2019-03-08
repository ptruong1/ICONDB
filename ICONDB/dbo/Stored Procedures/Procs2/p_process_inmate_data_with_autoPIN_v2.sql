
CREATE PROCEDURE [dbo].[p_process_inmate_data_with_autoPIN_v2]
@InmateID	varchar(12),
@bookingID	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@status		tinyint,
@facilityID	int,
@DOB varchar(12),
@SEX  varchar(1),
@PIN  varchar(12) OUTPUT
AS

declare 	 @i int,  @digit tinyint, @PINtype tinyint, @IniFreeCall tinyint;
	SET  @digit =5;
	set @firstName	 = ltrim(@firstName);
	SET @lastName = ltrim(@lastName);
	SET @firstName = replace(@firstName,'"','');
	SET @lastName = replace(@lastName,'"','');
	SET @PINtype =0;
	SET @PIN ='';
	SET @IniFreeCall =0;

	Select   @digit = PINLen,  @PINtype = isnull(PINType,0),@IniFreeCall=isnull(IniFreeCall,0)    from tblFacilityPINconfig with(nolock) where facilityID = @facilityID;
	
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
		INSERT tblInmate(InmateID   ,    LastName       ,     FirstName ,MidName  ,  [Status], DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate,modifyDate,DOB,SEX, FreeCallRemain )
			Values( @InmateID,@lastName, @FirstName,@MidName,@status, 0,0,0, @facilityID,  @PIN,getdate(),getdate(), @DOB,@SEX,@IniFreeCall);

	  End
	else
	 Begin
		SELECT @PIN  = PIN From tblInmate with(nolock)  where FacilityID =   @facilityID and InmateID= @InmateID;
		UPDATE tblInmate SET  status = @status , modifyDate = getdate(),DOB= @DOB, SEX =@SEX  where  inmateID = @InmateID and FacilityID = @facilityID;
	 End

