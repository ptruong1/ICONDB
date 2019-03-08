
CREATE PROCEDURE [dbo].[p_update_prepaid_account_info_service]
@PhoneNo char(10),
@FacilityID	int ,
@firstName	varchar(25),
@lastName	varchar(25),
@Address	varchar(75) ,
@city		varchar(20) ,
@state		char(2),
@zipcode	varchar(10) ,
@email               varchar(50) ,
@RelationshipID  int , 
@status		tinyint  ,
@inmateName  varchar (50)   

AS

SET NOCOUNT ON;

update     tblPrepaidService  set   FacilityID  = @FacilityID,
	   	 FirstName = @firstName ,
	    	LastName  =  @lastName,
	     	Address  =  @Address , 
                 	 City =  @city , 
	    	State  = @State,
	      	 ZipCode  = @zipcode,
                            email = @email  ,
	      	RelationShipID = @relationShipID  ,
	       	Status = @status ,
		 InmateName  =     @inmateName 
WHERE  PhoneNo = @PhoneNo

