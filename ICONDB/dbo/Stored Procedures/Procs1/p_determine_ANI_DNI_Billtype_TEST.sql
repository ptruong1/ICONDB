﻿CREATE PROCEDURE [dbo].[p_determine_ANI_DNI_Billtype_TEST]
@RecordID	bigint,
@ANI	char(10),
@DNI	varchar(16),
@PIN		varchar(12),
@facilityID	int,
@userName       varchar(23),
@AccountNo		varchar(12),
@Billtype		char(2)
AS
SET NOCOUNT ON
 Declare  @flatform tinyint, @i int , @lenDNI int, @TimeLimited  smallint ,@DialNo	varchar(16),@RecordOPT char(1), @timeZone smallint, @localtime datetime  ;
 SET @TimeLimited =0;
 SET @lenDNI = LEN(@DNI);
 SET @DialNo ='';
select @timeZone =isnull( timezone,0)  from tblfacility with(nolock) where facilityID =@facilityID;
Set  @localtime = dateadd(hh, @timeZone,getdate() );
 if(@lenDNI <7)  -- User use Speed Dial
   Begin
		Select @DialNo = DNI ,@TimeLimited=MaxCallTime  FROM [leg_Icon].[dbo].tblspeedDial with(nolock) where facilityID = @facilityID and speedDial=@DNI;
		if(LEN(@DialNo)<10)
		  begin
			
			EXEC  p_insert_unbilled_calls4   '','',  @ANI ,@DNI,@billtype, 8,@PIN	,0 ,@facilityID	,@userName, '', '','', @localtime,'',@RecordID;
			SET @TimeLimited =-1;
			Select '-2'  as AcessAllow , 'Y' as  RecordOpt,  @Billtype as  Billtype,  0 as  MaxDuration, 0 as firstMinute   ,0 as  nextMinute ,0 as connectFee  ,
				0 as Minduration ,	'NA' as CallType  ,'NA' as fromState	,'NA' as fromCity,'NA' as toState ,'NA'as toCity,'NA' as 	libCode,
				'NA' as ratePlanID ,		1	 as  Surcharge ,		1	as  Increment	,0  as Balance , @DNI as DNI;
			Return 0;
		  End
		
   end 
 Else if (@lenDNI =7) -- User Enter local phone without Area Code
   Begin
		SET @DialNo = LEFT(@ANI,3) + @DNI;
   End
 ELSE
   Begin
      SET @DialNo = @DNI;
   End
/*
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
	begin
		Select '-1'  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  0 as  MaxDuration, 0 as firstMinute   ,0 as  nextMinute ,0 as connectFee  ,
				0  as Minduration ,	'NA' as CallType  ,'NA' as fromState	,'NA' as fromCity,'NA' as toState ,'NA' as toCity,'XY' as 	libCode,
				'NA' as ratePlanID ,		0	 as  Surcharge ,		0	as  Increment	,0  as Balance , @DNI as DNI
		Return -1
	 End 
SET @Billtype =isnull(@Billtype,'01')
EXEC [dbo].[p_get_billtype_web_service1]
	@ANI	,
	@DialNo	,
	@PIN		,
	@facilityID	,
	@userName    ,
	@Billtype	,
	@AccountNo	,
	@RecordOPT	,
	@TimeLimited,
	@RecordID

*/
EXEC [dbo].[p_get_billtype_web_service2]
	@ANI	,
	@DialNo	,
	@PIN		,
	@facilityID	,
	@userName    ,
	@Billtype	,
	@AccountNo	,
	@RecordID	;
