
CREATE PROCEDURE [dbo].[p_get_InmateCourtInfo]
@PIN  varchar(12),
@facilityID	int ,
@COURT 	varchar(30) OUTPUT,
@ApperanceDate  DATETIME  OUTPUT

as
Declare @courtdate varchar(30) 
SET  @COURT =''
SET  @courtdate =''


SELECT    @COURT 	=COURT,  @courtdate   = ApperanceDate     From  tblInmateBookInfo   where   PIN =  @PIN  AND   len(ApperanceDate) >=10;


IF (@courtdate=''  Or  @COURT ='' )  
 Begin
	SET @ApperanceDate= '1/1/1999';
	 RETURN -1;
 End
ELSE  
 Begin
	SET @ApperanceDate=   convert (datetime, @courtdate);
	RETURN 0;

 End

