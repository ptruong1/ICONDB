
CREATE PROCEDURE [dbo].[p_process_inmate_data_new]
@InmateID	varchar(12),
@PIN	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@status		tinyint,
@facilityFolder	varchar(20)

AS
SET NOCOUNT ON
Declare @facilityId int, @flatform int, @sendStatus tinyint, @autoPin tinyint
set @facilityId =1
SET @flatform = 2
SET @sendStatus =0
SET @autoPin =0
select @facilityId = FacilityID ,@sendStatus= isnull(inmateStatus,0),@autoPin= isnull(autoPin ,0) from tblFacilityOption with(nolock)  where FTPfolderName = @facilityFolder	

SET @InmateID = replace(@InmateID,'"','')
	SET @InmateID = RTRIM(ltrim(@InmateID));
	SET @PIN = replace(@PIN,'"','');

	set @PIN = ltrim(rtrim(@PIN));
	if(ISNUMERIC(@PIN)=0  AND LEN(@PIN)>0) 
		Return 0;
	set @firstName	 = ltrim(@firstName);
	SET @lastName = ltrim(@lastName);
	SET @firstName = replace(@firstName,'"','');
	SET @lastName = replace(@lastName,'"','');
	if (len(@PIN) =3)  SET @PIN = '0' + @PIN ;
	if (len(@PIN) =2)  SET @PIN = '00' + @PIN ;
	If(@facilityId =577) SET @InmateID =@PIN;
	if(@facilityId =570)
	 begin
		if (len(@PIN) =4)  SET @PIN = '000' + @PIN ;
		if (len(@PIN) =5)  SET @PIN = '00' + @PIN ;
		if (len(@PIN) =6)  SET @PIN = '0' + @PIN ;
		SET @InmateID =@PIN;
	 end

	
	If (((select count(*) from  tblInmate  where  PIN = @PIN and FacilityID =   @facilityID and InmateID= @InmateID) =  0)  and @PIN <>'' )
 	  Begin
		INSERT tblInmate(InmateID   ,    LastName       ,     FirstName ,MidName  ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate, modifyDate  )
			Values( @InmateID,@lastName, @FirstName,@MidName,@status, 0,0,0, @facilityID,  @PIN,getdate(),getdate());

	  End
	else
	 Begin
		if (@status=1 or @sendStatus =1)
		 begin
			UPDATE tblInmate SET  [status] = 1 , modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, ReBook=1,RebookDate=GETDATE() where [Status] >1 and inmateID = @InmateID and FacilityID = @facilityID ;
			UPDATE tblInmate SET  [status] = 1 , modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName where [Status] =1 and inmateID = @InmateID and FacilityID = @facilityID ;
		 end
		else
			UPDATE tblInmate SET  [status] = @status ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, modifyDate = getdate(),ReBook=0 ,RebookDate=null  where  inmateID = @InmateID and FacilityID = @facilityID;
	 End
	 
	 
	 if(select COUNT(*) from tblFTPfileprocess with(nolock) where FacilityID = @FacilityID) =0
		Insert tblFTPfileprocess(FacilityID,  FolderName , lastUpdate ,  FileCount)
					values(@facilityId,@facilityFolder ,GETDATE(),1);
	 else
		Update tblFTPfileprocess SET lastUpdate = GETDATE() where FacilityID = @facilityId;
