CREATE PROCEDURE [dbo].[p_check_ANI]
@ANI varchar(15)
 AS
SET @ANI = right(@ANI,10)
 if (select count(*) from tblANIs with(nolock) where ANIno =@ANI) > 0
	return 1
 else
	return 0
