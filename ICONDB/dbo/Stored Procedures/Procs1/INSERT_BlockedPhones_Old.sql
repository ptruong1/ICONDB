
CREATE PROCEDURE [dbo].[INSERT_BlockedPhones_Old]
(
	@PhoneNo char(10),
	@FacilityID int,
	@ReasonID tinyint,
	@UserName varchar(25),
	@RequestID tinyint
)
AS
	SET NOCOUNT OFF;

if (select count(AuthNo)  from tblOfficeAnI  with(nolock)  where  AuthNo = @PhoneNo)  > 0
 begin
	RETURN -1;

 end 
IF @PhoneNo in (SELECT PhoneNo FROM [tblBlockedPhones] Where (FacilityID=@FacilityID or FacilityID=1))
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		INSERT INTO [tblBlockedPhones] ([PhoneNo], [FacilityID], [ReasonID], [UserName], [RequestID]) VALUES (@PhoneNo, @FacilityID, @ReasonID, @UserName, @RequestID);
		RETURN 0;
	END
