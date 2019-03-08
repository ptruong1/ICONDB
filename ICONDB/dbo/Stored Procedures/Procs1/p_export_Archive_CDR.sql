
CREATE PROCEDURE [dbo].[p_export_Archive_CDR]
@FacilityID int,
@fromDate date,
@toDate	  date

 AS

Declare   @AccountNo	char(10), @Amount numeric(7,2) ,  @currentDate  datetime , @LastDate datetime, @YYYY  int , @MM smallint ,  @HH smallint , @Mi  smallint ,@dd smallint, @FileName  varchar(30) , @file_dir  varchar(30),
	 @s_MM  char(2), @s_HH char(2), @s_Mi  char(2), @s_YYYY char(4) ,@cmd varchar(1000), @s_dd char(2), @RevPeriod char(4) ;

--SET  @currentDate = getDate();
SET  @YYYY = datepart( YYYY, @fromDate);
SET  @s_YYYY = CAST(@YYYY as char(4));
SET   @MM = datepart(MM,@fromDate);
If(  @MM < 10) 
	SET @s_MM = '0' + CAST( @MM as char(1));
Else  
	SET @s_MM = CAST(@MM  as char(2));
/*
SET   @dd = datepart(d,@currentDate);
If(  @dd < 10) 
	SET @s_dd = '0' + CAST( @dd as char(1));
Else  
	SET @s_dd = CAST(@dd  as char(2));

SET @HH =  datepart(HH, @currentDate);
If(  @HH < 10) 
	SET @s_HH = '0' + CAST(@HH as char(1))
Else  
	SET @s_HH = CAST(@HH  as char(2))

SET  @Mi =   datepart(Mi,@currentDate);

If(  @Mi  < 10) 
	SET @s_Mi = '0' + CAST(@Mi as char(1));
Else  
	SET @s_Mi = CAST(@Mi  as char(2));
*/
SET @RevPeriod  = right(convert (varchar(6), @fromDate, 112),4) ;

truncate table [dbo].[tblCDRTemp]


SET @FileName = 'CDR'  +   @s_YYYY +  @s_MM +    '.txt'

SET  @file_dir = 'C:\CDR\'

exec [dbo].[p_get_mass_CDR] @FacilityID ,@fromDate,@toDate	 

  SET @cmd = 'bcp  leg_Icon.dbo.tblCDR OUT  '  +  @file_dir  + @FileName  +     ' -t "|" -c   -S172.77.10.10  -Usa -PTianhmi11082001   ' ;

 -- select * from  [dbo].[##tblCDR] ;

 --select  @cmd;

EXEC  master.dbo.xp_cmdshell   @cmd


--SET @cmd ='Copy C:\CDR\'+ @FileName + '  \\172.77.40.10\PraeseFTP\' + @FileName + ' /y';
--	--print @cmd ;
--EXEC  master.dbo.xp_cmdshell   @cmd ;


return @@error
