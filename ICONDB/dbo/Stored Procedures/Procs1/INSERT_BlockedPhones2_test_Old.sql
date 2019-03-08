
CREATE PROCEDURE [dbo].[INSERT_BlockedPhones2_test_Old]
(
	@PhoneNo char(10),
	@FacilityID int,
	@ReasonID tinyint,
	@Descript char(200),
	@UserName varchar(25),
	@RequestID tinyint,
	@TimeLimited tinyint
)
AS
SET NOCOUNT OFF;
Declare @UserAction  varchar(100),@ActTime datetime;
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 

Begin 
	if (select count(AuthNo)  from tblOfficeANI  with(nolock)  where  AuthNo = @PhoneNo)  > 0
	 begin
		RETURN -1;

	 end 


	IF (select COUNT(PhoneNo ) from [tblBlockedPhones] with(nolock) Where (FacilityID=@FacilityID or FacilityID=1) and PhoneNo =@PhoneNo )>0
		BEGIN
			RETURN -1;
		END
	ELSE
		BEGIN
			INSERT INTO [tblBlockedPhones] ([PhoneNo], [FacilityID], [ReasonID], [Descript], [UserName], [RequestID], [TimeLimited],inputDate )  VALUES (@PhoneNo, @FacilityID, @ReasonID, @Descript, @UserName, @RequestID, @Timelimited,@ActTime);
		END
	SET  @UserAction =  'Block Phone: ' + @PhoneNo  ;
	EXEC  INSERT_ActivityLogs3_test	@FacilityID ,15,@ActTime ,0,@UserName ,'', @PhoneNo ,@UserAction ;  
	
	return @@error;

	
end
