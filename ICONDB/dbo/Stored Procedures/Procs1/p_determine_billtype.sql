
CREATE PROCEDURE [dbo].[p_determine_billtype] 
@ANI	char(10),
@DNI	varchar(15),
@inmateID	int,
@PIN		int,
@Billtype	char(2)  OUTPUT,
@balance	numeric(6,2)  OUTPUT,
@RecordOPT	char  OUTPUT,
@AlertEmails	varchar(200)  OUTPUT,
@AlertCellPhones	varchar(200)  OUTPUT,
@AlertRegPhone	varchar(10)   OUTPUT
AS
Declare @ReasonID	int
SET @AlertEmails =''
SET  @AlertCellPhones	 =''
SET  @AlertRegPhone =''
SET  @RecordOPT	='Y'
SET @balance	 =0
SET   @ReasonID =0


If ( isnumeric(@DNI) =0) 	Return -1
select @ReasonID= ReasonID  from tblblockedPhones with(nolock) where phoneNo =  @DNI  
If (@ReasonID > 0) Return  @ReasonID

/*
If( select count(*) from tblAlertPhones with(nolock) where phoneNo =  @DNI) > 0
	Select @AlertEmails =isnull( AlertEmails,'') , @AlertCellPhones =isnull( AlertCellphones,''), @AlertRegPhone	 =Isnull(AlertRegPhone,'')  from   tblAlertPhones with(nolock)  where phoneNo = @DNI
Else
	IF(@inmateID >0  or @PIN >0 )
		Select @AlertEmails =isnull( AlertEmail,'') , @AlertRegPhone =isnull( Alertphone,''),@AlertCellPhones =isnull( AlertCellphones,'')  from   tblInmate with(nolock)  where InmateID = @InmateID Or PIN =  @PIN

*/

If( select count(*) from tblNonRecordPhones with(nolock) where phoneno = @DNI) > 0
	SET @RecordOPT ='N'
If( select count(*) from tblFreePhones with(nolock) where phoneNo =  @DNI) > 0
	SET @billType ='08'
Select  @balance	=isnull( balance,0) from tblprepaid with(nolock) where phoneNo = @DNI
IF(  @balance	 >1)
	SET  @Billtype	='10'
