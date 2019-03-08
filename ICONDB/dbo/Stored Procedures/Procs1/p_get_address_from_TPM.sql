
CREATE PROCEDURE [dbo].[p_get_address_from_TPM]
@billtono  char(10),
@firstName varchar(25)  OUTPUT,
@lastName Varchar(25)  OUTPUT,
@Address	varchar(150) OUTPUT,
@City		varchar(25)  OUTPUT,
@State		varchar(2)  OUTPUT,
@Zipcode	varchar(9)  OUTPUT
AS
SET nocount on
SET  @firstName  ='';
SET @lastName  ='';
SET @Address	 ='';
SET  @City		 ='';
SET @State		 ='';
SET @Zipcode	 ='';

select  @firstName= '', @lastName=  '',  @Address = '' , @City = [Place Name], @State =[state] , @Zipcode= ''     from tblTPM  with(nolock) where NPA =left(@billtono,3)  and  NXX = SUBSTRING (@billtono,4,3) ;


Return @@error;


