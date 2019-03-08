
CREATE PROCEDURE  [dbo].[p_search_Inmate]
@FacilityID	Int,
@InmateID	varchar(12),
@LastName	varchar(30),
@firstName	varchar(30)

AS
	SET NOCOUNT ON;

SET @InmateID	 = rtrim(ltrim(@InmateID))
SET @LastName =  rtrim(ltrim(@LastName))
SET @firstName =  rtrim(ltrim(@firstName))

IF(@InmateID <> '') 
Begin
	SELECT InmateID, FirstName, LastName   
	FROM  tblInmate with (nolock)  WHERE 
			   	  tblInmate.FacilityID = @FacilityID AND status =1  And  tblInmate.InmateID =@InmateID  
End
Else IF ( @LastName  <> '' and   @firstName <>'')
Begin
	
	SELECT InmateID, FirstName, LastName   
	FROM  tblInmate with (nolock)  WHERE 
			   	  tblInmate.FacilityID = @FacilityID   AND status =1 AND
				   tblInmate.LastName like  @LastName + '%'   and   tblInmate.FirstName like @firstName + '%'   
				
End
Else IF ( @LastName  <> '')
Begin
	
	SELECT InmateID, FirstName, LastName   
	FROM  tblInmate with (nolock)  WHERE 
			   	  tblInmate.FacilityID = @FacilityID   AND status =1  And  tblInmate.LastName like  @LastName + '%'      
				
End
Else IF (    @firstName <>'')
Begin
	
	SELECT InmateID, FirstName, LastName   
	FROM  tblInmate with (nolock)  WHERE 
			   	  tblInmate.FacilityID = @FacilityID AND status =1   AND    tblInmate.FirstName like @firstName + '%'
				
End
Else
Begin
	SELECT InmateID, FirstName, LastName   
	FROM  tblInmate with (nolock)  WHERE 
			   	  tblInmate.FacilityID = @FacilityID AND status =1  And   tblInmate.InmateID <> '0'   and tblInmate.InmateID <> '' 
				
End

