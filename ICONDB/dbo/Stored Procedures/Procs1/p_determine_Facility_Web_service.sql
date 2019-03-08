
CREATE PROCEDURE [dbo].[p_determine_Facility_Web_service]
@ANI	varchar(10)  

 AS
SET NOCOUNT ON
Declare  @NPA varchar(3), @ANIdayRestrict tinyint, @ANITimeRestrict tinyint, @FacDayRestrict  tinyint, @FacTimeRestrict  tinyint , @localtime datetime, @day int, @h int, @DivisionID int, @locationID int,
	@AniPINReq  bit,  @LocationPINReq bit, @DivisionPINReq bit,  @facilityPINReq bit, @AniIDReq  bit,  @LocationIDReq bit, @DivisionIDReq bit,  @facilityIDReq bit ,
	@DivisionTimeRestrict  bit,  @locationTimeRestrict bit ,  @nxx char(3), @timeZone smallint, @isFree int , @Fphone char(10)
Declare @facilityID  int  ,@PINRequird tinyint  ,@AgentID  int ,@isEnglish	tinyint ,@isSpanish	tinyint  ,@isFrench	tinyint  ,@LiveOpt	tinyint ,@PromptFileID   smallint ,@RateQuoteOpt	tinyint ,
	@maxCallTime	smallint  ,@DebitOpt	tinyint ,@OpSeqNo	bigint,@IncidentReportOpt tinyint ,@BlockCallerOpt tinyint ,@CollectwithCC	tinyint  ,@isprobono	tinyint ,@OverlayOpt	tinyint ,
	@TTYOpt	tinyint ,@DID		varchar(10) ,@UseFor	tinyint  ,@commOpt	tinyint 
SET @facilityID = 0

SET   @PINRequird  =0
SET @AgentID =0
SET  @isEnglish =1
SET  @isSpanish =0
SET  @isFrench =0
SET @RateQuoteOpt =0
SET @ANITimeRestrict =0
SET @FacDayRestrict =0
SET @ANIdayRestrict =0
SET @FacTimeRestrict =0
SET @IncidentReportOpt =0
SET  @BlockCallerOpt  =0
SET @isprobono =0
SET @OverlayOpt =0
SET @timeZone =0
SET @TTYOpt	=0
SET @LiveOpt	=0
SET @useFor	=0
SET @commOpt =0 
Set  @isFree = 0
SET @PromptFileID =2
SET @maxCallTime=15
SET @DebitOpt = 0
SET @CollectwithCC =1
SELECT  @facilityID =  facilityID, @DivisionID=ISNULL( DivisionID,0), @locationID=ISNULL( LocationID,0),@ANIdayRestrict=ISNULL( DayTimeRestrict,0), @AniIDReq=ISNULL(IDrequired,0),  @AniPINReq  =ISNULL(PINRequired ,0),
	   @UseFor =isnull( InforOpt,0 )  , @isFree = isnull(isFree,0)
		 from tblANIs  with(nolock) where ANIno =  @ANI;


If (@DID = ''   or @DID is null)  SET @DID =@ANI;

exec  p_create_RecordID  @OpSeqNo  OUTPUT;



Set  @localtime = dateadd(hh, @timeZone,getdate() );
SET @day = datepart(dw, @localtime);
SET @h = datepart(hh, @localtime);

if (@facilityID =0)
 Begin
	--EXEC p_insert_unbilled_calls4
	--					'',
	--					'',
	--					@ANI,
	--					'',
	--					'',
	--					9,
	--					'0',
	--					'0',
	--					@facilityID	,
	--					'',
	--					'',
	--					'',
	--					'',
	--					@localtime ,
	--					'NA',
	--					@OpSeqNo
	--select @facilityID as  facilityID ,@PINRequird as  PINRequird ,@AgentID as AgentID ,@isEnglish as 	English ,@isSpanish as Spanish ,@isFrench as French  ,@LiveOpt	as LiveOpt, @PromptFileID  as PromptID,
	--@RateQuoteOpt as  RateQuoteOpt,	@maxCallTime	as MaxDuration ,@DebitOpt as DebitOpt ,@OpSeqNo as  OpSeqNo, @IncidentReportOpt as  IncidentReportOpt  ,
	--@BlockCallerOpt as BlockCallerOpt  ,@CollectwithCC as  CollectwithCC ,@isprobono as  Probono, @OverlayOpt as OverlayOpt , @TTYOpt as  TTYOpt, @commOpt as  CommOpt, @DID as PhoneID, @UseFor as	InfoOpt
	--return -1
	SET @facilityID =610;
 End

IF(@DivisionID >0)
	SELECT  @DivisionPINReq =ISNULL(PINRequired ,0) , @DivisionTimeRestrict= ISNULL( DayTimeRestrict,0)  From tblFacilityDivision with(nolock) where DivisionID = @DivisionID;
IF(@LocationID >0)
	SELECT  @LocationPINReq =ISNULL(PINRequired ,0) , @LocationTimeRestrict= ISNULL( DayTimeRestrict,0)   From tblFacilityLocation with(nolock) where LocationID = @LocationID;

---- Modify more on this
Select 	 @AgentID =F.AgentID,  @RateQuoteOpt = F.RateQuoteOpt, @FacDayRestrict  = F.DayTimeRestrict, @DebitOpt	= DebitOpt, @PINRequird = isnull(PINRequired,0), @Fphone = phone, @timeZone = isnull( F.timeZone,0),
		@isEnglish	=isnull(F.English ,1),@isSpanish= isnull( F.Spanish,0), @isFrench= isnull(F.French,0),@LiveOpt=isnull(  F.LiveOpt,0) ,  @PromptFileID=  F.PromptFileID  , @maxCallTime = maxCallTime,
		@BlockCallerOpt =BlockCallerOpt , @IncidentReportOpt =IncidentReportOpt, @CollectwithCC = CollectwithCC, @isprobono = isnull(probono,0), @OverlayOpt = isnull(overlayOpt,0), @TTYopt = isnull(TYYOpt,0),
		@commOpt	= isnull(F.CommOpt,0) , @DID	=  F.DID
		From   tblFacility  F with(nolock) , tblPrompt  P with(nolock)
		where  F.FacilityID = @facilityID   and F.PromptFileID = P.PromptFileID
	
if(@DID = '' or @DID is null)  SET  @DID =@ANI

If ( @AniPINReq >0  Or   @DivisionPINReq  > 0  OR   @LocationPINReq  > 0  Or  @PINRequird  > 0)   SET @PINRequird =1

If ( @ANIDayRestrict = 1) 
 begin
	IF( select count(*) from tblANITimeCall with(nolock) where ANI = @ANI and days = @day  and  hours & power(2, @h) >0) > 0
		Begin
			--EXEC  p_insert_unbilled_calls   '','',  @ANI ,'' ,'', 9 ,''	,0 ,@facilityID	,'', '',''
			EXEC p_insert_unbilled_calls4
						'',
						'',
						@ANI,
						'',
						'',
						9,
						'0',
						'0',
						@facilityID	,
						'',
						'',
						'',
						'',
						@localtime ,
						'NA',
						@OpSeqNo
			
			set @facilityID = 0
			--Return -1
		End
 end

If ( @LocationTimeRestrict = 1) 
 begin
	IF( select count(*) from tblLocationTimeCall with(nolock) where LocationID = @LocationID and days = @day  and  hours & power(2, @h) >0) > 0
		Begin
			--EXEC  p_insert_unbilled_calls   '','',  @ANI ,'' ,'', 9 ,''	,0 ,@facilityID	,'', '',''
			EXEC p_insert_unbilled_calls4
						'',
						'',
						@ANI,
						'',
						'',
						9,
						'0',
						'0',
						@facilityID	,
						'',
						'',
						'',
						'',
						@localtime ,
						'NA',
						@OpSeqNo
			set @facilityID = 0
			--Return -1
		End
 end

If ( @DivisionTimeRestrict = 1) 
 begin
	IF( select count(*) from tblDivisionTimeCall with(nolock) where DivisionID = @DivisionID and days = @day  and  hours & power(2, @h) >0) > 0
		Begin
			--EXEC  p_insert_unbilled_calls   '','',  @ANI ,'' ,'', 9 ,''	,0 ,@facilityID	,'', '',''
			EXEC p_insert_unbilled_calls4
						'',
						'',
						@ANI,
						'',
						'',
						9,
						'0',
						'0',
						@facilityID	,
						'',
						'',
						'',
						'',
						@localtime ,
						'NA',
						@OpSeqNo
			set @facilityID = 0
			--Return -1
		End
 end


If ( @FacDayRestrict = 1) 
 begin
	IF( select count(*) from tblFacilityTimeCall with(nolock) where facilityID = @facilityID and days = @day  and  hours & power(2, @h) >0) > 0
		Begin
			--EXEC  p_insert_unbilled_calls   '','',  @ANI ,'' ,'', 9 ,''	,0 ,@facilityID	,'', '',''
			EXEC p_insert_unbilled_calls4
						'',
						'',
						@ANI,
						'',
						'',
						9,
						'0',
						'0',
						@facilityID	,
						'',
						'',
						'',
						'',
						@localtime ,
						'NA',
						@OpSeqNo
			set @facilityID = 0
			--Return -1
		End
 end
if(select count(*) from tblFreeANIs with(nolock)  where facilityID = @facilityID and ANI = @ANI) > 0
	SET @UseFor =3
select @facilityID as  facilityID ,@PINRequird as  PINRequird ,@AgentID as AgentID ,@isEnglish as 	English ,@isSpanish as Spanish ,@isFrench as French  ,@LiveOpt	as LiveOpt, @PromptFileID  as PromptID,
	@RateQuoteOpt as  RateQuoteOpt,	@maxCallTime	as MaxDuration ,@DebitOpt as DebitOpt ,@OpSeqNo as  OpSeqNo, @IncidentReportOpt as  IncidentReportOpt  ,
	@BlockCallerOpt as BlockCallerOpt  ,@CollectwithCC as  CollectwithCC ,@isprobono as  Probono, @OverlayOpt as OverlayOpt , @TTYOpt as  TTYOpt, @commOpt as  CommOpt, @DID as PhoneID, @UseFor as	InfoOpt
