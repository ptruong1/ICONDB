
CREATE PROCEDURE [dbo].[UPDATE_KeyWordText]
(
	@FacilityID int,
	@Keywords varchar(500),
	@UserName varchar(20),
	@AlertEmail varchar(200),
	@AlertCellPhones varchar(200),
	@ModifyDate smallDateTime
)
AS
	
SET NOCOUNT OFF;

	BEGIN
					
				UPDATE tblFacilityKeywords SET  [Keywords] = @Keywords, 
							[UserName] = @UserName, [AlertEmail] = @AlertEmail, [AlertCellPhones] = @AlertCellPhones, [modifyDate] = @ModifyDate
							
						WHERE FacilityID = @FacilityId
		
		RETURN 0;
	END

