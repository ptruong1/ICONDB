

CREATE PROCEDURE [dbo].[sp_validate_callingCard]
@AccountNo char(14)
 AS
Declare   @NPA  char(3), @NXX  char(3),  @billToNo  char(10) , @pinNo char(4),  @NXXType  varchar(2) ,  @i smallint;
SET @billToNo  = left(@AccountNo ,10);
SET @pinNo  = right(@AccountNo ,4);
SET @NPA = LEFT(@billToNo,3);
SET  @NXX = Substring(@billToNo,4,3);
SET @NXXType = '';

if (isnumeric(@AccountNo) = 0) return -1


If( convert ( int,  @pinNo ) > 2000) 
	return 1;
else
	return -1;

