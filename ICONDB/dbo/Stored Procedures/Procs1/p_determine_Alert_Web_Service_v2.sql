
CREATE PROCEDURE [dbo].[p_determine_Alert_Web_Service_v2]
@facilityID int ,
@ANI    varchar(10),
@DNI	varchar(16),
@PIN		varchar(12),
@InmateID   varchar(12),
@AlertEmails	varchar(200)  OUTPUT,
@AlertCellPhones	varchar(200)  OUTPUT,
@AlertRegPhone	varchar(10)   OUTPUT,
@AlertMessage		varchar(700) OUTPUT
AS
SET NOCOUNT ON;
Declare @hourlyFreq tinyint,@traceFreg	tinyint,  @DailyFreq tinyint,  @WeeklyFreq tinyint, @MonthlyFreq tinyint ,@flatform tinyint, @AllEmails varchar(500), @NameRecord bit, @bioMetric bit ;
Declare @AlertEmailsByDNI varchar(200), @AlertCellPhonesByDNI  varchar(200), @AlertRegPhoneByDNI varchar(10);
Declare @AlertEmailsByPIN varchar(200), @AlertCellPhonesByPIN  varchar(200), @AlertRegPhoneByPIN varchar(10);
Declare @AlertEmailsByANI varchar(200), @AlertCellPhonesByANI  varchar(200), @AlertRegPhoneByANI varchar(10);
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
	if(@FacilityID not in (1))  --- temp use for testing biometric
	 begin
		if(@NameRecord =1 and @bioMetric =1 )
			Update tblInmate set NameRecorded =1, BioRegister =1 where FacilityId = @facilityID and InmateID =@InmateID;
		Else  If	(@NameRecord =1)
			Update tblInmate set NameRecorded =1 where FacilityId = @facilityID and InmateID =@InmateID;

		Else if(@bioMetric =1 )
			Update tblInmate SET BioRegister =1 where FacilityId = @facilityID and InmateID =@InmateID;
	 end
	else
	 begin
		If	(@NameRecord =1)
			Update tblInmate set NameRecorded =1 where FacilityId = @facilityID and InmateID =@InmateID;
	 end
 end
 */
Select @hourlyFreq = hourlyFreq, @DailyFreq = DailyFreq, @WeeklyFreq = WeeklyFreq,@MonthlyFreq = MonthlyFreq ,
	  @AlertEmails =isnull( AlertEmails,'') , @AlertCellPhones =isnull( AlertCellphones,''), @AlertRegPhone	 =rtrim(ltrim(Isnull(AlertRegPhone,''))) , @AlertMessage = Isnull( AlertMessage,'Destination Call Alert')  from   tblAlertPhones with(nolock)  where phoneNo = @DNI and facilityID = @facilityID;

If( @AlertEmails ='' and @AlertCellPhones ='' and  @AlertRegPhone='')
	Select @hourlyFreq = hourlyFreq, @DailyFreq = DailyFreq, @WeeklyFreq = WeeklyFreq,@MonthlyFreq = MonthlyFreq ,
  	@AlertEmails =isnull( AlertEmails,'') , @AlertCellPhones =isnull( AlertCellphones,''), @AlertRegPhone	 =rtrim(ltrim(Isnull(AlertRegPhone,''))) , @AlertMessage = Isnull( AlertMessage,'Inmate Call Alert')  from   tblAlertPINs  with(nolock)  where PIN = @PIN and facilityID = @facilityID;

If( @AlertEmails ='' and @AlertCellPhones ='' and  @AlertRegPhone='')
	Select @hourlyFreq = hourlyFreq, @DailyFreq = DailyFreq, @WeeklyFreq = WeeklyFreq,@MonthlyFreq = MonthlyFreq ,
  	@AlertEmails =isnull( AlertEmails,'') , @AlertCellPhones =isnull( AlertCellphones,''), @AlertRegPhone	 =rtrim(ltrim(Isnull(AlertRegPhone,''))) , @AlertMessage = Isnull( AlertMessage,'Inmate Call Alert')  from   tblAlertInmates  with(nolock)  where InmateID = @InmateID and facilityID = @facilityID;


If( @AlertEmails ='' and @AlertCellPhones ='' and  @AlertRegPhone='')
	Select @hourlyFreq = hourlyFreq, @DailyFreq = DailyFreq, @WeeklyFreq = WeeklyFreq,@MonthlyFreq = MonthlyFreq ,
  	@AlertEmails =isnull( AlertEmails,'') , @AlertCellPhones =isnull( AlertCellphones,''), @AlertRegPhone	 =rtrim(ltrim(Isnull(AlertRegPhone,''))) , @AlertMessage = Isnull( AlertMessage,'Station Call Alert')  from   tblAlertANIs  with(nolock)  where ANINo = @ANI;


SET   @AlertEmails =  REPLACE(@AlertEmails,' ','');
SET   @AlertCellPhones =   REPLACE(@AlertCellPhones,' ','');

If( @hourlyFreq =1) 
	goto selectOut;
Else IF ( @hourlyFreq >1) 
	If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(hh,recordDate,getdate()) <=1 having count (tono) >= @hourlyFreq  ) > 0
		goto selectOut;
Else If (@DailyFreq > 0) 
	If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(hh,recordDate,getdate()) <=24  having count (tono) >= @DailyFreq  ) > 0
		goto selectOut;
Else IF  @WeeklyFreq  >0
	If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(d,recordDate,getdate()) <=7  having count (tono) >=  @WeeklyFreq  ) > 0
		goto selectOut;
Else If @MonthlyFreq > 0
	If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(d,recordDate,getdate()) <=30  having count (tono) >=  @MonthlyFreq ) > 0
		goto selectOut;
Else
  Begin
	IF( @PIN >'0' )
	 begin
		Select @hourlyFreq = hourlyFreq, @DailyFreq = DailyFreq, @WeeklyFreq = WeeklyFreq,@MonthlyFreq = MonthlyFreq , @AlertEmails =isnull( AlertEmail,'') , 
			@AlertRegPhone =isnull( Alertphone,''),@AlertCellPhones =isnull( AlertCellphones,'')  from   tblInmate with(nolock)  where  PIN =  @PIN and facilityID = @facilityID;
		 SET   @AlertEmails =  REPLACE(@AlertEmails,' ','');
		 SET   @AlertCellPhones =   REPLACE(@AlertCellPhones,' ','');

		
		 If( @hourlyFreq =1) 
			goto selectOut
		Else IF ( @hourlyFreq >1) 
			If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(hh,recordDate,getdate()) <=1 having count (tono) >= @hourlyFreq  ) > 0
				goto selectOut;
		Else If (@DailyFreq > 0) 
			If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(hh,recordDate,getdate()) <=24  having count (tono) >= @DailyFreq  ) > 0
				goto selectOut;
		Else IF  @WeeklyFreq  >0
			If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(d,recordDate,getdate()) <=7  having count (tono) >=  @WeeklyFreq  ) > 0
				goto selectOut;
		Else If @MonthlyFreq > 0
			If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(d,recordDate,getdate()) <=30  having count (tono) >=  @MonthlyFreq ) > 0
				goto selectOut;
	end
  End
selectOut:
if (LEN(@AlertEmails) <5) 
	set @AlertEmails='';
if (LEN(@AlertCellPhones) <10) 
	set @AlertCellPhones='';
if (right(@AlertEmails,1) =';')
	SET @AlertEmails = left(@AlertEmails,len(@AlertEmails)-1);
if (right(@AlertCellPhones,1) =';')
	SET @AlertCellPhones = left(@AlertCellPhones,len(@AlertCellPhones)-1);

if(@AlertMessage ='') 
	SET @AlertMessage = 'Watch list Alert';

IF (SELECT COUNT(*) FROM tecodata.dbo.tblEndUser where billtono= @DNI and replyCode='399') >0
	EXEC [dbo].p_determine_GPS_tracer @PIN ,@DNI,@facilityID, @traceFreg	 output;

if(@AlertEmails ='' and @AlertCellPhones <>'')
 begin
	SET @AllEmails = @AlertCellPhones ;
 end
else if(@AlertEmails <>'' and @AlertCellPhones <>'')
 begin
	SET @AllEmails = @AlertEmails +';' + @AlertCellPhones
 end
else 
	SET @AllEmails = @AlertEmails ;
SET   @AllEmails =  REPLACE(@AllEmails,';;',';');	
SET   @AllEmails =  REPLACE(@AllEmails,',',';');	
SET   @AllEmails =  REPLACE(@AllEmails,':',';');
if (right(@AllEmails,1) =';')
	SET @AllEmails = left(@AllEmails,len(@AllEmails)-1);
--if(@AlertCellPhones <>'')
--begin
--	Declare @IPaddress varchar(17);
--	Select @IPaddress = username from tblOnCalls with(nolock) where facilityID = @facilityID and fromno= @ANI and tono = @DNI;
--	SET @AlertMessage = @AlertMessage + '. http://legacyicon.com/LiveMonitorWS/LiveMonitorWS.asmx/CallPHPModule?fromNo=' + @ANI+ '&CallBackNo=' + CAST(@facilityID as varchar(5)) +'-' + @DNI + '&IPAddress=' + @IPaddress;
--end
	
select  @AllEmails  as AlertEmails , @AlertRegPhone  as AlertPhone, @AlertMessage  as AlertMessage,'1' as AlertLocation, @traceFreg	As GPStracer;

