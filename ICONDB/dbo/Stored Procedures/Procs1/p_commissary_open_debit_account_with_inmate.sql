
CREATE PROCEDURE [dbo].[p_commissary_open_debit_account_with_inmate]
@RequestID varchar(22),
@ClientType	varchar(16),  -- client ID
@SystemID	varchar(12)	,			--Client Username
@SystemTag varchar(12),  -- facilityID	int,
@Vendor	varchar(12), --Swandons
@ResidentIdentifier	varchar(12),-- InmateID	Varchar(12),
@PIN		varchar(12),
@FirstName  varchar(25),
@LastName   varchar(25),
@TimeStamp  varchar(30),
@IPaddress varchar(16)
AS

declare @i int,  @AccountNo varchar(12),@FacilityID int, @Replystatus varchar(2), @DebitStatus tinyint, @InmateStatus tinyint, @commPIN varchar(12);
Declare @return_value int, @nextID int, @ID int, @tblDebit nvarchar(32) ;
if (isnumeric(@SystemTag) =0)
	SET @Replystatus='3'; 
else
begin
	SET @AccountNo='0' ;
	SET @Replystatus ='0';
	SET @DebitStatus  =0;
	SET @InmateStatus =0;
	SET @FacilityID = cast(@SystemTag  as int);
	SET @Replystatus= dbo.fn_verify_commissary_client(@ClientType,@FacilityID,@SystemID) ;
	SET @commPIN  = @PIN;
end
if(@Replystatus='0')
 begin
	--- New edit 
	if(@FacilityID=784)
	 begin
		SET @ResidentIdentifier = left(@ResidentIdentifier,6);
	 end
    
	if(@FacilityID=852)
	 begin
		If(len(@ResidentIdentifier) =2)
			SET  @ResidentIdentifier ='000000'+ @ResidentIdentifier
		else if len(@ResidentIdentifier) =3
			SET  @ResidentIdentifier ='00000'+ @ResidentIdentifier
		else if len(@ResidentIdentifier) =4
			SET  @ResidentIdentifier ='0000'+ @ResidentIdentifier
		else if len(@ResidentIdentifier) =5
			SET  @ResidentIdentifier ='000'+ @ResidentIdentifier
		else if len(@ResidentIdentifier) =6
			SET  @ResidentIdentifier ='00'+ @ResidentIdentifier
		else if len(@ResidentIdentifier) =7
			SET  @ResidentIdentifier ='0'+ @ResidentIdentifier
	 end

	select @InmateStatus = status from  tblinmate with(nolock) where facilityID = @FacilityID and InmateID =@ResidentIdentifier ;
	if @InmateStatus =0
	 begin
		 if(@FacilityID not in(702, 786,1, 756))		 --- Exception for Colusa facilityID =702
			SET @PIN = @ResidentIdentifier  + @PIN;
		--else
			--SET @PIN = @ResidentIdentifier ;
			
		Insert tblinmate(FacilityId , InmateID , Status , FirstName , LastName , PIN , inputdate,UserName,InmateNote, SEX, ModifyDate)
				values(@FacilityID ,@ResidentIdentifier , 1,@FirstName , @LastName , @PIN ,getdate(),@IPaddress,@commPIN,'U' , getdate() );
	 end
	 else
	  begin
		update tblinmate set  FirstName=@firstName, LastName = @LastName, Status=1 where facilityID = @facilityID and inmateID = @ResidentIdentifier;
	  end
	If(@FacilityID <> 786)
	 begin
		Select @DebitStatus=status  from tblDebit where  facilityID = @FacilityID and InmateID = @ResidentIdentifier;
		if(@DebitStatus=0)
		 Begin
			exec p_get_new_AccountNo  @AccountNo  OUTPUT;
			set @i  = 1;
			while @i = 1
			 Begin
				select  @i = count(*) from tblDebit where Accountno = @AccountNo;
				If  (@i > 0 ) 
				 Begin
					exec p_get_new_AccountNo  @AccountNo  OUTPUT;
					SET @i = 1;
				 end
			 end 
			EXEC   @return_value = p_create_nextID 'tblDebit', @nextID   OUTPUT
			set           @ID = @nextID ;  
			INSERT INTO [tblDebit] ([RecordID] ,[AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
			VALUES (@ID, @AccountNo ,@facilityID,@ResidentIdentifier, getdate(), 0,0,1, @Vendor, 'Commissary');
		  End
		 else
		  begin
			update tblDebit SET [status]=1, Note='Reopen' where facilityID = @FacilityID and InmateID = @ResidentIdentifier;
		  end
	 end
end
--Log API call
EXEC p_API_call  @RequestID ,@ClientType	,@SystemID	,@SystemTag ,@Vendor	,@ResidentIdentifier	,@PIN		,@IPaddress ,1,'0'

if(@@ERROR =0 )
 begin

		select @Replystatus as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		@FirstName  as FirstName,
		@LastName   as LastName,
		@TimeStamp  as [TimeStamp]  ;

 end
else
		select '99'  as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		@FirstName  as FirstName,
		@LastName   as LastName,
		@TimeStamp  as [TimeStamp] ;
 						
 


--declare @i int,  @AccountNo varchar(12),@FacilityID int, @Replystatus varchar(2), @DebitStatus tinyint, @InmateStatus tinyint, @commPIN varchar(12);

--if (isnumeric(@SystemTag) =0)
--	SET @Replystatus='3'; 
--else
--begin
--	SET @AccountNo='0' ;
--	SET @Replystatus ='0';
--	SET @DebitStatus  =0;
--	SET @InmateStatus =0;
--	SET @FacilityID = cast(@SystemTag  as int);
--	SET @Replystatus= dbo.fn_verify_commissary_client(@ClientType,@FacilityID,@SystemID) ;
--	SET @commPIN  = @PIN;
--end
--if(@Replystatus='0')
-- begin
--	if(@FacilityID =784)
--	 Begin
--		SET @ResidentIdentifier = left(@ResidentIdentifier,len(@ResidentIdentifier)-4);
--	 end
--	select @InmateStatus = status from  tblinmate with(nolock) where facilityID = @FacilityID and InmateID =@ResidentIdentifier ;
	
--	if(@FacilityID not in (702,1,786))		 --- Exception 
--			SET @PIN = @ResidentIdentifier  + @PIN;
	
--	if (@InmateStatus =0)
--	 begin
--		--else
--			--SET @PIN = @ResidentIdentifier ;
			
--		Insert tblinmate(FacilityId , InmateID , Status , FirstName , LastName , PIN , inputdate,UserName,InmateNote)
--				values(@FacilityID ,@ResidentIdentifier , 1,@FirstName , @LastName , @PIN ,getdate(),@IPaddress,@commPIN  );
--	 end
--	 Else If  (@InmateStatus =1)
--	  begin
--		 SET @Replystatus='6';
--	  end
--	 else
--	  begin
--	    if(@FacilityID <>747)
--			update tblinmate set  FirstName=@firstName, LastName = @LastName, Status=1, PIN= @PIN where facilityID = @facilityID and inmateID = @ResidentIdentifier;
--	  end
--	Select @DebitStatus=status  from tblDebit where  facilityID = @FacilityID and InmateID = @ResidentIdentifier;
--	if(@DebitStatus=0)
--	 Begin
--		exec p_get_new_AccountNo  @AccountNo  OUTPUT;
--		set @i  = 1;
--		while @i = 1
--		 Begin
--			select  @i = count(*) from tblDebit where Accountno = @AccountNo;
--			If  (@i > 0 ) 
--			 Begin
--				exec p_get_new_AccountNo  @AccountNo  OUTPUT;
--				SET @i = 1;
--			 end
--		 end 

--		INSERT INTO [tblDebit] ( [AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
--		VALUES (@AccountNo ,@facilityID,@ResidentIdentifier, getdate(), 0,0,1, @Vendor, 'Commissary');
--	  End
--	 else
--	  begin
--		update tblDebit SET status=1 where facilityID = @FacilityID and InmateID = @ResidentIdentifier;
--	  end
--end
--if(@@ERROR =0 )
-- begin

--		select @Replystatus as ReplyStatus,
--		@RequestID as RequestID,
--		@ClientType as ClientType,  -- not use
--		@SystemID	as SystemID	,			--ClientID
--		@SystemTag as SystemTag,  -- facilityID	int,
--		@Vendor	as Vendor, --Swandons
--		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
--		@PIN		as PIN,
--		@FirstName  as FirstName,
--		@LastName   as LastName,
--		@TimeStamp  as [TimeStamp]  ;

-- end
--else
--		select '99'  as ReplyStatus,
--		@RequestID as RequestID,
--		@ClientType as ClientType,  -- not use
--		@SystemID	as SystemID	,			--ClientID
--		@SystemTag as SystemTag,  -- facilityID	int,
--		@Vendor	as Vendor, --Swandons
--		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
--		@PIN		as PIN,
--		@FirstName  as FirstName,
--		@LastName   as LastName,
--		@TimeStamp  as [TimeStamp] ;
 						
 

