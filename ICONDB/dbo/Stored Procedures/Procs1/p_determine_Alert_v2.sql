
CREATE PROCEDURE [dbo].[p_determine_Alert_v2]  -- Use fro new alert and call to phone no
@facilityID int ,
@ANI    varchar(10),
@DNI	varchar(16),
@PIN		varchar(12),
@AlertEmails	varchar(200)  OUTPUT,
@AlertCellPhones	varchar(200)  OUTPUT,
@AlertRegPhone	varchar(10)   OUTPUT,
@AlertMessage		varchar(700) OUTPUT
AS
SET NOCOUNT ON;
Declare @hourlyFreq tinyint,@traceFreg	tinyint,  @DailyFreq tinyint,  @WeeklyFreq tinyint, @MonthlyFreq tinyint ,@flatform tinyint, @AllEmails varchar(500), @NameRecord bit, @bioMetric bit ;
SET @AlertEmails ='';
SET  @AlertCellPhones	 ='';
SET  @AlertRegPhone ='';
SET @AlertMessage	 ='';
SET  @hourlyFreq =0;
SET @traceFreg	=0;
/*
if(@PIN >'0')
 Begin
	select @NameRecord = isnull(NameRecord,0),   @bioMetric =isnull(BioMetric,0)  from tblFacilityOption with(nolock) where FacilityID =@FacilityID ;
	
	if(@NameRecord =1 and @bioMetric =1 )
		Update tblInmate set NameRecorded =1, BioRegister =1 where FacilityId = @facilityID and PIN =@PIN;
	Else  If	(@NameRecord =1)
		Update tblInmate set NameRecorded =1 where FacilityId = @facilityID and PIN =@PIN;
	Else if(@bioMetric =1 )
		Update tblInmate SET BioRegister =1 where FacilityId = @facilityID and PIN =@PIN;
	
 end
 */
Select @hourlyFreq = hourlyFreq, @DailyFreq = DailyFreq, @WeeklyFreq = WeeklyFreq,@MonthlyFreq = MonthlyFreq ,
	  @AlertEmails =isnull( AlertEmails,'') , @AlertCellPhones =isnull( AlertCellphones,''), @AlertRegPhone	 =rtrim(ltrim(Isnull(AlertRegPhone,''))) , @AlertMessage = Isnull( AlertMessage,'Destination Call Alert')  from   tblAlertPhones with(nolock)  where phoneNo = @DNI and facilityID = @facilityID;

If( @hourlyFreq =0)
	Select @hourlyFreq = hourlyFreq, @DailyFreq = DailyFreq, @WeeklyFreq = WeeklyFreq,@MonthlyFreq = MonthlyFreq ,
  	@AlertEmails =isnull( AlertEmails,'') , @AlertCellPhones =isnull( AlertCellphones,''), @AlertRegPhone	 =rtrim(ltrim(Isnull(AlertRegPhone,''))) , @AlertMessage = Isnull( AlertMessage,'Inmate Call Alert')  from   tblAlertPINs  with(nolock)  where PIN = @PIN and facilityID = @facilityID;

If( @hourlyFreq =0)
	Select @hourlyFreq = hourlyFreq, @DailyFreq = DailyFreq, @WeeklyFreq = WeeklyFreq,@MonthlyFreq = MonthlyFreq ,
  	@AlertEmails =isnull( AlertEmails,'') , @AlertCellPhones =isnull( AlertCellphones,''), @AlertRegPhone	 =rtrim(ltrim(Isnull(AlertRegPhone,''))) , @AlertMessage = Isnull( AlertMessage,'Station Call Alert')  from   tblAlertANIs  with(nolock)  where ANINo = @ANI;


SET   @AlertEmails =  REPLACE(@AlertEmails,' ','');
SET   @AlertCellPhones =   REPLACE(@AlertCellPhones,' ','');


if (LEN(@AlertEmails) <5) 
	set @AlertEmails='';
if (LEN(@AlertCellPhones) <5) 
	set @AlertCellPhones='';
if(@AlertMessage ='') 
	SET @AlertMessage = 'Watch list Alert';

if(@AlertEmails ='' and @AlertCellPhones <>'') 
	SET @AllEmails = @AlertCellPhones ;
else if(@AlertEmails <>'' and @AlertCellPhones <>'')
	SET @AllEmails = @AlertEmails +';' + @AlertCellPhones ;
	
SET   @AllEmails =  REPLACE(@AllEmails,';;',';');	
SET   @AllEmails =  REPLACE(@AllEmails,',',';');	
SET   @AllEmails =  REPLACE(@AllEmails,':',';');
SET   @AlertEmails = @AllEmails;



