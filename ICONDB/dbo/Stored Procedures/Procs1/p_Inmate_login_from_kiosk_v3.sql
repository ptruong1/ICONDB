-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Inmate_login_from_kiosk_v3] 
	@KioskName varchar(16),
	@PIN	varchar(12)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
   Declare  @MedicalKiteForm bit, @InmateKiteForm bit, @GrievanceForm bit,@facilityID int,  @inmateID varchar(12), @locationID int,@roomID int,@visitType tinyint, @InmateLocationID int, 
   @timeZone tinyint, @localTime datetime, @timePass int, @flatform tinyint, @MedicalKiteReceiveEmail  varchar(40)   , @InmateKiteReceiveEmail    varchar(40), @GrievanceReceiveEmail varchar(40);
   Declare @VisitorName varchar(50),	@InmateName  varchar(50) ,	@AppDateTime	datetime ,	@AppDuration int ,	@SessionID	varchar(20)  ,@LocationName varchar(30),
	@VisitorID	int ,	@SoftphoneOpt  bit ,	@FormOpt    bit ,	@RemainTime bigint , 	@ChatServerIP varchar(20), @InmateSO varchar(12) , @DOB varchar(10), @timeDiff tinyint;
   Declare @VideoVisitOpt tinyint, @EmailOpt tinyint, @VideoMessageOpt tinyint, @PictureOpt tinyint, @TextMessageOpt tinyint, @MedProvider varchar(25), @FacilityName varchar(50), @isInmateConfig smallint ; 
   SET @facilityID =0 ;
   SET @inmateID ='0';
   SET @SoftphoneOpt =0;
   SET @FormOpt = 0 ;
   SET @MedicalKiteForm=0;
   SET @GrievanceForm =0;
   SET @InmateKiteForm=0;
   SET @InmateSO ='';
   SET @DOB='';
   SET  @MedicalKiteReceiveEmail='';
   SET @InmateKiteReceiveEmail='';
   SET  @GrievanceReceiveEmail ='';
   SET @timeDiff =0;
   SET @VideoVisitOpt  =0;
   SET @EmailOpt = 0;
   SET @VideoMessageOpt =0; 
   SET @PictureOpt =0;
   SET @TextMessageOpt =0;
   SET @MedProvider ='Affordable Care Act';
   SET  @isInmateConfig =0;
   SET @locationName ='';
   select @facilityID= a.FacilityID ,@locationID  =a.LocationID,@LocationName= b.LocationName  FROM [leg_Icon].[dbo].tblVisitPhone  a with(nolock) join [leg_Icon].[dbo].tblVisitLocation b with(nolock)  on (a.FacilityID=b.FacilityID and a.LocationID =b.LocationID )
    where a.ExtID =@KioskName;
    if(@facilityID =0)
     select  @facilityID= FacilityID,@locationID = centerID  from tblTablets with(nolock) where TabletID = @KioskName;
   If(@facilityID> 0)
    begin
		select @inmateID = InmateID,@InmateName = FirstName + ' ' + LastName , @DOB =isnull(DOB,'')  from tblInmate with(nolock)  where FacilityId = @FacilityId and PIN =@PIN and [Status]=1;
		SELECT @InmateSO =bookingNo from tblInmateInfo with(nolock)  where FacilityID =@facilityID and PIN=@inmateID 
		select @timeDiff = timezone,@FacilityName = Location from tblfacility with(nolock)  where FacilityID =@facilityID ;
		select @InmateLocationID = locationID, @isInmateConfig = count(*) from tblVisitInmateConfig with(nolock) where FacilityID =@facilityID and InmateID =@inmateID group by locationID ;
		if(@inmateID <> '0')
		 begin
			select @SoftphoneOpt = isnull(softphoneOpt,0), @FormOpt = isnull(FormsOpt,0) from tblFacilityOption with(nolock)  where FacilityID =@FacilityId ;
			--select @InmateLocationID as CurrentLoc, @locationID as KioskLoc;
			if(@InmateLocationID is null or @InmateLocationID =0)
			 begin
			    if (@isInmateConfig > 0)
					update tblVisitInmateConfig set LocationID = @locationID, ModifyDate= getdate() where FacilityID =@facilityID and InmateID =@inmateID and (locationID is null or locationID =0) ;
				else
					insert tblVisitInmateConfig(InmateID, FacilityID, LocationID, AtLocation, InputDate) 
						    Values( @inmateID, @facilityID, @locationID, @KioskName, getdate());
			 end
			else --- New edit 11/9/16
			 begin
				if((@facilityID in ( 578,558,478) ) and (@locationID <> @InmateLocationID) ) --- Modify on 8/10/2017 for Whatcom
				 begin
					SET @inmateID ='0';
					SET @InmateName='';
					SET @InmateSO ='';
					
				 end
			 end	
		 end
		if(@FormOpt =1)
				select @MedicalKiteForm=MedicalKite, @InmateKiteForm = InmateKite,@GrievanceForm= Grievance ,@MedicalKiteReceiveEmail=MedicalKiteReceiveEmail, @InmateKiteReceiveEmail=InmateKiteReceiveEmail, @GrievanceReceiveEmail=GrievanceReceiveEmail, @MedProvider= isnull(MedProvider ,'Affordable care Act') from tblfacilityForms where facilityID = @facilityID ;
    end
    EXEC  p_insert_kiosk_activity 	@KioskName ,	1,	@FacilityID,	@InmateID ;
    Select @facilityID as FacilityID, @inmateID as InmateID ,@InmateName as InmateName, @InmateSO as InmateSO, @DOB as DOB,  1 as ViewVisitSchedule, 1 as VisitLogin, @SoftphoneOpt as SoftphoneOpt, 
    @FormOpt as  FormOpt, @MedicalKiteForm as MedicalKiteForm, @InmateKiteForm  as InmateKiteForm , @GrievanceForm as  GrievanceForm, @MedicalKiteReceiveEmail as  MedicalKiteReceiveEmail , @InmateKiteReceiveEmail as InmateKiteReceiveEmail, @GrievanceReceiveEmail as  GrievanceReceiveEmail, @timeDiff as TimeDiff, @MedProvider as  MedProvider, @FacilityName as FacilityName, @locationName  as LocationName;
 
 End
 
 
 

