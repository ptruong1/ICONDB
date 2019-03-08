
CREATE PROCEDURE [dbo].[p_create_wu_inputFileName] 
@filename  varchar(14)  OUTPUT
AS
Declare  @N tinyint , @CC char(2) , @X char(1), @DDD char(3) ,@createDate  varchar(10) , @L char(1)
SET @filename =''
SET @CC = 'LG' 
SET @X = 'I'
SET @DDD = dbo.fn_getJulianDate (getdate())
SET @createDate = convert(varchar(10), getdate(),112) 
SET @N =0
select @filename = WUfileName  from tblWuinputfiles with(nolock)  where  createDate = @createDate 
--select  @filename 
If( @filename ='' )
 Begin
	
	SET @L= 'A'
	SET @N = '1'
 End
Else
 Begin
	SET @N = cast ( right ( @filename ,1)  as tinyint)
	
	SET @N  = @N + 1
	SET @L =  substring(@filename ,7,1)
	If ( @N >9 ) 
	  Begin
		If @L = 'A'   SET @L ='B'
		Else If  @L = 'B'   SET @L ='C'
		Else If  @L = 'C'   SET @L ='D'
		Else If  @L = 'D'   SET @L ='E'
	  End
	
	
 End

SET  @filename =  @CC  +  @X + @DDD + @L + Cast (@N as char)
--select  @filename
Insert tblWUinputfiles(WUfileName, CreateDate ) values( @filename,@createDate )
