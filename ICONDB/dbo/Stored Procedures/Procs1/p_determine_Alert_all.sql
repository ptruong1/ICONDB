
CREATE PROCEDURE [dbo].[p_determine_Alert_all]
@DNI	varchar(10),
@ANI	varchar(10),
@locationID	int,
@inmateID	int,
@PIN		int,
@AlertEmails	varchar(200)  OUTPUT,
@AlertCellPhones	varchar(200)  OUTPUT,
@AlertRegPhone	varchar(10)   OUTPUT
AS
Declare @hourlyFreq tinyint,  @DailyFreq tinyint,  @WeeklyFreq tinyint, @MonthlyFreq tinyint
SET @AlertEmails =''
SET  @AlertCellPhones	 =''
SET  @AlertRegPhone =''
SET  @hourlyFreq =0
Select @hourlyFreq = hourlyFreq, @DailyFreq = DailyFreq, @WeeklyFreq = WeeklyFreq,@MonthlyFreq = MonthlyFreq ,
  @AlertEmails =isnull( AlertEmails,'') , @AlertCellPhones =isnull( AlertCellphones,''), @AlertRegPhone	 =Isnull(AlertRegPhone,'')  from   tblAlertPhones with(nolock)  where phoneNo = @DNI

SET   @AlertEmails =  REPLACE(@AlertEmails,' ','')
SET   @AlertCellPhones =   REPLACE(@AlertCellPhones,' ','')

If( @hourlyFreq =0)
	Return 0
else If( @hourlyFreq =1) 
	return 1
Else IF ( @hourlyFreq >1) 
	If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(hh,recordDate,getdate()) <=1 having count (tono) >= @hourlyFreq  ) > 0
		return 1
Else If (@DailyFreq > 0) 
	If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(hh,recordDate,getdate()) <=24  having count (tono) >= @DailyFreq  ) > 0
		return 1
Else IF  @WeeklyFreq  >0
	If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(d,recordDate,getdate()) <=7  having count (tono) >=  @WeeklyFreq  ) > 0
		return 1
Else If @MonthlyFreq > 0
	If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(d,recordDate,getdate()) <=30  having count (tono) >=  @MonthlyFreq ) > 0
		return 1	
Else
  Begin
	IF(@inmateID >0  or @PIN >0 )
		Select @hourlyFreq = hourlyFreq, @DailyFreq = DailyFreq, @WeeklyFreq = WeeklyFreq,@MonthlyFreq = MonthlyFreq , @AlertEmails =isnull( AlertEmail,'') , 
			@AlertRegPhone =isnull( Alertphone,''),@AlertCellPhones =isnull( AlertCellphones,'')  from   tblInmate with(nolock)  where InmateID = @InmateID Or PIN =  @PIN
		 SET   @AlertEmails =  REPLACE(@AlertEmails,' ','')
		 SET   @AlertCellPhones =   REPLACE(@AlertCellPhones,' ','')

		If( @hourlyFreq =0)
			Return 0
		else If( @hourlyFreq =1) 
			return 1
		Else IF ( @hourlyFreq >1) 
			If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(hh,recordDate,getdate()) <=1 having count (tono) >= @hourlyFreq  ) > 0
				return 1
		Else If (@DailyFreq > 0) 
			If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(hh,recordDate,getdate()) <=24  having count (tono) >= @DailyFreq  ) > 0
				return 1
		Else IF  @WeeklyFreq  >0
			If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(d,recordDate,getdate()) <=7  having count (tono) >=  @WeeklyFreq  ) > 0
				return 1
		Else If @MonthlyFreq > 0
			If (select count(tono) from tblcallsbilled with(nolock) where tono=@DNI and datediff(d,recordDate,getdate()) <=30  having count (tono) >=  @MonthlyFreq ) > 0
				return 1	
  End

