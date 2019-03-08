CREATE PROCEDURE [dbo].[p_determine_ANI_DNI_Billtype1]
@RecordID	bigint,
@ANI	char(10),
@DNI	varchar(16),
@PIN		varchar(12),
@facilityID	int,
@userName       varchar(23),
@AccountNo		varchar(12),
@Billtype	char(2)  OUTPUT,
@RecordOPT	char  OUTPUT,
@TimeLimited  smallint  OUTPUT,
@DialNo	varchar(16)  OUTPUT
AS
SET NOCOUNT ON
 Declare  @flatform tinyint, @i int , @lenDNI int
 SET @TimeLimited =0
 SET @lenDNI = LEN(@DNI)
 if(@lenDNI= 3)
   Begin
		Select @DialNo = DNI ,@TimeLimited=MaxCallTime  FROM [leg_Icon].[dbo].tblspeedDial with(nolock) where facilityID = @facilityID and speedDial=@DNI
		if(LEN(@DialNo)<10)
		  begin
			SET @TimeLimited =-1
			Return 0
		  End
		
   end 
  Else if (@lenDNI =7)
   Begin
		SET @DialNo = LEFT(@ANI,3) + @DNI
   End
  ELSE
   Begin
      SET @DialNo = @DNI
   End
 
	EXEC @i= [p_determine_ANI_DNI_RecordID]
		@RecordID,
		@ANI	,
		@DialNo	,
		@PIN		,
		@facilityID	,
		@userName       ,
		@Billtype	 OUTPUT,
		@RecordOPT	  OUTPUT,
		@TimeLimited   OUTPUT
	
	
if (@i=-1 or @i = 1)
	 Begin
		EXEC  p_insert_unbilled_calls2   '','',  @ANI ,@DNI,@billtype, 9,@PIN	,0 ,@facilityID	,@userName, '', '','', 0
			Select '-1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  0 as  MaxDuration, 0 as firstMinute   ,0 as  nextMinute ,0 as connectFee  ,
				0  as Minduration ,	'NA' as CallType  ,'NA' as fromState	,'NA' as fromCity,'NA' as toState ,'NA' as toCity,'XY' as 	libCode,
				'NA' as ratePlanID ,		0	 as  Surcharge ,		0	as  Increment	,0  as Balance , @DNI as DNI
			Return -1
	 End 
SET @Billtype =isnull(@Billtype,'01')
EXEC [dbo].[p_get_billtype_web_service1]
	@ANI	,
	@DNI	,
	@PIN		,
	@facilityID	,
	@userName    ,
	@Billtype	,
	@AccountNo	,
	@RecordOpt	,
	@TimeLimited	
