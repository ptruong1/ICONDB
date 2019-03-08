﻿CREATE FUNCTION [dbo].[fnSplitString] 
( 
@string NVARCHAR(1000), 
@delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata NVARCHAR(1000) 
) 
BEGIN 
	SET @string=REPLACE(@string,'(,)','$$');
	DECLARE @start INT, @end INT;
	SELECT @start = 1, @end = CHARINDEX(@delimiter, @string);
	WHILE @start < LEN(@string) + 1
	 BEGIN 
		IF @end = 0 
			SET @end = LEN(@string) + 1 ;

		INSERT INTO @output (splitdata) 
		VALUES(REPLACE(SUBSTRING(@string, @start, @end - @start),'$$','(,)')) ;
		SET @start = @end + 1 ;
		SET @end = CHARINDEX(@delimiter, @string, @start) ;

	 END 
	RETURN;
END 