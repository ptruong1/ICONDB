
CREATE PROCEDURE [dbo].[p_validate_free_call]
@facilityID	int,
@ToNo		char(10)
 AS
Declare  @ANI  char(10) , @FNPANXX  char(6), @TNPANXX char(6) 
Select   @ANI  = Phone  from  tblfacility with(nolock) where facilityID = @facilityID

SET @FNPANXX = left(@ANI ,6) 
SET @TNPANXX  =  left(@ToNo,6) 

If(select count(*) from tblFreePhones with (nolock) where facilityID = @facilityID and phoneNo = @ToNo ) >0
	Return 0

if ( dbo.fn_determine_local_call (@FNPANXX,   @TNPANXX ) )   = 0
	Return -1

else
	Return 0

