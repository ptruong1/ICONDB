
CREATE PROCEDURE [dbo].[p_search_prepaid_account]
@FacilityID	int,
@accountNo	varchar(10)  --- phone number
 AS
 if(@FacilityID > 0)
	select  PhoneNo ,  FirstName , LastName  , Address ,  City,State, ZipCode ,  status  from   
		tblPrepaid with(nolock)  where  phoneNo  like @accountNo + '%' and FacilityID = @FacilityID;
 else
	select  PhoneNo ,  FirstName , LastName  , Address ,  City,State, ZipCode ,  status  from   
		tblPrepaid with(nolock)  where  phoneNo  like @accountNo + '%';

