
CREATE PROCEDURE [dbo].[p_insert_ATA_status_detail]
@ATAIP       varchar(16),
@Status	tinyint,
 @ResonseTime  smallint
AS

Update tblFacilityATAinfo set status =@Status  where ATAIP = @ATAIP 

INSERT  tblATAstatusDetail ( ATAIP   , Status, ResonseTime ) values(@ATAIP ,   @Status, @ResonseTime)

