/****** Object:  StoredProcedure [dbo].[p_process_inmate_debit_cardless]    Script Date: 11/14/2013 15:55:37 ******/

CREATE PROCEDURE [dbo].[p_process_inmate_debit_cardless]
@OrderNo	varchar(15),
@InmateID	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@Amount		numeric(5,2),
@facilityFolder	varchar(20)

AS
SET NOCOUNT ON
Declare @facilityId int, @flatform int, @sendStatus tinyint, @autoPin tinyint,@AccountNo  varchar(12), @PIN varchar(12) ,@client varchar(20);
set @facilityId =0;
SET @flatform = 2;
SET @sendStatus =0;
SET @autoPin =0;
SET @AccountNo ='0';
SET @client ='';

select @facilityId = FacilityID ,@sendStatus= isnull(inmateStatus,0),@autoPin= isnull(autoPin ,0) from tblFacilityOption with(nolock)  where FTPfolderName = @facilityFolder	;
--SET  @flatform = [leg_Icon].[dbo].fn_determine_flatform (@facilityID);
if(@facilityId =0)
	select @facilityId = siteID from tblClientUsers with(nolock) where userName= @facilityFolder;

If(@facilityId >0)
 begin
	if(@facilityId =607)  --Hard code for Dona
	 Begin
		SET @InmateID  = RIGHT(@InmateID,6)
		exec p_create_new_PIN1  4,   @PIN  OUTPUT ;
		SET @PIN= @InmateID + @PIN;
	 end
	else if (@facilityId =807) 
	 begin 
		SET @InmateID = '00' + @InmateID;
	 end
	Else
	 begin
		SET @PIN= @InmateID ;
	 End
	
	select @sendStatus = [status] from leg_Icon.dbo.tblInmate with(nolock) where FacilityId =@facilityID and InmateID =@InmateID;
	if ( @sendStatus >1 ) 
		update leg_Icon.dbo.tblInmate set [Status]=1 where FacilityId =@facilityID and InmateID =@InmateID ;
	else if ( @sendStatus =0 and @facilityId <>807 ) 
		insert leg_Icon.dbo.tblInmate(inmateID, pin, facilityID, [status], FirstName, LastName,inputDate)
								values (@inmateID,@PIN,@facilityID,1,@firstName,@lastName,getdate());

								
	Select @client  = Client from 	tblCommissary with(nolock) where facilityId =@facilityId	;
	if(@client ='Cashless' or @client ='Infinity' or  @client='Tech Friend'  or @facilityId=761) 
	 begin
		 if(Select COUNT(*) from tblDebitCardOrder where FacilityID = @facilityId and  OrderNo= @OrderNo )= 0
		  begin
			EXEC  [p_create_debit_account_with_inmate] 
				@facilityID	,	@InmateID	,	@firstName	,
				@lastName	,	@Amount	,	@client,
				@AccountNo OUTPUT ;
				Insert tblDebitCardOrder(OrderNo,FacilityID,InmateID,Amount,clientID)
					 values(@orderNo,@facilityID,@inmateID,@Amount,@client)	;
		  end
	 end
	else
	 begin
		
		EXEC  [p_create_debit_account_with_inmate] 
				@facilityID	,	@InmateID	,	@firstName	,
				@lastName	,	@Amount	,	@client,
				@AccountNo OUTPUT ;
		Insert tblDebitCardOrder(OrderNo,FacilityID,InmateID,Amount,clientID)
					 values(@orderNo,@facilityID,@inmateID,@Amount,@client)	;
	 end

 end


				 
	
