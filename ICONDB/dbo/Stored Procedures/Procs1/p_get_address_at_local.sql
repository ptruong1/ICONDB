
CREATE PROCEDURE [dbo].[p_get_address_at_local]
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

select  @firstName= FirstName , @lastName=  LastName,  @Address = [Address] , @City = City, @State =state , @Zipcode= ZipCode     from tblprepaid  with(nolock) where Phoneno = @billtono  and FirstName <>'ICON Transfer' ;

If (@Address ='' or @Address is null)
	SELECT @firstName= FirstName , @lastName=  LastName,  @Address = [Address1] , @City = City, @State =state , @Zipcode= ZipCode     from  Tecodata.dbo.tblCLECEndUser with (nolock) where BillToNo = @billtono  and LastName <> 'NotFound' and Address1 is not null ;

Return @@error;

