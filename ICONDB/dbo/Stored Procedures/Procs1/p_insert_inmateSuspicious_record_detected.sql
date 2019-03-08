-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_inmateSuspicious_record_detected]
	   @RecordID	bigint,
	   @FacilityID int,
       @Duration	int,
       @DetectType	tinyint,
       @PIN			varchar(12),
       @Scores		smallint,
	   @InputTime		datetime,
	   @ThirdParty1  varchar(50),
	   @ThirdParty2  varchar(50),
	   @ThirdParty3  varchar(50)
AS
BEGIN

--if(@Score <=-230) 
--  SET @DetectType =6;
--else if (@Score < -180 and @Score > -230) 
--  SET @DetectType =2;
--else
--  SET @DetectType =3;
	
INSERT INTO [leg_Icon].[dbo].[tblInmateSuspiciousDectectRecord]
	  ([RecordID]
      ,[FacilityID]
      ,[FromNo]
      ,[ToNo]
      ,[RecodDate]
      ,[Duration]
      ,[CallType]
      ,[BillType]
      ,[DetectType]
      ,[PIN]
      ,DetectTime
      ,Score
	  ,ThirdParty1
	  ,ThirdParty2
	  ,ThirdParty3)
      values
      (@RecordID	,
	   @FacilityID ,
       (select P.fromNo from tblCallsBilled P  with(nolock)  where P. facilityID = @facilityID and P.RecordID = @RecordID),
       (select P.ToNo from tblCallsBilled P  with(nolock)  where P. facilityID = @facilityID and P.RecordID = @RecordID),
       (select P.RecordDate from tblCallsBilled P  with(nolock)  where P. facilityID = @facilityID and P.RecordID = @RecordID),
       @Duration	,
       (select P.CallType from tblCallsBilled P  with(nolock)  where P. facilityID = @facilityID and P.RecordID = @RecordID),
       (select P.BillType from tblCallsBilled P  with(nolock)  where P. facilityID = @facilityID and P.RecordID = @RecordID),
       @DetectType	,
       @PIN			,
       GETDATE(),
       @Scores,
	   @ThirdParty1,
	   @ThirdParty2,
	   @ThirdParty3);
    
END

