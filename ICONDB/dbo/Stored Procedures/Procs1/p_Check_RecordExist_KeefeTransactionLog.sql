/****** Object:  StoredProcedure [dbo].[p_process_inmate_debit_cardless]    Script Date: 11/14/2013 15:55:37 ******/

CREATE PROCEDURE [dbo].[p_Check_RecordExist_KeefeTransactionLog]
@TransactionId	varchar(40),
@RecordExist int output

AS
SET NOCOUNT ON
if (select count(*) from tblKeefeTransactionLog where transactionId = @transactionId) = 0
 set @RecordExist = 0
 else
 set @RecordExist = 1;
