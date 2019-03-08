

CREATE PROCEDURE [dbo].[p_get_local_time]
@npa	char(3),
@nxx	char(3),
@localTime	datetime  OUTPUT
 AS

Declare  @ZoneCode	char(1)  , @GMT  smallint, @AMT   smallint, @hh smallint, @mm smallint, @ss  smallint, @state  char(2), @localhh smallint;

SELECT  @ZoneCode  =TZONE, @state = state  FROM   tblTPM  WITH(NOLOCK)   WHERE  npa = @npa  AND  nxx = @nxx;

SELECT  @GMT = GMT  ,  @AMT  = AMT  FROM tblTPMZone	WITH(NOLOCK)  WHERE  zoneCode =  @ZoneCode;


IF(@state = 'AZ'  OR @state = 'HI' OR @state = 'PR'  Or @state='AK')
 Begin
	SET @hh  =  datepart(hh, getUTCdate());
	SET  @mm = datepart(mi,  getUTCdate());
	SET  @ss  = datepart(ss,  getUTCdate());
	
	SET @localhh =  @hh  + @GMT ;
	If(@hh <0)  SET  @localhh= @hh  +24 ;
	
	
	
 End
Else
 begin
	SET @hh  =  datepart(hh, getdate());
	SET  @mm = datepart(mi, getdate());
	SET  @ss  = datepart(ss, getdate());
	
	SET @localhh =  @hh  + @AMT;
End
SET @hh  =  datepart(hh, getdate());
SET  @localTime =  dateadd(hh,  @localhh-@hh  , getdate());

