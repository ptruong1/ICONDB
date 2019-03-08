
Create PROCEDURE [dbo].[p_check_keefeLog_for_Confirmation_errors]
 
AS
SET nocount on
SELECT  [TransactionId]
      ,[FacilityID]
      ,[InmateID]
      ,[TransactionDate]
      ,[Amount]
      ,[clientID]
      ,[InputDate]
      ,[ConfirmDate]
  FROM [tblKeefeTransactionLog]
  where ConfirmDate = ''
  order by inputDate
