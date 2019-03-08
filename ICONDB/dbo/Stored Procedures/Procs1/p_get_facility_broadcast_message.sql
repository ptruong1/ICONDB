-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_facility_broadcast_message]
@FacilityID int,
@IPaddress varchar(17)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @CurrentDate date, @AllMesages varchar(2000), @Message varchar(500);
	SET  @CurrentDate = getdate();
	SET @AllMesages = '' 
	if (select count(*) from tblfacilityofficeMessage with(nolock) where (FacilityID = @FacilityID)  and FromDate <= @CurrentDate and ToDate >=  @CurrentDate) > 0
	begin
		DECLARE Mess_cursor CURSOR FOR SELECT  [Message] from tblfacilityofficeMessage with(nolock) where (FacilityID = @FacilityID)  and FromDate <= @CurrentDate and ToDate >=  @CurrentDate
			order by messageID desc;
			OPEN Mess_cursor;

	   FETCH NEXT FROM Mess_cursor into  @Message;

		WHILE @@FETCH_STATUS = 0
		  begin
			 SET  @AllMesages =  @AllMesages +  @Message + '. ';
		  
			  FETCH NEXT FROM Mess_cursor into  @Message;	
		  end
		
		close  Mess_cursor;
		Deallocate  Mess_cursor;
		
	end
  Else
	 begin
		SET @AllMesages = 'You can save time and money while visiting from the comfort of your home, office or anywhere. Establish an account and begin scheduling remote video visits today!' ;
	
	 end
	 Select @AllMesages as AllMessages;
End

