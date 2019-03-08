
CREATE PROCEDURE [dbo].[p_process_inmate_data_with_autoPIN]
@InmateID	varchar(12),
@bookingID	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@status		tinyint,
@facilityFolder	varchar(20),
@DOB		varchar(12),
@sex		varchar(1)


AS

declare 	 @facilityId int, @i int, @PIN  varchar(12) , @digit tinyint; 
	set @facilityId =1;

	set @PIN = ltrim(rtrim(@PIN));
	set @firstName	 = ltrim(@firstName);
	SET @lastName = ltrim(@lastName);
	SET @firstName = replace(@firstName,'"','');
	SET @lastName = replace(@lastName,'"','');

	select @facilityId = FacilityID from tblFacilityOption with(nolock)  where FTPfolderName = @facilityFolder;

	If (select count(*) from  tblInmate with(nolock)  where FacilityID =   @facilityID and InmateID= @InmateID) =  0
 	  Begin
		exec p_create_new_PIN1  5,   @PIN  OUTPUT;
		set @i  = 1;
		while @i = 1
		 Begin
			select  @i = count(*) from tblInmate where PIN = @PIN  and  FacilityID =  @FacilityId;
			If  (@i > 0 ) 
			 Begin
				exec p_create_new_PIN1  5,   @PIN  OUTPUT;
				SET @i = 1;
			 end
		 end

		INSERT tblInmate(InmateID   ,    LastName       ,     FirstName ,MidName  ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate , DOB, SEX   )
			Values( @InmateID,@lastName, @FirstName,@MidName,@status, 0,0,0, @facilityID,  @PIN,getdate(), @DOB,@Sex);

	  End
	else
	 Begin
		UPDATE tblInmate SET  status = @status , modifyDate = getdate()  where  inmateID = @InmateID and FacilityID = @facilityID;
	 End

if (@facilityID in ( 346,362,520 ))
	insert tblTempInmateInsert(PIN   ,       FacilityID)  values( @PIN, @facilityID);
