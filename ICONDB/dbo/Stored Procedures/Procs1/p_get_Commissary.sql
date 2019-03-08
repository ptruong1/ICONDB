
CREATE PROCEDURE [dbo].[p_get_Commissary]
@facilityID	int,
@CommissaryPhone varchar(10)  OUTPUT,
@CommissaryIP		varchar(20) OUTPUT
AS

SET  @CommissaryPhone  =''
SET  @CommissaryIP =''
select @CommissaryPhone=   CommissaryPhone,@CommissaryIP =  CommissaryIP  from tblCommissary  where facilityId  = @facilityID 
--if(@CommissaryPhone='')
	--select @CommissaryPhone=   CommissaryPhone,@CommissaryIP =  CommissaryIP  from tblCommissary  where facilityId  =499
