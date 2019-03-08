
CREATE PROCEDURE [dbo].[p_log_data_Maine]
@FacilityID int,
@InmateID	varchar(12),
@PIN	varchar(12),
@billCallStatus tinyint,
@fromNo	char(10),
@Tono		varchar(18),
@Duration	int,
@Charge		numeric(5,2),
@ReturnValue smallint,
@Log_ID		int,
@RecordID	bigint,
@Error_ID	varchar(3),
@APItype	tinyint

AS
SET NOCOUNT ON;


Insert tblMaineLogs (PIN,InmateID,CurrentStatus ,ReturnValue, Log_ID  , RecordDate,FromNo,Tono,Charge,ReferenceNo,Duration,Error_ID, APItype,FacilityID)
values (@pin, @InmateID, @billCallStatus,@ReturnValue,@Log_ID,getdate(), @FromNo,@Tono,@Charge,@RecordID,@Duration,@Error_ID,@APItype,@FacilityID);


if(@Error_ID='999' and @APItype =3)	
	EXEC p_insert_queue 3,	@PIN  ,	@InmateID  ,	@FromNo  ,	@ToNo	,	@RecordID ,	@Duration ,@Charge ;
 
