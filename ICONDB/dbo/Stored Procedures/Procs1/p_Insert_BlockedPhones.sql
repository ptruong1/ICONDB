
CREATE PROCEDURE [dbo].[p_Insert_BlockedPhones]
(
	@PhoneNo char(10),
	@FacilityID int,
	@ReasonID tinyint,
	@Descript char(200),
	@UserName varchar(25),
	@RequestID tinyint,
	@TimeLimited tinyint,
	@UserIP varchar(25)
)
AS
SET NOCOUNT OFF;
Declare @UserAction  varchar(100),@ActTime datetime;
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 

Begin 
	if (select count(AuthNo)  from tblOfficeANI  with(nolock)  where  AuthNo = @PhoneNo)  > 0
	 begin
		RETURN -2;

	 end 


	IF (select COUNT(PhoneNo ) from [tblBlockedPhones] with(nolock) Where (FacilityID=@FacilityID or FacilityID=1) and PhoneNo =@PhoneNo )>0
		BEGIN
			RETURN -1;
		END
	ELSE
		BEGIN
			INSERT INTO [tblBlockedPhones] ([PhoneNo], [FacilityID], [ReasonID], [Descript], [UserName], [RequestID], [TimeLimited],inputDate )  VALUES (@PhoneNo, @FacilityID, @ReasonID, @Descript, @UserName, @RequestID, @Timelimited,@ActTime);
		END
	SET  @UserAction =  'Add Block Phone: ' + @PhoneNo  ;
	EXEC  INSERT_ActivityLogs3	@FacilityID ,15,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ;  
	
	--return @@error;

	
end
