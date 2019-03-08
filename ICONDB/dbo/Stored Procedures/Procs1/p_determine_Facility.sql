
CREATE PROCEDURE [dbo].[p_determine_Facility]
@ANI	varchar(10)  ,
@tollFeeNo	varchar(10),
@facilityID  int  OUTPUT,
@IDrequired tinyint  OUTPUT, 
@PINRequird tinyint  OUTPUT, 
@IPaddress  varchar(15) OUTPUT, 
@AgentID  int OUTPUT,
@isEnglish	tinyint  OUTPUT, 
@isSpanish	tinyint  OUTPUT, 
@isFrench	tinyint  OUTPUT, 
@LiveOpt	tinyint OUTPUT,
@PromptFileID   smallint OUTPUT,
@RateQuoteOpt	tinyint OUTPUT,
@maxCallTime	smallint  OUTPUT,
@DebitOpt	tinyint OUTPUT,
@OpSeqNo	bigint OUTPUT
 AS
SET NOCOUNT ON
Declare  @NPA varchar(3), @ANIdayRestrict tinyint, @ANITimeRestrict tinyint, @FacDayRestrict  tinyint, @FacTimeRestrict  tinyint , @localtime datetime, @day int, @h int, @DivisionID int, @locationID int,
	@AniPINReq  bit,  @LocationPINReq bit, @DivisionPINReq bit,  @facilityPINReq bit, @AniIDReq  bit,  @LocationIDReq bit, @DivisionIDReq bit,  @facilityIDReq bit,
	@DivisionTimeRestrict  bit,  @locationTimeRestrict bit 
Set  @localtime = getdate()
SET @day = datepart(dw, @localtime)
SET @h = datepart(hh, @localtime)
SET @facilityID = 2
SET @IDrequired =0
SET   @PINRequird  =0
SET  @IPaddress =''
SET @AgentID =0
SET  @isEnglish =1
SET  @isSpanish =0
SET  @isFrench =0
SET @RateQuoteOpt =0
SET @ANITimeRestrict =0
SET @FacDayRestrict =0
SET @ANIdayRestrict =0
SET @FacTimeRestrict =0
SET  @NPA = left(@tollFeeNo,3)

SELECT  @facilityID =  facilityID, @DivisionID=ISNULL( DivisionID,0), @locationID=ISNULL( LocationID,0),@ANIdayRestrict=ISNULL( DayTimeRestrict,0), @AniIDReq=ISNULL(IDrequired,0),  @AniPINReq  =ISNULL(PINRequired ,0)
		 from tblANIs  with(nolock) where ANIno =  @ANI
IF(@DivisionID >0)
	SELECT  @DivisionPINReq =ISNULL(PINRequired ,0) , @DivisionTimeRestrict= ISNULL( DayTimeRestrict,0)  From tblFacilityDivision with(nolock) where DivisionID = @DivisionID
IF(@LocationID >0)
	SELECT  @LocationPINReq =ISNULL(PINRequired ,0) , @LocationTimeRestrict= ISNULL( DayTimeRestrict,0)  From tblFacilityLocation with(nolock) where LocationID = @LocationID

---- Modify more on this
Select 	@IPaddress = F.IPaddress , @AgentID =F.AgentID,  @RateQuoteOpt = F.RateQuoteOpt, @FacDayRestrict  = F.DayTimeRestrict, @DebitOpt	= DebitOpt, @PINRequird = isnull(PINRequired,0),
		@isEnglish	=isnull(F.English ,1),@isSpanish= isnull( F.Spanish,0), @isFrench= isnull(F.French,0),@LiveOpt=isnull(  F.LiveOpt,0) ,  @PromptFileID=  F.PromptFileID  , @maxCallTime = maxCallTime
		From   tblFacility  F with(nolock) , tblPrompt  P with(nolock)
		where  F.FacilityID = @facilityID   and F.PromptFileID = P.PromptFileID
	


Insert tblCallAttempt (FromNo ,    DialedNo, FacilityID   , AgentID)  values(@ANI,@tollFeeNo, @facilityID, @AgentID)

SET @OpSeqNo  = SCOPE_IDENTITY()

If ( @AniPINReq >0  Or   @DivisionPINReq  > 0  OR   @LocationPINReq  > 0  Or  @PINRequird  > 0)   SET @PINRequird =1


If ( @ANIDayRestrict = 1) 
 begin
	IF( select count(*) from tblANITimeCall with(nolock) where ANI = @ANI and days = @day  and  hours & power(2, @h) >0) > 0
			Return -1
 end

If ( @LocationTimeRestrict = 1) 
 begin
	IF( select count(*) from tblLocationTimeCall with(nolock) where LocationID = @LocationID and days = @day  and  hours & power(2, @h) >0) > 0
			Return -1
 end

If ( @DivisionTimeRestrict = 1) 
 begin
	IF( select count(*) from tblDivisionTimeCall with(nolock) where DivisionID = @DivisionID and days = @day  and  hours & power(2, @h) >0) > 0
			Return -1
 end


If ( @FacDayRestrict = 1) 
 begin
	IF( select count(*) from tblFacilityTimeCall with(nolock) where facilityID = @facilityID and days = @day  and  hours & power(2, @h) >0) > 0
			Return -1
 end

