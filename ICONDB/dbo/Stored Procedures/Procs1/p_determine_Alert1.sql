
CREATE PROCEDURE [dbo].[p_determine_Alert1]
@facilityID int ,
@ANI    varchar(10),
@DNI	varchar(16),
@PIN		int,
@AlertEmails	varchar(200)  OUTPUT,
@AlertCellPhones	varchar(200)  OUTPUT,
@AlertRegPhone	varchar(10)   OUTPUT,
@AlertMessage		varchar(200) OUTPUT
AS
Declare @hourlyFreq tinyint,  @DailyFreq tinyint,  @WeeklyFreq tinyint, @MonthlyFreq tinyint ;
SET @AlertEmails ='';
SET  @AlertCellPhones	 ='';
SET  @AlertRegPhone ='';
SET @AlertMessage	 ='';
SET  @hourlyFreq =0;
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

--- call to get Alert location 

----- more coding here
selectOut:
select @AlertEmails + @AlertCellPhones  as AlertEmails , @AlertRegPhone  as AlertPhone, @AlertMessage  as AlertMessage;
