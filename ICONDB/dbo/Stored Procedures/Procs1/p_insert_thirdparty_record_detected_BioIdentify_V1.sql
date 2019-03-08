-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_thirdparty_record_detected_BioIdentify_V1]
	@UserId	varchar(16),
	@fileName varchar(50),
    @Confidence		varchar(10),
	@ProfileId varchar(50)
AS

declare @facilityId int, @recordId as bigint, @suspicious varchar(30), @InmateId varchar(12)

set @facilityId = cast(LEFT(@UserId,CHARINDEX('-', @UserId)-1) as int)
set @RecordId = cast(LEFT(@fileName,CHARINDEX('_', @fileName)-1) as bigint)
set @suspicious = (select userId from  tblBioMetricProfileOxfordIdentification where ProfileId = @ProfileId)
Set @InmateID = LTRIM(RIGHT(@suspicious,LEN(@suspicious) - CHARINDEX('-',@suspicious) ))
BEGIN

if (select count(*) from tblThirdPartyDectectRecord_Test where recordId = @RecordId) = 0	
	INSERT INTO [tblThirdPartyDectectRecord_Test]
		  ([RecordID],[FacilityID],[FromNo],[ToNo],[RecodDate],[Duration],[CallType],[BillType],[DetectType],[PIN],DetectTime,Score, ConfidenceNote)
	select  RecordID, FacilityID, FromNo, ToNo, RecordDate, Duration, CallType, BillType, 3, PIN, GETDATE(), 0, (@InmateID + '/' + @Confidence)
		   from tblcallsbilled 
		   where  recordId = @recordId
    
END

