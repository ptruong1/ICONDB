-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_auto_insert_PAN]
@facilityID int,
@InnateID varchar(12),
@PIN	varchar(12),
@PhoneNo	varchar(15)
AS
BEGIN
	Declare @AutoPAN tinyint;
	SET @AutoPAN =0;
	select @AutoPAN = isnull(AutoPAN,0) from tblFacilityOption where FacilityID =@facilityID ;
	if(@AutoPAN > 0)
	 begin
		if (select COUNT(*) from tblPhones where FacilityID = @facilityID and InmateID =@InnateID ) < @AutoPAN
		 begin
			if (select COUNT(*) from tblPhones where FacilityID = @facilityID and InmateID =@InnateID and phoneNo=@PhoneNo) =0
			begin
				Declare  @return_value int, @nextID int, @ID int, @tblPhones nvarchar(32) ;
				EXEC   @return_value = p_create_nextID 'tblPhones', @nextID   OUTPUT
				set           @ID = @nextID ; 
		
				Insert tblPhones (RecordId, FacilityID , phoneNo ,PIN,InmateID,RelationshipID  ) values(@ID, @facilityID ,@PhoneNo , @PIN, @InnateID,10);
			end
		 end
		else
		 begin
			Update tblInmate set DNIRestrict =1, DNILimit=@AutoPAN  where FacilityId = @facilityID and InmateID = @InnateID ;
		 end
	 end
END

