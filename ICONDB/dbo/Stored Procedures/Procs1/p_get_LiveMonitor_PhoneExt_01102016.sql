-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_LiveMonitor_PhoneExt_01102016] 
	@userName	varchar(20),
	@browserName varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @RegExt varchar(10), @RegPassword varchar(10), @ServerIP varchar(16)
	SET @RegExt =''
	
	
		if(select COUNT(*) from  leg_Icon.dbo.tblUserprofiles where UserID=@userName) =0
		begin
			select '' as ServerIP , '' as RegExt, '' as RegPassword
			return -1
		end
	select @RegExt = phoneExt from  leg_Icon.dbo.tblLiveMonitorExt where usedBy =@userName
	if(@RegExt='') 
		select top 1 @RegExt = phoneExt from  leg_Icon.dbo.tblLiveMonitorExt where usedBy ='' or usedBy is null
	Update leg_Icon.dbo.tblLiveMonitorExt  set usedby = @userName, lastUsed =getdate() where phoneExt = @RegExt
	
	Select @ServerIP =ServerPublicIP ,@RegPassword=  RegPassword from leg_Icon.dbo.tblLiveMonitorServer where Brownser = @browserName
	select @ServerIP as ServerIP , @RegExt as RegExt, @RegPassword as RegPassword
    
END


