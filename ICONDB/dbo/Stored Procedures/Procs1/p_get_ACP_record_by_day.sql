-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_ACP_record_by_day]
@dayInteval tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @StorageServer varchar(30), @sourceDirectory varchar(50),@folderDate varchar(8);
	SET @folderDate = convert (varchar(8),dateadd(day,-@dayInteval, getdate()),112);
	--SET @folderDate = convert (varchar(8),dateadd(day,-20, getdate()),112);
	--select @folderDate;
	--If(@folderDate >'20161220')
		--SET  @StorageServer ='\\172.77.10.21\Mediafiles1\' ;
		SET  @StorageServer ='Y:\' ;
	--else
		--SET  @StorageServer ='\\172.77.10.20\Mediafiles\' ;

	SET @sourceDirectory=  '\home\AudioRecSource\line00\'
	select    ('\\' + b.IpAddress + @sourceDirectory + '20' + a.Calldate ) as ACPFolderSource, (@StorageServer+  b.ComputerName + '\line00\' +  a.FolderDate )  as ACPFolderDesc, a.RecordFile  from tblcallsbilled a with(nolock) , tblACPs b with(nolock) where a.userName = b.IpAddress and  FolderDate= @folderDate  and a.RecordFile <>'NA' and a.calldate <>'';
	
	--select    ('\\' + b.IpAddress + @sourceDirectory + '20' + a.Calldate ) as ACPFolderSource, (@StorageServer+  b.ComputerName + '\line00\' +  a.FolderDate )  as ACPFolderDesc, a.RecordFile  from tblcallsbilled a with(nolock) , tblACPs b with(nolock) where a.userName = b.IpAddress and recordID =103606281
END

