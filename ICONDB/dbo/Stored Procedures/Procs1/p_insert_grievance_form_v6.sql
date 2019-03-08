-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_grievance_form_v6]
		   @FacilityID int,
           @InmateID varchar(12),
           @BookSO varchar(12), --- Booking number
           @HousingUnit varchar(25),--Housing Unit 
           @InmateLocation tinyint, -- Medford or Talent 1-Medford , 2-Talent -- defind in table tblSubFacility
           @Grievance varchar(2000),
           @GrievanceSignature varchar(50),
		   @GrievanceType tinyint,
           @RoomBebNo  varchar(8),  --- Room Number
		   @Issue	varchar(800),
		   @ActionRequest  varchar(800),
		   @OtherForm varchar(100),
		   @DeviceName	varchar(20),
		   @FormReference int
AS
BEGIN
	Declare @RequestDate date, @LocationID int, @timeZone tinyint,@RequestTime time(0),@GrievanceDate date,@FacilityFormID int,
	 @GrievanceReportTime datetime, @formID int;
	SET @BookSO = isnull(@BookSO,'');
	set @HousingUnit = ISNULL(@HousingUnit,'');
	SET @RoomBebNo  = Isnull(@RoomBebNo ,'');
	SET @GrievanceSignature = isnull(@GrievanceSignature, @InmateID);
	SET @InmateLocation = Isnull(@InmateLocation,0);
	SET @timeZone =0;
	SET @FacilityFormID =1;
	SET @timeZone = (select timeZone from tblfacility with(nolock) where FacilityID =@FacilityID );
	SET @GrievanceReportTime =  dateadd(hour,@timeZone, GETDATE());
	SET @GrievanceType = isnull(@GrievanceType,1);
	--SET @GrievanceDate = dateadd(hour,@timeZone, @GrievanceReportTime ); 
	--SET @RequestTime = dateadd(hour,@timeZone, @GrievanceReportTime );
	 Declare  @return_value int, @nextID int, @ID int, @tblGrievanceForm nvarchar(32), @status tinyint ;
	EXEC   @return_value = p_create_nextID 'tblGrievanceForm', @nextID   OUTPUT
       set           @ID = @nextID ; 
	set @status=1;
	--if(@FacilityID=796) set @status=20
	--else if (@FacilityID=814) set @status=121
	Select @FacilityFormID = isnull(medtemplate,1) from  tblFacilityForms where FacilityID = @FacilityID ;

	Select @status = statusID from tblFormstatus with(nolock) where FacilityFormID= @FacilityFormID and Descript='Submitted';

	INSERT  [tblGrievanceForm]
           (formID
		   ,[FacilityID]
           ,[InmateID]
           ,[BookSO]
           ,[InmateLocation]
           ,[HousingUnit]
           ,[Grievance]
           ,[GrievanceReportTime]
           ,[GrievanceSignature]
           ,[status]
		   ,GrievancetypeID
		   ,RoomBedNo
		   ,GvIssue
		   ,ActionRequest
		   ,OtherForm
		   ,DeviceName,
		   FormReference)
     VALUES
           (@ID,
		   @FacilityID ,
           @InmateID ,
           @BookSO ,
       
           @InmateLocation ,
           @HousingUnit ,
           @Grievance ,
           @GrievanceReportTime ,
           @GrievanceSignature ,
		   @status,
		   @GrievanceType,
		   @RoomBebNo,
		   @Issue,
		   @ActionRequest,
		   @OtherForm,
		   @DeviceName,
		   @FormReference)


	SET @FormID =@ID ;
	--select @FormID, @@ERROR;
	Select FormID,G.[FacilityID]
           ,G.[InmateID]
		   ,I.FirstName
		   ,I.LastName 
           ,[BookSO]
           ,[InmateLocation]
           ,[HousingUnit]
		   ,[FormReference]
           ,[Grievance]
           ,[GrievanceReportTime]
           ,[GrievanceSignature], G.[status] as [StatusID]
           ,F.Descript as [Status], T.Descript as  GrievanceType, @RoomBebNo as RoomBebNo, @Issue as Issue, @ActionRequest as ActionRequest
		    from [tblGrievanceForm] G inner join tblInmate  I on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
           Inner join tblFormstatus F on (isnull(G.status,1) = F.statusID)
		   Inner Join tblGrievanceType T on (G.GrievancetypeID = T.Grievancetype)
           where FormID =@formID 
	
	
END
