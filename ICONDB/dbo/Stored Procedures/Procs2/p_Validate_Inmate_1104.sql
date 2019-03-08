
CREATE PROCEDURE  [dbo].[p_Validate_Inmate_1104]
@FacilityID	Int,
@InmateID	varchar(12)

AS
	Declare @ReturnCode   int 
	set @ReturnCode = 0 
	Declare @recordID int ,@flatform  tinyint
		
	SET NOCOUNT OFF;
	

Begin
	SELECT I.InmateID, FirstName, LastName ,SusStartDate, SusEndDate ,isnull(ApprovedReq,0) as VisitApprovedReq, I.PIN  
	FROM  [leg_Icon].[dbo].[tblInmate] I with (nolock)
		Left Join [leg_Icon].[dbo].[tblVisitInmateConfig] V on
			I.facilityID = V.FacilityID and I.InmateID = V.InmateID
	         WHERE 
			   	  I.FacilityID = @FacilityID AND 
			   	  status =1  And  
			   	  I.InmateID =@InmateID 
			   	  
End

