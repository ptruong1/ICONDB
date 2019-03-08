

CREATE PROCEDURE [dbo].[p_get_prepaid_account_info_v3]
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
	if(	LEN(@PhoneNo) >=12)
	 begin
		SET @countryCode = dbo.fn_get_countryCode(@PhoneNo);
		SET @AccountNo = RIGHT(@PhoneNo, LEN(@PhoneNo) - LEN(@countryCode));
	--select 	 @AccountNo, @countryCode 
	 end
	else
		SET @AccountNo = right(@PhoneNo,12) ;
 end
if (select count(*) from tblEndusers with(nolock) where UserName = @AccountNo ) >0
 Begin 
	If (@countryCode <> '' and  @countryCode is not null) 
		SELECT   tblFacility.FacilityID,
				tblFacility.Location  as FacilityName ,
				tblFacility.city as FacilityCity,
				[dbo].[GetStateID](tblfacility.State) as FacilityState ,
				@AccountNo as AccountNo,
				tblPrepaid.FirstName,
				tblPrepaid.LastName,
				 tblPrepaid.Address, 
				 tblPrepaid.City, 
				 tblPrepaid.StateID,
				 tblPrepaid.ZipCode,
				  tblPrepaid.Balance,
				  tblRelationShip.RelationshipID ,
				  tblPrepaid.Status,		      
				  (CASE When tblEndUsers.Email like '%noemail%' Then 'Invalid Email' When tblEndUsers.Email='' then 'Invalid Email'  Else   tblEndUsers.Email END) as Email,
				   tblPrepaid.InmateName ,		         
					 tblEndusers.password ,
					 CountryID
		        
		FROM            tblPrepaid   with(nolock)                           
				 INNER JOIN tblRelationShip with(nolock)  ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID 
				 INNER JOIN tblFacility  with(nolock)   On tblPrepaid.FacilityID = tblFacility.FacilityID 
				  INNER JOIN tblEndUsers with(nolock)  On tblPrepaid.PhoneNo =  tblEndUsers.UserName
			  
		WHERE  tblPrepaid.PhoneNo =@AccountNo  and countryCode =@countryCode ;	
	else
		SELECT   tblFacility.FacilityID,
				 tblFacility.Location  as FacilityName ,
				tblFacility.city as FacilityCity,
				[dbo].[GetStateID](tblfacility.State) as FacilityState ,
				@AccountNo as AccountNo,
				tblPrepaid.FirstName,
				tblPrepaid.LastName,
				 tblPrepaid.Address, 
				 tblPrepaid.City, 
				 tblPrepaid.StateID,
				 tblPrepaid.ZipCode,
				  tblPrepaid.Balance,
				  tblRelationShip.RelationshipID ,
				  tblPrepaid.Status,
		     
				  (CASE When tblEndUsers.Email like '%noemail%' Then 'Invalid Email' When tblEndUsers.Email='' then 'Invalid Email'  Else   tblEndUsers.Email END) as Email,
				   tblPrepaid.InmateName ,		         
					 tblEndusers.password ,
					 CountryID 
		      
		FROM        tblPrepaid   with(nolock)                           
				 INNER JOIN tblRelationShip with(nolock)  ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID 
				 INNER JOIN tblFacility  with(nolock)   On tblPrepaid.FacilityID = tblFacility.FacilityID 
				  INNER JOIN tblEndUsers with(nolock)  On tblPrepaid.PhoneNo =  tblEndUsers.UserName
			
		WHERE  tblPrepaid.PhoneNo = @AccountNo ; 
 end
Else
 Begin
		Declare @AccountState varchar(2), @AccountCity  varchar(30);
		SET @AccountState ='';
		 select @facilityID = facilityID, @AccountState =ToState , @AccountCity = toCity  from tblOnCalls  with(nolock) where tono = @AccountNo;
		 if(@AccountState <>'' and @AccountState is not null)
		  begin
			 EXEC p_register_new_prepaid_Account3
											@FacilityID,	
											@AccountNo,
											'Call back',
											@AccountCity ,
											'', 
											 @AccountState,
											1,
											'USA',
											'',
											'For Prepaid',
											'no@email.com',
											@AccountNo,
											'Auto',
											'NA',
											1,
											0,
											'' ;

				SELECT   tblFacility.FacilityID,
						 tblFacility.Location  as FacilityName ,
						tblFacility.city as FacilityCity,
						[dbo].[GetStateID](tblfacility.State) as FacilityState ,
						@AccountNo as AccountNo,
						tblPrepaid.FirstName,
						tblPrepaid.LastName,
						 tblPrepaid.Address, 
						 tblPrepaid.City, 
						 tblPrepaid.StateID,
						 tblPrepaid.ZipCode,
						  tblPrepaid.Balance,
						  tblRelationShip.RelationshipID ,
						  tblPrepaid.Status,		     
						  (CASE When tblEndUsers.Email like '%noemail%' Then 'Invalid Email' When tblEndUsers.Email='' then 'Invalid Email'  Else   tblEndUsers.Email END) as Email,
						   tblPrepaid.InmateName ,		         
							 tblEndusers.password ,
							 CountryID 
		       
							FROM            tblPrepaid   with(nolock)                           
									 INNER JOIN tblRelationShip with(nolock)  ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID 
									 INNER JOIN tblFacility  with(nolock)   On tblPrepaid.FacilityID = tblFacility.FacilityID 
									  INNER JOIN tblEndUsers with(nolock)  On tblPrepaid.PhoneNo =  tblEndUsers.UserName
						
							WHERE  tblPrepaid.PhoneNo = @AccountNo ; 
	   
		  end
	
 end
 

