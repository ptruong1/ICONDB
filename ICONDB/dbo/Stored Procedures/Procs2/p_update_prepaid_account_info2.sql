

CREATE PROCEDURE [dbo].[p_update_prepaid_account_info2]
@PhoneNo varchar(12),
@FacilityID	int ,
@firstName	varchar(25),
@lastName	varchar(25),
@Address	varchar(75) ,
@city		varchar(20) ,
@stateID		smallint,
@countryID	smallint,
@zipcode	varchar(10) ,
@email          varchar(50) ,
@RelationshipID  tinyint , 
@status		tinyint 

  

AS
Begin
	SET NOCOUNT ON;
	Declare @state varchar(20);
	Select @state = statecode from tblStates with(nolock) where StateID = @stateID;
	if (@FirstName='' or @FirstName='ICON Transfer' Or @LastName='For Prepaid')
		SET @RelationshipID  = 99;
	UPDATE     tblPrepaid  
		set   FacilityID  = @FacilityID,
	   			FirstName = @firstName ,
	    		 LastName  =  @lastName,
	     		Address  =  @Address , 
                 		 City =  @city , 
						 [State]= @State,
	    		StateID  = @StateID,
	      		 ZipCode  = @zipcode,
	      		 RelationShipID = @relationShipID  ,
	       		Status = @status ,
			   CountryID = @countryID 
	WHERE  tblPrepaid.PhoneNo = @PhoneNo ;

	UPDATE  tblEndUsers  set  Email = @email    where Username = @PhoneNo ;

	Return @@error;

End

