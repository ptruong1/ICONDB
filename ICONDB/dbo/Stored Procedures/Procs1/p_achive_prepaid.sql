-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_achive_prepaid]
@d datetime	 
AS
BEGIN
	
	SET NOCOUNT ON;

	insert tblEndusersArchive
	select * from tblEndusers where EndUserID in (select EndUserID from tblPrepaid where ModifyDate <@d)
	delete tblEndusers where EndUserID in (select EndUserID from tblPrepaid where ModifyDate <@d)
	insert tblPrepaidArchive 
	select * from tblprepaid where ModifyDate <@d
	delete tblprepaid where ModifyDate <@d




END

