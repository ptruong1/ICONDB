/****** Object:  StoredProcedure [dbo].[p_process_inmate_debit_cardless]    Script Date: 11/14/2013 15:55:37 ******/

CREATE  PROCEDURE [dbo].[p_get_inmate_debit_accout_balance]
@InmateID	varchar(12),
@siteID	     int
AS
SET NOCOUNT ON;
Declare @LastBalance numeric(6,2),@accountNo varchar(12);
SET  @LastBalance =0;
select @LastBalance = balance,@accountNo=AccountNo  from tblDebit where FacilityID = @siteID	and InmateID =@InmateID and status =1;

if(@@ERROR =0)	
	Select '000' As AuthCode, @LastBalance as Balance  ;
else
	Select '100' As AuthCode ,@LastBalance as Balance ;
				 
