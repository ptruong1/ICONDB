

CREATE PROCEDURE [dbo].[p_Update_Facility_OfficeMessage]
(
			@FacilityID int
		   ,@MessageID int
           ,@Message varchar(500)
           ,@PostBy varchar(25)
           ,@ModifyBy varchar(25)
           ,@PostDate datetime
           ,@ModifyDate datetime
           ,@FromDate datetime
           ,@ToDate datetime
)
AS
	SET NOCOUNT OFF;
UPDATE [leg_Icon].[dbo].[tblFacilityOfficeMessage]
   SET [FacilityID] = @FacilityID
      ,[Message] = @Message
      ,[ModifyBy] = @ModifyBy
      ,[ModifyDate] = @ModifyDate
      ,[FromDate] = @FromDate
      ,[ToDate] = @ToDate
      
      where facilityID = @FacilityID and
      messageID = @MessageID

