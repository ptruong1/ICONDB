
CREATE PROCEDURE [dbo].[p_get_InmateReleaseDate]
@PIN  varchar(12),
@facilityID	int ,
@ReleaseDate  datetime OUTPUT

 AS
Declare  @ls_ReleaseDate varchar(14)
SET  @ls_ReleaseDate =''
SELECT   @ls_ReleaseDate	= ReleaseDate 	   From  tblInmateUpdate   where   PIN =  @PIN  AND  ReleaseDate <> '' and ReleaseDate is not null
If (  len(@ls_ReleaseDate)  < 5 ) 
 begin
	SET @ReleaseDate   =  Convert (datetime,'1/1/1990')
	Return -1
 end
Else  
	SET @ReleaseDate   =  CONVERT (datetime ,   @ls_ReleaseDate)
RETURN 0
