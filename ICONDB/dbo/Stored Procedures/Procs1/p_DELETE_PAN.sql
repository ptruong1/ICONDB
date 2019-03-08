


CREATE PROCEDURE [dbo].[p_DELETE_PAN]
(
	@RecordID bigint,
	@PAN	varchar(15),
	@InmateID varchar(12),
	@facilityID int,
	@Maxallow int,
	@UserName varchar(25)
)
AS
BEGIN
	SET NOCOUNT OFF;
	Declare  @WhatEdit varchar(200) ,@ActTime datetime;
	SET @WhatEdit = 'Delete PAN:' +  @PAN;
		
	EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActTime  ,0,@UserName ,'',	@InmateID,@WhatEdit;
	DELETE FROM [tblPhones] WHERE (RecordID=@RecordID);
END




