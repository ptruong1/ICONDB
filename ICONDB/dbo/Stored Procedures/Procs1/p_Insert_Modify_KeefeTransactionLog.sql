/****** Object:  StoredProcedure [dbo].[p_process_inmate_debit_cardless]    Script Date: 11/14/2013 15:55:37 ******/

CREATE PROCEDURE [dbo].[p_Insert_Modify_KeefeTransactionLog]
@TransactionId	varchar(40),
@InmateID	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@Amount		numeric(5,2),
@facilityFolder	varchar(20),
@TransactionDate datetime,
@ConfirmationDate varchar(50)
AS
SET NOCOUNT ON
Declare @facilityId int, @flatform int, @sendStatus tinyint, @autoPin tinyint,@AccountNo  varchar(12), @PIN varchar(12) ,@client varchar(20);
set @facilityId =0;

if (select count(*) from tblKeefeTransactionLog where transactionId = @transactionId) > 0
begin
	Update tblKeefeTransactionLog set confirmDate = @ConfirmationDate
	where transactionId = @transactionId

end
else
begin
select @facilityId = FacilityID ,@sendStatus= isnull(inmateStatus,0),@autoPin= isnull(autoPin ,0) 
from tblFacilityOption with(nolock)  where FTPfolderName = @facilityFolder	;

if(@facilityId =0)
	select @facilityId = siteID from tblClientUsers with(nolock) where userName= @facilityFolder;

				Insert tblKeefeTransactionLog
					(TransactionId,
					FacilityID,
					InmateID,
					Amount,
					InputDate,
					TransactionDate,
					ConfirmDate)
				values
					 (@TransactionId,
					 @facilityID,
					 @inmateID,
					 @Amount,
					 getDate(),
					 @TransactionDate,
					 @ConfirmationDate)
					 	;

end


				 
	
