
CREATE PROCEDURE [dbo].[p_get_property_info1]
@ANI		char(10),
@TrunkNo	varchar(6),
@Property	varchar(150)	output,
@City		varchar(30)	output,
@State		varchar(2)		output,
@Greeting	varchar(300)      output,
@localTime	varchar(8)	output,
@message	varchar(100)	output,
@AgentID	varchar(7)  OUTPUT,
@RecordOpt	char(1) OUTPUT
 AS
Declare		@npa	char(3), @nxx	char(3) , @SubAgentID varchar(5)  , @facilityID int
SET  @Property = ''
SET  @city =''
SET  @state = ''
SET  @greeting = ''
SET @npa	= left (@ANI,3)
SET @nxx	= substring(@ANI,4,3)
SET @RecordOpt = 'Y'
SET @trunkno =Ltrim( rtrim(@trunkno))
SET @message	=''
SET @trunkno = isnull(@trunkno,'')
SET @SubAgentID ='0'
SET @AgentID  ='0'
SET @RecordOpt ='Y'
SET @facilityID =0
select  @facilityID = facilityID from tblANIs  with(nolock) where ANIno = @ANI

If( @facilityID >0 ) 
 Begin
	SELECT @AgentID = AgentID,  @Property = isnull( Location,''),   @city =isnull(  CITY,'') , @state = isnull( STATE,''), @greeting='Legacy Operator '
	from  tblFacility with(nolock) where FacilityID = @facilityID
 End
Else 
 Begin
	SET @AgentID = 1
	SET  @Property ='Equal Access' 
	SET @city ='Cypress' 
	SET @state ='CA'
	SET  @greeting='Legacy Operator '
 End
EXEC sp_get_local_time   @npa ,@nxx , @localTime  OUTPUT

