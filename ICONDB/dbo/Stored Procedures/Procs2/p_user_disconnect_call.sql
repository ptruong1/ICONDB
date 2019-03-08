CREATE PROCEDURE [dbo].[p_user_disconnect_call] 
@RecordID      bigint,
@CallDateTime	varchar(30),
@StationID  	varchar(10)   ,
@ToNo    	varchar(10),   
@PIN     	varchar(12),
@FacilityID 	int,
@Channel	smallint,
@ACP             varchar(17),  --- ACP IP address
@UserName      varchar(25)

AS

Insert tblUserDisconnectCall( RecordID  ,  CallDateTime, StationID ,    ToNo   ,    PIN ,         FacilityID , Channel ,ACP ,         UserName   )
values(       @RecordID ,    @CallDateTime,  @StationID, @ToNo, @PIN, @FacilityID, @Channel, @ACP, @UserName)
