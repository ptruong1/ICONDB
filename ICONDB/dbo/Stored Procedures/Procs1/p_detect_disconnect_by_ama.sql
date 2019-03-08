CREATE PROCEDURE [dbo].[p_detect_disconnect_by_ama]
@projectCode	char(6),
@connectDate	char(6)

 AS


 If (SELECT   count(*)   FROM tblAMA      WHERE   projectCode= @projectCode AND connectDate = @connectDate ) > 0

	return  1

else 
	return 0
