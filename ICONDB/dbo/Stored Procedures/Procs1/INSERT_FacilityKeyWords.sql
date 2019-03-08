
CREATE PROCEDURE [dbo].[INSERT_FacilityKeyWords]
(
	
	@FacilityId int,
	@Keywords varchar(500),
	@UserName varchar(20),
	@AlertEmail varchar(200),
	@AlertCellPhones varchar(200)
	
)
AS
	SET NOCOUNT OFF;

IF @FacilityID in (SELECT FacilityID FROM tblFacilityKeywords WHERE FacilityID = @FacilityId)
	RETURN -1;
ELSE
	BEGIN
					
				INSERT INTO [tblFacilityKeywords] ([FacilityID], [Keywords], 
							[UserName], [AlertEmail], [AlertCellPhones])
							
						VALUES (@FacilityID, @Keywords, @UserName, @AlertEmail, 
								 @AlertCellPhones);
		
		RETURN 0;
	END

