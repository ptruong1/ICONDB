-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_medicalKite_form_v1]
			@FacilityID  int,
            @InmateID varchar(12),
           @BookingNo varchar(12),
           @DOB varchar(10),
           @AliasName	varchar(30),
           @InmateLocation varchar(30),
		   @RoomBedNo	varchar(10),
           @Dental bit,
           @HIV bit,
           @Medical bit,
           @Psychiatric bit,
           @DescriptOfProblem varchar(2000),
           @LengthOfProblem varchar(40),
           @InmateSignature varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

	Declare @RequestDate datetime, @LocationID int, @timeZone tinyint,@FormID int;
	SET @timeZone =0;
	SET @FormID = 0;
	SET @timeZone = (select timeZone from tblfacility where FacilityID =@FacilityID ); 
	SET @RequestDate = dateadd(hour,@timeZone, GETDATE()); 
	--SET @RequestTime = dateadd(hour,@timeZone, GETDATE());
	Declare  @return_value int, @nextID int, @ID int, @tblMedicalKiteForm nvarchar(32) ;

	 EXEC   @return_value = p_create_nextID 'tblMedicalKiteForm', @nextID   OUTPUT
     set           @ID = @nextID ;
	INSERT INTO [leg_Icon].[dbo].[tblMedicalKiteForm]
           ([FormID]
		   ,[FacilityID]
           ,[InmateID]
           ,[BookingNo]
           ,[DOB]
           ,[RequestDate]
           , AliasName 
           ,[InmateLocation]
           ,[Dental]
           ,[HIV]
           ,[Medical]
           ,[Psychiatric]
           ,[DescriptOfProblem]
           ,[LengthOfProblem]
           ,[InmateSignature]
           ,[status]
		   ,RoomBedNo)
     VALUES
           (@ID,
		   @FacilityID  ,
            @InmateID ,
           @BookingNo ,
           @DOB ,
           @RequestDate ,
           @AliasName,
           @InmateLocation ,
           @Dental ,
           @HIV ,
           @Medical ,
           @Psychiatric ,
           @DescriptOfProblem ,
           @LengthOfProblem ,
           @InmateSignature,
		   1,
		   @RoomBedNo)



	SET  @FormID = @ID ;
	
	select FormID,G.[FacilityID]
           ,G.[InmateID],(I.FirstName + ' ' + I.LastName) as InmateName , G.AliasName
           ,[BookingNo]
           ,G.[DOB]
           ,[RequestDate]
            
           ,[InmateLocation]
           ,[Dental]
           ,[HIV]
           ,[Medical]
           ,[Psychiatric]
           ,[DescriptOfProblem]
           ,[LengthOfProblem]
           ,[InmateSignature],G.[status] as [StatusID]
           ,F.Descript as [Status],@RoomBedNo as RoomBedNo  from [tblMedicalKiteForm] G inner join tblInmate  I on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
           Inner join tblFormstatus F on (G.status = F.statusID) 
           where FormID = @FormID 
    Return @@error;
END
