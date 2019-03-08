-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_monitor_FTP_file_process]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  select  FacilityID , FolderName  ,  lastUpdate ,'it@legacyinmate.com' as ResponseEmail
	from tblFTPfileprocess with(nolock) where DATEDIFF (HOUR, lastUpdate ,GETDATE()) >2  and DATEDIFF (HOUR, lastUpdate ,GETDATE()) <5 ;
END

