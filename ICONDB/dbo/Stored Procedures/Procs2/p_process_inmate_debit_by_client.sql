/****** Object:  StoredProcedure [dbo].[p_process_inmate_debit_cardless]    Script Date: 11/14/2013 15:55:37 ******/

CREATE PROCEDURE [dbo].[p_process_inmate_debit_by_client]
@OrderNo	varchar(15),
@InmateID	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@PurchaseAmount		numeric(5,2),
@siteID	     int,
@clientID   varchar(10)

AS
SET NOCOUNT ON;
Declare  @flatform int, @sendStatus tinyint, @autoPin tinyint,@AccountNo  varchar(12), @PIN varchar(12), @iLen tinyint;

SET @flatform = 2;
SET @sendStatus =0;
SET @autoPin =0;
SET @AccountNo ='0';
if(@siteID =558)
 begin
		SET @iLen = LEN(@InmateID);
		if( @iLen <8)
		 begin
			if(@iLen =7)
				SET @InmateID = '0' + @InmateID;
			else if (@iLen =6)
				SET @InmateID = '00' + @InmateID;
			else if (@iLen =5)
				SET @InmateID = '000' + @InmateID;
			else if (@iLen =4)
				SET @InmateID = '0000' + @InmateID;
			else if (@iLen =3)
				SET @InmateID = '00000' + @InmateID;
			else if (@iLen =2)
				SET @InmateID = '000000' + @InmateID;
			else 
				SET @InmateID = '0000000' + @InmateID;
		 end
 end 
select @sendStatus = [status] from leg_Icon.dbo.tblInmate where FacilityId =@siteID and InmateID =@InmateID ;
if ( @sendStatus >1 )
 Begin 
	Select '005' As AuthCode ,0.0  Balance ;
	return -1;
 end
else if ( @sendStatus =0 ) 
 Begin
	--Select '006' As AuthCode ,0.0  Balance ;
	if(@siteID =607)
	 Begin
		SET @InmateID  = RIGHT(@InmateID,6)
		if ( select COUNT(*) from leg_Icon.dbo.tblInmate where FacilityId =@siteID and InmateID =@InmateID) = 0
		 begin
			exec p_create_new_PIN1  4,   @PIN  OUTPUT ;
			SET @PIN= @InmateID + @PIN;
			insert leg_Icon.dbo.tblInmate(inmateID, pin, facilityID, [status], FirstName, LastName,inputDate)
							values (@inmateID,@PIN,@siteID,1,@firstName,@lastName,getdate());
		 end
	 end
	else
	 begin
		SET @PIN = @InmateID
		insert leg_Icon.dbo.tblInmate(inmateID, pin, facilityID, [status], FirstName, LastName,inputDate)
							values (@inmateID,@PIN,@siteID,1,@firstName,@lastName,getdate());
	 end
	
	--return -1;
 end							
 
 if(Select COUNT(*) from tblDebitCardOrder where OrderNo= @OrderNo and clientID =@clientID )> 0
  begin
	Select '007' As AuthCode ,0.0  Balance ;
	return -1;
  end
	
 Insert tblDebitCardOrder(OrderNo,FacilityID,InmateID,Amount,clientID )
				 values(@orderNo,@siteID,@inmateID,@PurchaseAmount, @clientID );
 
EXEC [p_create_debit_account_with_inmate]
	@siteID,	@InmateID	,	''  ,	''  ,
	@PurchaseAmount	,	@clientID ,	@AccountNo  OUTPUT ;
			

if(@@ERROR =0)	
	Select '000' As AuthCode , Balance from  tblDebit where	 AccountNo =@AccountNo 		 ;
				 

	
