-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_phoneExt] 
	@AllExt Nvarchar(1500)
AS
SET NOCOUNT ON
BEGIN
	Declare @cPos int, @AllLen int, @sepator char(1),@EXT varchar(10),@sPos int;
	SET @AllLen = LEN (@AllExt);
	SET @sepator =',';
	SET @sPos = 0;
	SET @cPos= CHARINDEX(@sepator,@AllExt);
	SET @EXT=  SUBSTRING(@AllExt,@sPos, @cPos);
	SET @EXT= LTRIM(RTRIM(@EXT));
	IF((SELECT COUNT(*) from leg_Icon_dev.dbo.tblLiveMonitorExt  where phoneExt =@EXT) =0  AND @EXT<>'')
		INSERT leg_Icon_dev.dbo.tblLiveMonitorExt Values(@EXT,'');
	else
		Update leg_Icon_dev.dbo.tblLiveMonitorExt set Usedby='' where phoneExt =@EXT;
	SET @AllExt =SUBSTRING (@AllExt,@cPos+1, @AllLen);
	SET @cPos= CHARINDEX(@sepator,@AllExt);
	SET @AllLen = LEN (@AllExt);
	WHILE @cPos >0
		begin
			SET @EXT=  SUBSTRING(@AllExt,@sPos, @cPos);
			IF ((SELECT COUNT(*) from leg_Icon_dev.dbo.tblLiveMonitorExt  where phoneExt =@EXT) =0 AND @EXT<>'')
				INSERT leg_Icon_dev.dbo.tblLiveMonitorExt Values(@EXT,'');
			else
				Update leg_Icon_dev.dbo.tblLiveMonitorExt set Usedby='' where phoneExt =@EXT;
			SET @AllExt =SUBSTRING (@AllExt,@cPos+1, @AllLen);
			SET @cPos= CHARINDEX(@sepator,@AllExt);
			SET @AllLen = LEN (@AllExt);
			
		end
	SET @EXT = @AllExt
	--select @EXT
	IF ((SELECT COUNT(*) from leg_Icon_dev.dbo.tblLiveMonitorExt  where phoneExt =@EXT) =0 AND @EXT<>'')
		INSERT leg_Icon_dev.dbo.tblLiveMonitorExt Values(@EXT,'');
	else
		Update leg_Icon_dev.dbo.tblLiveMonitorExt set Usedby='' where phoneExt =@EXT;
	
	if (@@ERROR =0)
		select 'Success' as UpdateExt;
	else
		select 'Fail' as  UpdateExt;
END

