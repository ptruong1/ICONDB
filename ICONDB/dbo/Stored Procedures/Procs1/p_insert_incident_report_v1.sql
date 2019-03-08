-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_incident_report_v1]
    @FacilityID int,
	@ANI char(10),	
	@InmateID varchar(12),
	@PIN	varchar(12),
	@FolderDate	varchar(8),
	@RecordID	bigint,
	@ServerIP	varchar(17),
	@IncidentType tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @Valid as tinyint ,@timezone smallint,@localtime datetime, @RecordName varchar(18) ;
	select @timeZone =isnull( timezone,0)  from tblfacility with(nolock) where facilityID =@facilityID;
    Set  @localtime = dateadd(hh, @timeZone,getdate() );
	SET  @RecordName  = cast(@RecordID as varchar(12)) + '.WAV' ;
	if(@FolderDate <> '')
	Declare  @return_value int, @nextID int, @ID int, @tblIncidentReport nvarchar(32) ;
	 EXEC   @return_value = p_create_nextID 'tblIncidentReport', @nextID   OUTPUT
        set           @ID = @nextID ; 
		insert [tblIncidentReport]([IncidentID], [ANI] ,[FacilityID]   ,[InmateID] ,[PIN] ,[ReportTime],[FolderName] ,[FileName], [DBerror],InputDate,ServerIP,IncidentType)
						values(@ID, @ANI, @FacilityID,@InmateID,@PIN,@localtime,@FolderDate, @RecordName,'N', getdate(),@ServerIP,@IncidentType) ; 

		--insert [tblIncidentReport]([ANI] ,[FacilityID]   ,[InmateID] ,[PIN] ,[ReportTime],[FolderName] ,[FileName], [DBerror],InputDate,ServerIP,IncidentType)
		--				values(@ANI, @FacilityID,@InmateID,@PIN,@localtime,@FolderDate, @RecordName,'N', getdate(),@ServerIP,@IncidentType) ; 

	if(@@error =0)
		select 'Success' as InmateReportIncident;
	else
		select 'Fail' as InmateReportIncident;

END

