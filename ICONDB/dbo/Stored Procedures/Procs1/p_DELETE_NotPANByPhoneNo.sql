CREATE PROCEDURE [dbo].[p_DELETE_NotPANByPhoneNo]
(
	@PhoneNo Varchar(12),
	@InmateID varchar(12),
	@facilityID int,
	@Maxallow int,
	@UserName varchar(25)
)
AS
Begin
	SET NOCOUNT OFF;
	Declare  @WhatEdit varchar(200) ,@ActTime datetime;
	DELETE FROM tblBlockedPhonesByPIN
		 WHERE PhoneNo=@PhoneNo and  FacilityID=@FacilityID and InmateID=@InmateID
	
	SET @WhatEdit = 'Delete PRN:' +  @PhoneNo;
		
	EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActTime  ,0,@UserName ,'',	@InmateID,@WhatEdit;
End
/*declare @Limit int
set @Limit = (select count(*) from tblBlockedPhonesByPIN where facilityid = @facilityId and inmateID = @InmateId)
if (@MaxAllow = @Limit)
begin 
			UPDATE [dbo].[tblInmate]
			SET  [PANNotAllow] = 1
			WHERE (InmateID = @InmateId AND [FacilityId] = @FacilityId) ;
end
else
begin 
			UPDATE [dbo].[tblInmate]
			SET  [PANNotAllow] = 0
			WHERE (InmateID = @InmateId AND [FacilityId] = @FacilityId) ;
end*/
