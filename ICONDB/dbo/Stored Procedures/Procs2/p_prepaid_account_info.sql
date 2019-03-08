
CREATE PROCEDURE [dbo].[p_prepaid_account_info]
@PhoneNo char(10),
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
@inmateName	varchar(50) OUTPUT

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
	        @email   = tblEndUsers.Email,
	         @inmateName =  tblPrepaid .InmateName 
FROM            tblPrepaid   with(nolock)                           
		 INNER JOIN tblRelationShip with(nolock)  ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID 
		 INNER JOIN tblFacility  with(nolock)   On tblPrepaid.FacilityID = tblFacility.FacilityID 
		  INNER JOIN tblEndUsers with(nolock)  On tblPrepaid.PhoneNo =  tblEndUsers.UserName
WHERE  tblPrepaid.PhoneNo = @PhoneNo;

