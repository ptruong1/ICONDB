
CREATE PROCEDURE [dbo].[SELECT_EndUserPasswordByEmail]
(
	@Email varchar(50)
)
AS
	SET NOCOUNT ON;
SELECT        Password
FROM            tblEndusers
WHERE Email = @Email

