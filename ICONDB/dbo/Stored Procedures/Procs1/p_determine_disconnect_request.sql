CREATE PROCEDURE [dbo].[p_determine_disconnect_request]
@RecordID	bigint

AS

If (select count(*) from  tblUserDisconnectCall with(nolock) where recordID = RecordID) > 0
	Return 1
else 
	Return 0
