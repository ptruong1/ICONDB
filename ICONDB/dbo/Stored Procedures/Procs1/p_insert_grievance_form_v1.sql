-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_grievance_form_v1]
		   @FacilityID int,
           @InmateID varchar(12),
           @BookSO varchar(12), --- Booking number
           @HousingUnit varchar(25),--Housing Unit 
           @InmateLocation tinyint, -- Medford or Talent 1-Medford , 2-Talent -- defind in table tblSubFacility
           @Grievance varchar(1000),
           @GrievanceSignature varchar(50),
		    @GrievancType tinyint
           
AS
BEGIN
	Declare @RequestDate date, @LocationID int, @timeZone tinyint,@RequestTime time(0),@GrievanceDate date,
	 @GrievanceReportTime datetime, @formID int;
	SET @timeZone =0;
	SET @timeZone = (select timeZone from tblfacility where FacilityID =@FacilityID );
	SET @GrievanceReportTime =  dateadd(hour,@timeZone, GETDATE());
	--SET @GrievanceDate = dateadd(hour,@timeZone, @GrievanceReportTime ); 
	--SET @RequestTime = dateadd(hour,@timeZone, @GrievanceReportTime );
	Declare  @return_value int, @nextID int, @ID int, @tblGrievanceForm nvarchar(32) ;
	EXEC   @return_value = p_create_nextID 'tblGrievanceForm', @nextID   OUTPUT
       set           @ID = @nextID ; 
	INSERT  [leg_Icon].[dbo].[tblGrievanceForm]
           ([FormID]
		   ,[FacilityID]
           ,[InmateID]
           ,[BookSO]
           ,[InmateLocation]
           ,[HousingUnit]
           ,[Grievance]
           ,[GrievanceReportTime]
           ,[GrievanceSignature]
           ,[status]
		   ,GrievancetypeID)
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
		   1,
		   @GrievancType)


	SET @FormID = @ID ;
	
	Select FormID,G.[FacilityID]
           ,G.[InmateID]
		   ,I.FirstName
		   ,I.LastName 
           ,[BookSO]
           ,[InmateLocation]
           ,[HousingUnit]
           ,[Grievance]
           ,[GrievanceReportTime]
           ,[GrievanceSignature], G.[status] as [StatusID]
           ,F.Descript as [Status], T.Descript as  GrievanceType
		    from [tblGrievanceForm] G inner join tblInmate  I on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
           Inner join tblFormstatus F on (isnull(G.status,1) = F.statusID)
		   Inner Join tblGrievanceType T on (G.GrievancetypeID = T.Grievancetype)
           where FormID =@formID 
	
	
END

