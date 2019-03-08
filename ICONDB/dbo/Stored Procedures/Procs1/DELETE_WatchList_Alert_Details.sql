CREATE PROCEDURE [dbo].[DELETE_WatchList_Alert_Details]
(
	@WatchListDetailID int,
	@WatchByID int
)
AS
	SET NOCOUNT OFF;
	DECLARE @count int;

    If @WatchByID = 1 -- by Source
     		DELETE FROM [tblAlertANIs] WHERE WatchListDetailID = @WatchListDetailID
   else
   If @WatchByID = 2 -- By DNI
     
		DELETE FROM [tblAlertPhones] WHERE WatchListDetailID = @WatchListDetailID
		
   else
   If @WatchByID = 3 -- By PIN
     
		DELETE FROM [tblAlertPINs] WHERE WatchListDetailID = @WatchListDetailID
	
   else
   If @WatchByID = 4 -- Division
      		return 0;
  else
     
		return 0;
