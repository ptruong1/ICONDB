
CREATE PROCEDURE  [dbo].[p_search_DebitAccount]
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
	SELECT AccountNo, tblDebit.InmateID, FirstName, LastName, Balance,  tblDebit.ActiveDate as ActiveDate, tblDebit.EndDate as EndDate,tblStatus.Descrip as Description
	FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID
				INNER JOIN tblInmate with (nolock) ON tblDebit.InmateID = tblInmate.InmateID and
			   	tblDebit.facilityID = tblInmate.facilityID  and  tblInmate.FacilityID = @FacilityID  And  tblInmate.InmateID =@InmateID 
				ORDER BY tblDebit.InputDate DESC
End
Else IF ( @LastName  <> '' and   @firstName <>'')
Begin
	
	SELECT AccountNo, tblDebit.InmateID, FirstName, LastName, Balance,  tblDebit.ActiveDate as ActiveDate, tblDebit.EndDate as EndDate, Balance,  tblStatus.Descrip as Description
	FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID
				INNER JOIN tblInmate with (nolock) ON tblDebit.InmateID = tblInmate.InmateID and
			   	tblDebit.facilityID = tblInmate.facilityID  and  tblInmate.FacilityID = @FacilityID  And  tblInmate.LastName like  @LastName + '%'   and   tblInmate.FirstName like @firstName + '%'
				ORDER BY tblDebit.InputDate DESC
End
Else IF ( @LastName  <> '')
Begin
	
	SELECT AccountNo, tblDebit.InmateID, FirstName, LastName, Balance,  tblDebit.ActiveDate as ActiveDate, tblDebit.EndDate as EndDate, Balance,  tblStatus.Descrip as Description
	FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID
				INNER JOIN tblInmate with (nolock) ON tblDebit.InmateID = tblInmate.InmateID and
			   	tblDebit.facilityID = tblInmate.facilityID  and  tblInmate.FacilityID = @FacilityID  And  tblInmate.LastName like  @LastName + '%'   
				ORDER BY tblDebit.InputDate DESC
End
Else IF (    @firstName <>'')
Begin
	
	SELECT AccountNo, tblDebit.InmateID, FirstName, LastName, Balance, tblDebit.ActiveDate as ActiveDate, tblDebit.EndDate as EndDate, Balance, tblStatus.Descrip as Description
	FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID
				INNER JOIN tblInmate with (nolock) ON tblDebit.InmateID = tblInmate.InmateID and
			   	tblDebit.facilityID = tblInmate.facilityID  and  tblInmate.FacilityID = @FacilityID  And     tblInmate.FirstName like @firstName + '%'
				ORDER BY tblDebit.InputDate DESC
End
Else
Begin
	SELECT AccountNo, tblDebit.InmateID, FirstName, LastName,  Balance, tblDebit.ActiveDate as ActiveDate, tblDebit.EndDate as EndDate,Balance, tblStatus.Descrip as Description
	FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID
				INNER JOIN tblInmate with (nolock) ON tblDebit.InmateID = tblInmate.InmateID and
			   	tblDebit.facilityID = tblInmate.facilityID  and  tblInmate.FacilityID = @FacilityID  and tblInmate.InmateID <> '0'   and tblInmate.InmateID <> '' 
				ORDER BY tblDebit.InputDate DESC
End

