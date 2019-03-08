-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_medicalKite_form]
			@FacilityID  int,
            @FormID int,
            @Status tinyint
           
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

	Declare @RequestDate datetime, @LocationID int, @timeZone tinyint;
	SET @timeZone =0;
	--SET @timeZone = (select timeZone from tblfacility where FacilityID =@FacilityID ); 
	--SET @RequestDate = dateadd(hour,@timeZone, GETDATE()); 
	--SET @RequestTime = dateadd(hour,@timeZone, GETDATE());
	update[leg_Icon].[dbo].[tblMedicalKiteForm] set status = @Status  where FormID = @FormID  ;
           



	
	select 
		 [FormID]
      , G.[FacilityID]
      , G.[InmateID],(I.FirstName + ' ' + I.LastName) as InmateName 
      ,[BookingNo]
      ,[AliasName]
      , G.[DOB]
      ,[RequestDate]
      ,[InmateLocation]
      ,[Dental]
      ,[HIV]
      ,[Medical]
      ,[Psychiatric]
      ,[DescriptOfProblem]
      ,[LengthOfProblem]
      ,[InmateSignature]
      ,[Response]
      ,[ReviewedBy]
      ,[ReviewedDate]
      ,[StaffNote]
      ,[NoteBy]
      ,[NoteDate]
      ,[MDClinic]
      ,[Nurse]
      ,[ChartReview]
      ,[MentalHealth]
      ,G.[Status] as [StatusID]      
           
           ,F.Descript as [Status] from [tblMedicalKiteForm] G inner join tblInmate  I on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
           Inner join tblFormstatus F on (G.status = F.statusID) 
           where FormID = @FormID ;
    Return @@error;
END


