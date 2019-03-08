
CREATE PROCEDURE [dbo].[INSERT_BlockedPhones1_Old]
(
	@PhoneNo char(10),
	@FacilityID int,
	@ReasonID tinyint,
	@UserName varchar(25),
	@RequestID tinyint,
	@TimeLimited tinyint
)
AS
	SET NOCOUNT OFF;

if (select count(AuthNo)  from tblOfficeAnI  with(nolock)  where  AuthNo = @PhoneNo)  > 0
 begin
	RETURN -1;

 end 
EXEC  INSERT_ActivityLogs1   @FacilityID,8, 0,	@userName,'', @PhoneNo
IF @PhoneNo in (SELECT PhoneNo FROM [tblBlockedPhones] Where (FacilityID=@FacilityID or FacilityID=1))
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		INSERT INTO [tblBlockedPhones] ([PhoneNo], [FacilityID], [ReasonID], [UserName], [RequestID], [TimeLimited])  VALUES (@PhoneNo, @FacilityID, @ReasonID, @UserName, @RequestID, @Timelimited);
		RETURN 0;
	END
