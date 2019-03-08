
CREATE PROCEDURE [dbo].[p_determine_canada_call]
@billtono char(10)
 AS


if (select count(*)  from tblTPM with(nolock)   where npa=  left(@billtono,3) and [point ID] ='2' ) > 0 
	return 1
else
	return 0

