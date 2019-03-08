/****** Object:  StoredProcedure [dbo].[p_process_inmate_debit_cardless]    Script Date: 11/14/2013 15:55:37 ******/

Create PROCEDURE [dbo].[p_update_Debit_from_KeefeLog_Onetime]

AS
SET NOCOUNT ON
SELECT [TransactionId]
      ,[FacilityID]
      ,[InmateID]
      ,[TransactionDate]
      ,[Amount]
      ,[clientID]
      ,[InputDate]
      ,[ConfirmDate]
  FROM [Leg_ICON].[dbo].[tblKeefeTransactionLog]
  where inputDate > '2018-12-16'
