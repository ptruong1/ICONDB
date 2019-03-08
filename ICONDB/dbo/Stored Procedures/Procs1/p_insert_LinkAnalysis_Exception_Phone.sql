


CREATE PROCEDURE [dbo].[p_insert_LinkAnalysis_Exception_Phone]
(
	@FacilityID int,
	@ANINo varchar(14),
	@userID varchar(25),
	@userIP  varchar(16)
)
AS
	SET NOCOUNT OFF;

INSERT INTO [dbo].[tblLinkAnalysys_Phone_Exceptions]
           ([facilityId]
           ,[ANINo]
           ,[UserName]
		  ,[ModifiedDate])
	VALUES
           (@facilityId
           ,@ANINo
           ,@userID
           ,GETDATE())

declare  @UserAction varchar(100), @ActTime datetime      
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
SET  @UserAction =  'Remove Destination Number ' + @ANINo + ' from the data link';
EXEC  INSERT_ActivityLogs3	@FacilityID ,45,@ActTime ,0,@userID ,@userIP, @ANINo,@UserAction ; 

