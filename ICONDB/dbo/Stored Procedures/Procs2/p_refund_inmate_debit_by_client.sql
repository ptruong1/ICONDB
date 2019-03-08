/****** Object:  StoredProcedure [dbo].[p_process_inmate_debit_cardless]    Script Date: 11/14/2013 15:55:37 ******/

CREATE  PROCEDURE [dbo].[p_refund_inmate_debit_by_client]
@OrderNo	varchar(15),
@InmateID	varchar(12),
@RefundAmount		numeric(5,2),
@siteID	     int,
@clientID   varchar(10)

AS
SET NOCOUNT ON;
Declare @LastBalance numeric(6,2),@accountNo varchar(12), @status tinyint;
SET  @LastBalance =0;
SET @status =1;
select @LastBalance = balance,@accountNo=AccountNo  from tblDebit with(nolock) where FacilityID = @siteID and InmateID =@InmateID ;
select @status = [status] from tblinmate with(nolock) where  FacilityID = @siteID	and InmateID =@InmateID ;

Update tblDebit set Balance = Balance -@RefundAmount ,status =  @status,Note='Refund from Kiosk ' + @OrderNo ,UserName=@clientID   where FacilityID = @siteID	and InmateID =@InmateID;

Declare  @return_value int, @nextID int, @ID int, @tblAdjustment nvarchar(32) ;
		EXEC   @return_value = p_create_nextID 'tblAdjustment', @nextID   OUTPUT
             set           @ID = @nextID ;    										 
		insert tblAdjustment (AdjID, AdjTypeID, AccountNo  ,LastBalance ,  AdjAmount  ,Descript, AdjustDate ,  UserName ,   status)	
						 values(@ID,7,@AccountNo, @LastBalance,	@RefundAmount,'Refund from Kisok',	GETDATE(), 	@clientID,1)		;

--insert tblAdjustment (AdjTypeID,AccountNo, LastBalance ,AdjAmount ,Descript ,AdjustDate ,UserName ,status )
--			values(7,@accountNo,@LastBalance,@RefundAmount,'Refund from Kisok',GETDATE(), @clientID ,1);

if(@@ERROR =0)	
	Select '000' As AuthCode  ;
else
	Select '100' As AuthCode  ;
				 