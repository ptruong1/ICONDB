

CREATE PROCEDURE [dbo].[sp_get_local_time]
@npa	char(3),
@nxx	char(3),
@localTime	varchar(8)  OUTPUT
 AS

Declare  @ZoneCode	char(1)  , @GMT  smallint, @AMT   smallint, @hh smallint, @mm smallint, @ss  smallint, @state  char(2)

SELECT  @ZoneCode  =TZONE, @state = state  FROM   tblTPM  WITH(NOLOCK)   WHERE  npa = @npa  AND  nxx = @nxx
SELECT  @GMT = GMT  ,  @AMT  = AMT  FROM tblTPMZone	WITH(NOLOCK)  WHERE  zoneCode =  @ZoneCode


IF(@state = 'AZ'  OR @state = 'HI' OR @state = 'PR'  Or @state='AK')
Begin
	SET @hh  =  datepart(hh, getUTCdate())
	SET  @mm = datepart(mi,  getUTCdate())
	SET  @ss  = datepart(ss,  getUTCdate())
	
	SET @hh =  @hh  + @GMT 
	If(@hh <0)  SET  @hh = @hh  +24 
	SET  @localTime =  CAST (  @hh  as varchar(2)) + ':' + CAST(@mm as varchar(2) ) + ':'  + CAST(@ss as varchar(2))
	
	
End
Else
begin
	SET @hh  =  datepart(hh, getdate())
	SET  @mm = datepart(mi, getdate())
	SET  @ss  = datepart(ss, getdate())
	
	SET @hh =  @hh  + @AMT
	
	SET  @localTime =  CAST (  @hh  as varchar(2)) + ':' + CAST(@mm as varchar(2) ) + ':'  + CAST(@ss as varchar(2))
	
	
End

SET @localTime =  ISNULL( @localTime, 'Unknown')
If (@localTime = 'Unknown'  )  SET @hh  =  datepart(hh, getdate())
return  @hh

