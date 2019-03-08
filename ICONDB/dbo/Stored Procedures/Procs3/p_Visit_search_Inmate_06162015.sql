
CREATE PROCEDURE  [dbo].[p_Visit_search_Inmate_06162015]
@FacilityID	Int,
@InmateID	varchar(12),
@LastName	varchar(30),
@firstName	varchar(30)

AS
	Declare @ReturnCode   int 
	set @ReturnCode = 0 
	Declare @recordID int ,@flatform  tinyint
		
	SET NOCOUNT OFF;
	
	

Begin
IF(@InmateID <> '') 
	Begin
		SELECT top 10 I.InmateID, [LastName], [FirstName], [MidName], isnull(ApprovedReq,0) as VisitApprovedReq,
		SusStartDate, SusEndDate, isnull(AssignToDivision,-1) as AssignToDivision, I.PIN
		,isnull(V.VisitPerDay, 0) as VisitPerDay, isnull(V.VisitPerWeek,0) as VisitPerWeek,isnull(V.VisitRemain,10) as VisitRemain
		FROM  [leg_Icon].[dbo].tblInmate I with (nolock)
		Left Join  [leg_Icon].[dbo].tblVisitInmateConfig V with (nolock) On
		I.facilityID = V.FacilityID and I.InmateID = V.InmateID
			WHERE 
				I.FacilityID = @FacilityID AND status =1  And  I.InmateID =@InmateID  
	End
Else IF ( @LastName  <> '' and   @firstName <>'')
	Begin
		
		SELECT top 10 I.InmateID, [LastName], [FirstName], [MidName], isnull(ApprovedReq,0) as VisitApprovedReq,
		SusStartDate, SusEndDate, isnull(AssignToDivision,-1) as AssignToDivision, I.PIN
		,isnull(V.VisitPerDay, 0) as VisitPerDay, isnull(V.VisitPerWeek,0) as VisitPerWeek,isnull(V.VisitRemain,10) as VisitRemain
		FROM  [leg_Icon].[dbo].tblInmate I with (nolock)
		Left Join  [leg_Icon].[dbo].tblVisitInmateConfig V with (nolock) On
		I.facilityID = V.FacilityID and I.InmateID = V.InmateID
			WHERE 
			   		 I.FacilityID = @FacilityID   AND status =1 AND
					   I.LastName like  @LastName + '%'   and   I.FirstName like @firstName + '%'   
					
	End
Else IF ( @LastName  <> '')
	Begin
		
		SELECT top 10 I.InmateID, [LastName], [FirstName], [MidName], isnull(ApprovedReq,0) as VisitApprovedReq,
		SusStartDate, SusEndDate, isnull(AssignToDivision,-1) as AssignToDivision, I.PIN
		,isnull(V.VisitPerDay, 0) as VisitPerDay, isnull(V.VisitPerWeek,0) as VisitPerWeek,isnull(V.VisitRemain,10) as VisitRemain
		FROM  [leg_Icon].[dbo].tblInmate I with (nolock)
		Left Join  [leg_Icon].[dbo].tblVisitInmateConfig V with (nolock) On
		I.facilityID = V.FacilityID and I.InmateID = V.InmateID
			WHERE
			   		  I.FacilityID = @FacilityID   AND 
			   		  status =1  And  
			   		  I.LastName like  @LastName + '%'      
					
	End
Else 
	Begin
		
		SELECT top 10 I.InmateID, [LastName], [FirstName], [MidName], isnull(ApprovedReq,0) as VisitApprovedReq,
		SusStartDate, SusEndDate, isnull(AssignToDivision,-1) as AssignToDivision, I.PIN
		,isnull(V.VisitPerDay, 0) as VisitPerDay, isnull(V.VisitPerWeek,0) as VisitPerWeek,isnull(V.VisitRemain,10) as VisitRemain
		FROM  [leg_Icon].[dbo].tblInmate I with (nolock)
		Left Join  [leg_Icon].[dbo].tblVisitInmateConfig V with (nolock) On
		I.facilityID = V.FacilityID and I.InmateID = V.InmateID
			WHERE
			   		  I.FacilityID = @FacilityID AND 
			   		  status =1   AND    
			   		  I.FirstName like @firstName + '%'
					
	End

End


