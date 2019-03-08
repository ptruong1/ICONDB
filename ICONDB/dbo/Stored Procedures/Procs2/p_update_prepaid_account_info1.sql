
CREATE PROCEDURE [dbo].[p_update_prepaid_account_info1]
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
@inmateName  varchar (50)   ,
@password	varchar(20),
@QuestionID	tinyint,
@SecurityA	varchar(100)

AS

SET NOCOUNT ON;
Declare @stateID smallint, @CountryID smallint;
SELECT @stateID = stateID,@CountryID = CountryID  from tblStates where Statecode= @STATE ;

if (@FirstName='' or @FirstName='ICON Transfer' Or @LastName='For Prepaid')
	SET @RelationshipID  = 99;
BEGIN
	update     tblPrepaid  set   FacilityID  = @FacilityID,
	   		  tblPrepaid.FirstName = @firstName ,
	    		 tblPrepaid.LastName  =  @lastName,
	     		 tblPrepaid.Address  =  @Address , 
                 		 tblPrepaid.City =  @city , 
	    		tblPrepaid.State  = @State,
	      		 tblPrepaid.ZipCode  = @zipcode,
	      		 tblPrepaid.RelationShipID = @relationShipID  ,
	       		tblPrepaid.Status = @status ,
			 InmateName  =     @inmateName ,
			 StateID = @stateID,
			 CountryID = @CountryID 
	WHERE  tblPrepaid.PhoneNo = @PhoneNo ;

	update  tblEndUsers  set  Email = @email, password =@password, SecurityQ= @QuestionID,  SecurityA=@SecurityA   where Username = @PhoneNo ;
End	
	
