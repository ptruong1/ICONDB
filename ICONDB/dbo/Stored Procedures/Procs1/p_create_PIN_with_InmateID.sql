-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_create_PIN_with_InmateID]
@facilityID int,
@PINlen tinyint
AS
BEGIN
	Declare @DOB  varchar(10), @Firstname varchar(30),@lastName varchar(30), @InmateID varchar(10), @PIN varchar(6), @i int;

	DECLARE Inmate CURSOR FOR  SELECT DOB, Firstname,lastName,InmateID  FROM YumaInmate;

  
	OPEN Inmate;  
  
	-- Perform the first fetch.  
	FETCH NEXT FROM Inmate into @DOB  , @Firstname ,@lastName , @InmateID ;  
  
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.  
	WHILE @@FETCH_STATUS = 0  
	BEGIN   

			exec p_create_new_PIN1  @PINlen,    @PIN   OUTPUT;
			set @i  = 1;
			select @i;
			while @i = 1
			 Begin
				select  @i = count(*) from tblInmate where PIN = @PIN  and  FacilityID = @facilityID;
				If  (@i > 0 ) 
				 Begin
					exec p_create_new_PIN1  @PINlen,   @PIN  OUTPUT;
					SET @i = 1;
				 end
			 end

			INSERT tblInmate(InmateID   ,  LastName  ,FirstName ,MidName  ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate , DOB  )
				Values( @InmateID,@lastName, @FirstName,'',0, 0,0,0, 574,@facilityID,getdate(), @DOB);

	   FETCH NEXT FROM Inmate into @DOB  , @Firstname ,@lastName , @InmateID ;  
	END  
  
	CLOSE Inmate;  
	DEALLOCATE Inmate;  

END
 


