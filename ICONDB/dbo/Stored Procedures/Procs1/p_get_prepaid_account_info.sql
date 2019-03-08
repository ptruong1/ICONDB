

CREATE PROCEDURE [dbo].[p_get_prepaid_account_info]
@PhoneNo varchar(18)
AS

DECLARE @countryCode	varchar(3),@FacilityID	int ,@CalledNo varchar(15), @AccountNo varchar(12);
		
SET @FacilityID =0;

SET @countryCode = '';
if(left(@PhoneNo,3) = '011')
 begin
	SET @CalledNo = RIGHT(@PhoneNo,LEN(@PhoneNo) -3);
	SET @countryCode = dbo.fn_get_countryCode(@CalledNo);
	SET @AccountNo = RIGHT(@CalledNo, LEN(@CalledNo) - LEN(@countryCode));
 end
Else
 begin
	if(	LEN(@PhoneNo) >12)
	 begin
		SET @countryCode = dbo.fn_get_countryCode(@PhoneNo);
		SET @AccountNo = RIGHT(@PhoneNo, LEN(@PhoneNo) - LEN(@countryCode));
	--select 	 @AccountNo, @countryCode 
	 end
	else
		SET @AccountNo = @PhoneNo ;
 end
 
If (@countryCode <> '' and  @countryCode is not null) 
	SELECT   tblFacility.FacilityID,
		    --tblFacility.Location  as facilityName ,
		    tblPrepaid.FirstName,
		    tblPrepaid.LastName,
		     tblPrepaid.Address, 
	         tblPrepaid.City, 
		     tblPrepaid.StateID,
		     tblPrepaid.ZipCode,
	          tblPrepaid.Balance,
		      tblRelationShip.RelationshipID ,
		      tblPrepaid.Status,
		      -- tblEndUsers.Email,
		      (CASE When tblEndUsers.Email like '%noemail%' Then 'Invalid Email' When tblEndUsers.Email='' then 'Invalid Email'  Else   tblEndUsers.Email END) as Email,
		       tblPrepaid.InmateName ,		         
		         tblEndusers.password ,
		         CountryID
		         -- tblPWSecurityQ.Question as SecurityQ,
		          --isnull(tblEndusers.SecurityA,'NA') as SecurityA,
		           --tblPWSecurityQ.QuestionID
	FROM            tblPrepaid   with(nolock)                           
			 INNER JOIN tblRelationShip with(nolock)  ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID 
			 INNER JOIN tblFacility  with(nolock)   On tblPrepaid.FacilityID = tblFacility.FacilityID 
			  INNER JOIN tblEndUsers with(nolock)  On tblPrepaid.PhoneNo =  tblEndUsers.UserName
			   --INNER JOIN tblPWSecurityQ with(nolock)  On  tblEndUsers.SecurityQ = tblPWSecurityQ.QuestionID 
	WHERE  tblPrepaid.PhoneNo =@AccountNo  and countryCode =@countryCode ;	
else
	SELECT   tblFacility.FacilityID,
		    --tblFacility.Location  as facilityName ,
		    tblPrepaid.FirstName,
		    tblPrepaid.LastName,
		     tblPrepaid.Address, 
	         tblPrepaid.City, 
		     tblPrepaid.StateID,
		     tblPrepaid.ZipCode,
	          tblPrepaid.Balance,
		      tblRelationShip.RelationshipID ,
		      tblPrepaid.Status,
		      -- tblEndUsers.Email,
		      (CASE When tblEndUsers.Email like '%noemail%' Then 'Invalid Email' When tblEndUsers.Email='' then 'Invalid Email'  Else   tblEndUsers.Email END) as Email,
		       tblPrepaid.InmateName ,		         
		         tblEndusers.password ,
		         CountryID 
		         -- tblPWSecurityQ.Question as SecurityQ,
		          --isnull(tblEndusers.SecurityA,'NA') as SecurityA,
		          -- tblPWSecurityQ.QuestionID
	FROM            tblPrepaid   with(nolock)                           
			 INNER JOIN tblRelationShip with(nolock)  ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID 
			 INNER JOIN tblFacility  with(nolock)   On tblPrepaid.FacilityID = tblFacility.FacilityID 
			  INNER JOIN tblEndUsers with(nolock)  On tblPrepaid.PhoneNo =  tblEndUsers.UserName
			--   INNER JOIN tblPWSecurityQ with(nolock)  On  tblEndUsers.SecurityQ = tblPWSecurityQ.QuestionID 
	WHERE  tblPrepaid.PhoneNo = @AccountNo ; 
	


