
CREATE PROCEDURE [dbo].[p_manual_process_inmate_data_with_auto_pin]
@InmateID	varchar(12),
@facilityID	int,
@PinLen  int
AS

declare 	 @i int, @PIN  varchar(12) ;

		exec p_create_new_PIN1  @PinLen,   @PIN  OUTPUT
		set @i  = 1;
		while @i = 1
		 Begin
			SET @PIN = @InmateID + @PIN;
			select  @i = count(*) from tblInmate where PIN = @PIN  and  FacilityID =  @FacilityId;
			If  (@i > 0 ) 
			 Begin
				exec p_create_new_PIN1  @PinLen,   @PIN  OUTPUT;
				SET @i = 1;
			 end
		  end
		
UPDATE tblInmate SET   modifyDate = getdate() , username='admin', PIN = @PIN where  inmateID = @InmateID and FacilityID = @facilityID ;

