
CREATE PROCEDURE [dbo].[p_log_data_Amtel]
@FacilityID int,
@InmateID	varchar(12),
@PIN	varchar(12),
@LastName varchar(25),
@FirstName varchar(25),
@MidName varchar(25),
@AmtelFacilityID int,
@Status	tinyint,
@Cell  varchar(30),
@Location varchar(30),
@fromNo	char(10),
@Tono		varchar(18),
@Duration	int,
@Charge		numeric(5,2),
@RecordID	bigint,
@Error_ID	varchar(3),
@PhoneBalance money,
@APItype	tinyint

AS
SET NOCOUNT ON;


Insert tblAmtelLogs (PIN,InmateID,FirstName, LastName, MidName, AmtelFacilityID, PhoneBalance,  pod,cell, CurrentStatus , RecordDate,FromNo,Tono,Charge,ReferenceNo,Duration,Error_ID, APItype,FacilityID)
values (@pin, @InmateID,@FirstName, @LastName,@MidName,@AmtelFacilityID,@PhoneBalance,  @Location, @Cell,@Status, getdate(), @FromNo,@Tono,@Charge,@RecordID,@Duration,@Error_ID,@APItype,@FacilityID);

if(@APItype=1 and @Status=1)
	EXEC [dbo].[p_process_inmate_data_new_v1] 
		@AmtelFacilityID,		@InmateID	,		@PIN	,		@firstName	,		@lastName	,		@MidName	,		'',		'',		'U',		0,		'',		'',		@location,		@cell,		1 ;


