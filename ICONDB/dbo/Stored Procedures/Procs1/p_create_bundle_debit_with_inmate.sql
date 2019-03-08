-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_create_bundle_debit_with_inmate]
@facilityID int
AS
BEGIN
	Declare @InmateID	Varchar(12),@firstName  varchar(25),@lastName   varchar(25),@AccountNo varchar(12);
	SET @InmateID='0';
	DECLARE contact_cursor CURSOR FOR   SELECT LastName, Firstname, InmateID, FacilityID  FROM tblinmate where FacilityId = @facilityID and status =1;
 
	open contact_cursor ;
	FETCH NEXT FROM contact_cursor into @lastName,@firstName ,@InmateID, @facilityID ;  
  
-- Check @@FETCH_STATUS to see if there are any more rows to fetch.  
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		EXEC [p_create_debit_account_with_inmate1]
		@facilityID	,
		@InmateID	,
		@firstName  ,
		@lastName  ,
		5,	
		'Legacy',
		@AccountNo  OUTPUT
	   FETCH NEXT FROM contact_cursor into @lastName,@firstName ,@InmateID, @facilityID ;  
	END  
  
	CLOSE contact_cursor;  
	DEALLOCATE contact_cursor;  
End



