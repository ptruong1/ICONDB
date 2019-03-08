
CREATE PROCEDURE [dbo].[p_process_inmate_data_with_PIN]
@InmateID	varchar(12),
@PIN	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@status		tinyint,
@facilityID	int,
@sendStatus	tinyint,
@AtLocation	varchar(20),
@ReleaseDate varchar(12),
@AccountBalance numeric(10,2)


AS
	Declare @digit tinyint,  @PINtype tinyint, @IniFreeCall tinyint;
	SET 	@digit =4;
	SET  @PINtype =0;
	SET @IniFreeCall =0;
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
	
	if(@facilityID =577 or @AtLocation <> '')
	 Begin		
		Declare @fullName varchar(50)
		SET @fullName =@firstName + ' ' +   @lastName ;
		
		EXEC    [p_inmate_info_v2]
				@facilityID ,
				@PIN   ,  
				@InmateID  ,    
				@fullName,
				'',  -- @BirthDate 
				@InmateID  ,

				'',  --@ArrestDate  ,
				'',  --@ArrestTime  ,
				'',  --@AgencyCaseNo  ,
				'',  --@Agency        ,
				'',  --@BookingDate ,
				'',  --@BookingTime  ,
				@AtLocation        ,

				'',  --@ChargeCode    ,
				'',  --@ChargeDescript   ,
				'',  --@Level   ,
				'',  --@CaseNo , 
				'',  --@MODIFIER  ,
				'',  --@BAILOUT	,
				0,  --@BAILAMOUNT  ,  
				'',  --@COURT   	,
				'',  --@SentenceDate ,
			    @ReleaseDate ,
				'',  --@SentenceDays ,

				'',  --@HoldType           ,
				'',  --@HoldStartDate   ,
				'',  --@RemoveDate,

				0,  --@VisitsRemaining	,
				@AccountBalance,
				'',  --@CourtInfo		,
				'',  --@Judge		,
				''  --@ApperanceDate	, 
				;
				if(@facilityID =577) 
					SET @InmateID =@pin
	 end	 
	
	--if( (@ReleaseDate <>'') and  (CAST (@ReleaseDate as DATE)  < GETDATE()) )
		--SET @status =2
		
	If (((select count(*) from  tblInmate  where FacilityID =   @facilityID and InmateID= @InmateID) =  0)  and @PIN <>'' )
 	  Begin
		INSERT tblInmate(InmateID   ,    LastName       ,     FirstName ,MidName  ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate, modifyDate ,FreeCallRemain, SEX )
			Values( @InmateID,@lastName, @FirstName,@MidName,1, 0,0,0, @facilityID,  @PIN,getdate(),getdate(), @IniFreeCall,'U') ;

	  End
	else
	 Begin
		if (@status=1)
		 begin
			UPDATE tblInmate SET  [status] = @status , modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, ReBook=1,RebookDate=GETDATE() where [Status] <4 and  [Status]  >1 and inmateID = @InmateID and FacilityID = @facilityID ;
			UPDATE tblInmate SET  [status] = @status , modifyDate = getdate() ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName where [Status] =1 and inmateID = @InmateID and FacilityID = @facilityID ;
		 end
		else
			UPDATE tblInmate SET  [status] = @status ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, modifyDate = getdate(),ReBook=0 ,RebookDate=null  where  inmateID = @InmateID and FacilityID = @facilityID;
	 End
	 
	

--if (@sendStatus =1)
	--insert tblTempInmateInsert(PIN   ,       FacilityID,InputDate)  values( @PIN, @facilityID,GETDATE())
