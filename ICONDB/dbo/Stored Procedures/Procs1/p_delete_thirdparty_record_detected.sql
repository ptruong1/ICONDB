-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_delete_thirdparty_record_detected]
		@RecordID	bigint,
	   @FacilityID int
      
      
AS
BEGIN

DELETE FROM [tblThirdPartyDectectRecord]
 WHERE 
	  RecordID = @RecordID
      and FacilityID=@FacilityID
   
END

