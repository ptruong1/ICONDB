
CREATE PROCEDURE [dbo].[p_update_prepaid_account_info]
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
if (@FirstName='' or @FirstName='ICON Transfer' Or @LastName='For Prepaid')
	SET @RelationshipID  = 99;

if(@FacilityID > 0)
 begin
	update     tblPrepaid  set   FacilityID  = @FacilityID,
	   		  tblPrepaid.FirstName = @firstName ,
	    		 tblPrepaid.LastName  =  @lastName,
	     		 tblPrepaid.Address  =  @Address , 
                 		 tblPrepaid.City =  @city , 
	    		tblPrepaid.State  = @State,
	      		 tblPrepaid.ZipCode  = @zipcode,
	      		 tblPrepaid.RelationShipID = @relationShipID  ,
	       		tblPrepaid.Status = @status ,
			 InmateName  =     @inmateName 
	WHERE  tblPrepaid.PhoneNo = @PhoneNo
 end
else
 begin
	 update tblPrepaid  set  
	   		  tblPrepaid.FirstName = @firstName ,
	    		 tblPrepaid.LastName  =  @lastName,
	     		 tblPrepaid.Address  =  @Address , 
                 		 tblPrepaid.City =  @city , 
	    		tblPrepaid.State  = @State,
	      		 tblPrepaid.ZipCode  = @zipcode,
	      		 tblPrepaid.RelationShipID = @relationShipID  ,
	       		tblPrepaid.Status = @status ,
			 InmateName  =     @inmateName 
	WHERE  tblPrepaid.PhoneNo = @PhoneNo
 end
update  tblEndUsers  set  Email = @email    where Username = @PhoneNo

