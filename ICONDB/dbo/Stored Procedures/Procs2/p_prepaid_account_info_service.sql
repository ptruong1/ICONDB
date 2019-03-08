
CREATE PROCEDURE [dbo].[p_prepaid_account_info_service]
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
@countryName	varchar(30) OUTPUT

AS
SET NOCOUNT ON;
SET @FacilityID =0
SET @facilityName =''
SET @firstName =''
SET @lastName =''
SET @Address=''
SET @city = ''
SET @state =''
SET @zipcode	=''
SET @email  =''
SET @relationShip =''
SET @balance =0
SET @status =0
SET @inmateName =''
SET @countryName = ''
If (@countryCode <> '' and  @countryCode is not null) 
	SELECT    @FacilityID = F.FacilityID,
		    @facilityName =  F.Location  ,
		    @firstName =P.FirstName,
		    @lastName =P.LastName,
		     @Address=  P.Address, 
	                  @city	=  P.City, 
		     @state	 = P.State,
		     @zipcode =P.ZipCode,
	                   @balance   = P.Balance,
		      @relationShip =R.Descript ,
		      @status= P.Status,
		        @email   =isnull(P.Email,''),
		         @inmateName =  P.InmateName ,
		         @countryName = P.Country
	FROM            tblPrepaidService P   with(nolock)                           
			 INNER JOIN tblRelationShip  R with(nolock)  ON P.RelationshipID = R.RelationshipID 
			INNER JOIN tblFacilityService  F with(nolock)   On P.FacilityID = F.FacilityID 
			
	WHERE P.PhoneNo = @PhoneNo  and countryCode =@countryCode	
else
	SELECT    @FacilityID =  F.FacilityID,
		    @facilityName =  F.Location  ,
		    @firstName = P.FirstName,
		    @lastName = P.LastName,
		     @Address=  P.Address, 
	                  @city	=  P.City, 
		     @state	 = P.State,
		     @zipcode = P.ZipCode,
	                   @balance   =P.Balance,
		      @relationShip =R.Descript ,
		      @status= P.Status,
		        @email   =isnull(P.Email,''),
		         @inmateName =  P .InmateName 
                                   
	FROM            tblPrepaidService  P  with(nolock)                           
			 INNER JOIN tblRelationShip R with(nolock)  ON P.RelationshipID = R.RelationshipID 
			 INNER JOIN tblFacilityService F  with(nolock)   On P.FacilityID = F.FacilityID 
			 
	WHERE  P.PhoneNo = @PhoneNo

