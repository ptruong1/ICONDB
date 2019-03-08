-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_thirdparty_record_detected]
		@RecordID	bigint,
	   @FacilityID int,
       @FromNo varchar(10),
       @ToNo	varchar(18),
       @RecodDate datetime,
       @Duration	int,
       @CallType	char(2),
       @BillType	char(2),
       @DetectType	tinyint,
       @PIN			varchar(12),
       @Score		smallint
AS
BEGIN

--if(@Score <=-230) 
--  SET @DetectType =6;
--else if (@Score < -180 and @Score > -230) 
--  SET @DetectType =2;
--else
--  SET @DetectType =3;
	
INSERT INTO [leg_Icon].[dbo].[tblThirdPartyDectectRecord]
	  ([RecordID]
      ,[FacilityID]
      ,[FromNo]
      ,[ToNo]
      ,[RecordDate]
      ,[Duration]
      ,[CallType]
      ,[BillType]
      ,[DetectType]
      ,[PIN]
      ,DetectTime
      ,Score)
      values
      (@RecordID	,
	   @FacilityID ,
       @FromNo ,
       @ToNo	,
       @RecodDate,
       @Duration	,
       @CallType	,
       @BillType	,
       @DetectType	,
       @PIN			,
       GETDATE(),
       @Score);
    
END

