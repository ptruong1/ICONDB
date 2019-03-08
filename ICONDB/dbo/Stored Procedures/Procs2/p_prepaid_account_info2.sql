
CREATE PROCEDURE [dbo].[p_prepaid_account_info2]
@PhoneNo varchar(10),
@countryCode	varchar(3),
@FacilityID	int OUTPUT,
@facilityName	varchar(50) OUTPUT,
@firstName	varchar(25) OUTPUT,
@lastName	varchar(25) OUTPUT,
@Address	varchar(75) output,
@city		varchar(20) OUTPUT,
@state		char(2) OUTPUT,
@zipcode	varchar(10) OUTPUT,
@email               varchar(50) OUTPUT,
@relationShip	varchar(30) OUTPUT,
@balance	numeric(7,2) OUTPUT,
@status		tinyint  OUTPUT,
@inmateName	varchar(50) OUTPUT,
@countryName	varchar(30) OUTPUT,
@password	varchar(20) OUTPUT,
@SecurityQ	varchar(150)  OUTPUT,
@SecurityA	varchar(100) OUTPUT,
@SecurityID	tinyint OUTPUT

AS
SET NOCOUNT ON;
SET @FacilityID =0;
SET @facilityName ='';
SET @firstName ='';
SET @lastName ='';
SET @Address='';
SET @city = '';
SET @state ='';
SET @zipcode	='';
SET @email  ='';
SET @relationShip ='';
SET @balance =0;
SET @status =0;
SET @inmateName ='';
SET @countryName = '';
If (@countryCode <> '' and  @countryCode is not null) 
	SELECT    @FacilityID = tblFacility.FacilityID,
		    @facilityName =  tblFacility.Location  ,
		    @firstName = tblPrepaid.FirstName,
		    @lastName = tblPrepaid.LastName,
		     @Address=  tblPrepaid.Address, 
	                  @city	=  tblPrepaid.City, 
		     @state	 = tblPrepaid.State,
		     @zipcode = tblPrepaid.ZipCode,
	                   @balance   = tblPrepaid.Balance,
		      @relationShip =tblRelationShip.Descript ,
		      @status= tblPrepaid.Status,
		        --@email   = tblEndUsers.Email,
		        @email=(CASE When tblEndUsers.Email like '%noemail%' Then 'Invalid Email' When tblEndUsers.Email='' then 'Invalid Email'  Else   tblEndUsers.Email END) ,
		         @inmateName =  tblPrepaid .InmateName ,
		         @countryName = Country,
		          @password   = tblEndusers.password ,
		          @SecurityQ  = tblPWSecurityQ.Question,
		           @SecurityA = isnull(tblEndusers.SecurityA,'NA'),
		            @SecurityID	=  tblPWSecurityQ.QuestionID
	FROM            tblPrepaid   with(nolock)                           
			 INNER JOIN tblRelationShip with(nolock)  ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID 
			 INNER JOIN tblFacility  with(nolock)   On tblPrepaid.FacilityID = tblFacility.FacilityID 
			  INNER JOIN tblEndUsers with(nolock)  On tblPrepaid.PhoneNo =  tblEndUsers.UserName
			   INNER JOIN tblPWSecurityQ with(nolock)  On  tblEndUsers.SecurityQ = tblPWSecurityQ.QuestionID 
	WHERE  tblPrepaid.PhoneNo = @PhoneNo  and countryCode =@countryCode	;
else
	SELECT    @FacilityID = tblFacility.FacilityID,
		    @facilityName =  tblFacility.Location  ,
		    @firstName = tblPrepaid.FirstName,
		    @lastName = tblPrepaid.LastName,
		     @Address=  tblPrepaid.Address, 
	                  @city	=  tblPrepaid.City, 
		     @state	 = tblPrepaid.State,
		     @zipcode = tblPrepaid.ZipCode,
	                   @balance   = tblPrepaid.Balance,
		      @relationShip =tblRelationShip.Descript ,
		      @status= tblPrepaid.Status,
		       -- @email   = tblEndUsers.Email,
		        @email=(CASE When tblEndUsers.Email like '%noemail%' Then 'Invalid Email' When tblEndUsers.Email='' then 'Invalid Email'  Else   tblEndUsers.Email END) ,
		         @inmateName =  tblPrepaid .InmateName,
		          @password   = tblEndusers.password ,
		          @SecurityQ  = tblPWSecurityQ.Question,
		           @SecurityA =  isnull(tblEndusers.SecurityA,'NA'),
                                        @SecurityID	=  tblPWSecurityQ.QuestionID
	FROM            tblPrepaid   with(nolock)                           
			 INNER JOIN tblRelationShip with(nolock)  ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID 
			 INNER JOIN tblFacility  with(nolock)   On tblPrepaid.FacilityID = tblFacility.FacilityID 
			  INNER JOIN tblEndUsers with(nolock)  On tblPrepaid.PhoneNo =  tblEndUsers.UserName
			   INNER JOIN tblPWSecurityQ with(nolock)  On  tblEndUsers.SecurityQ = tblPWSecurityQ.QuestionID 
	WHERE  tblPrepaid.PhoneNo = @PhoneNo;
