
CREATE PROCEDURE [dbo].[p_insert_FacilityGroupDetail]
(
	       @GroupId int
		   ,@FacilityId int
		   ,@CheckBox tinyint
		   
)
AS
	SET NOCOUNT OFF;

if (@checkBox = 1)
	if (select count(*) from tblFacilityGroupDetail where groupId = @GroupId and FacilityId = @FacilityId) = 0
	begin
	 INSERT INTO [dbo].[tblFacilityGroupDetail]
			   ([GroupId]
			   ,[FacilityId]
			   ,[inputdate]
			   )
		 VALUES
			   (@GroupId
			   ,@FacilityId
			   ,GetDate()
			   )
	end
	else
	begin
	UPDATE [dbo].[tblFacilityGroupDetail]
   SET 
      [modifyDate] = GetDate()
     where groupId = @GroupId and FacilityId = @FacilityId
   end
else 
	if (select count(*) from tblFacilityGroupDetail where groupId = @GroupId and FacilityId = @FacilityId) > 0
	begin
	DELETE FROM [dbo].[tblFacilityGroupDetail]
      where groupId = @GroupId and FacilityId = @FacilityId
	end;