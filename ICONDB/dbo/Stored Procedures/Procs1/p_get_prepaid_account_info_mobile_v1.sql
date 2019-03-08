

CREATE PROCEDURE [dbo].[p_get_prepaid_account_info_mobile_v1]
@AccountNo varchar(18)
AS

	
Begin
	SELECT   
				@AccountNo as AccountNo,
				tblPrepaid.FirstName,
				tblPrepaid.LastName,
				 tblPrepaid.Address, 
				 tblPrepaid.City, 
				 tblStates.StateName,
				 tblPrepaid.ZipCode,
				 tblCountryCode.CountryName,
				  tblPrepaid.Balance,
				  tblPrepaid.Status,				  		      
				  (CASE When tblEndUsers.Email like '%noemail%' Then 'Invalid Email' When tblEndUsers.Email='' then 'Invalid Email'  Else   tblEndUsers.Email END) as Email,
				  (tblFacility.Location +  ', '	+  tblFacility.city + ', ' + tblfacility.State + ' ' + tblfacility.Zipcode) as Facility         
		        
	FROM            tblPrepaid   with(nolock)                         
				 
				 INNER JOIN tblFacility  with(nolock)   On tblPrepaid.FacilityID = tblFacility.FacilityID 
				  INNER JOIN tblEndUsers with(nolock)  On tblPrepaid.PhoneNo =  tblEndUsers.UserName
				  INNER JOIN tblCountryCode with(nolock)  On tblPrepaid.CountryID =  tblCountryCode.CountryID
			      INNER JOIN tblStates  with(nolock)   On tblPrepaid.StateID = tblStates.StateID
	WHERE  tblPrepaid.PhoneNo =@AccountNo;


end
