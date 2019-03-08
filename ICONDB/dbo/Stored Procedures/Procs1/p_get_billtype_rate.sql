CREATE PROCEDURE [dbo].[p_get_billtype_rate]
@ANI	char(10),
@DNI	varchar(16),
@PIN		varchar(12), -- ACP pass in InmateID
@facilityID	int,
@userName       varchar(23),
@Billtype	char(2) ,
@AcessAllow smallint,
@MaxDuration smallint,
@RecordOPT  varchar(1),
@Balance numeric(7,2)


AS
SET nocount on;
Declare    @i int;
Declare   @firstMinute   numeric(4,2), @Duration int, @Minbilled numeric(5,2),@AgentID int,
	  @nextMinute   numeric(4,2) ,	@connectFee numeric(4,2)  ,	@Minduration 	smallint ,	@CallType   char(2) ,	@fromState	varchar(2) ,	@fromCity	varchar(10) ,@InmateID varchar(12),
	   @toState	varchar(2) ,	@toCity		varchar(10) ,	@libCode	varchar(2) ,	@ratePlanID	varchar(7)  ,	@Surcharge	Numeric(4,2),@Increment	tinyint ,@state varchar(2)	;
SET @firstMinute  =0;
SEt @nextMinute  =0;
SET	@connectFee =0;
Set @Minduration 	=1;
SET @CallType  =  'LC';
SET @fromState	='';
SET @fromCity	 ='';
SET @toState	='';
SET @toCity		='';
SET @libCode	='XY';
SET @ratePlanID	='';
SET @Surcharge	=0;
SET @Increment	=1;
SET @duration =0;
SET @Minduration=1;
SET @i = 0 ;

EXEC  @i = p_calculate_Rate_Surcharge4
			@ANI  ,
			@DNI	,
			@FacilityID	,
			@billType,
			@PIN	,
			@userName	,
			@firstMinute   OUTPUT,
			@nextMinute   OUTPUT,
			@connectFee   OUTPUT,
			@Minduration 	 OUTPUT,
			@CallType     OUTPUT,
			@fromState	 OUTPUT,
			@fromCity	 OUTPUT,
			@toState	OUTPUT,
			@toCity		 OUTPUT,
			@libCode	OUTPUT,
			@ratePlanID	OUTPUT,
			@Surcharge	 OUTPUT, 
			@Increment	OUTPUT;

if( @i =-1)		SET @AcessAllow = -2;			
		
		
	Select @AcessAllow  as AcessAllow ,  @RecordOPT as  RecordOpt,  @Billtype as  Billtype,  @MaxDuration   as  MaxDuration, @firstMinute as firstMinute   ,@nextMinute as  nextMinute ,@connectFee as connectFee  ,
		@Minduration  as Minduration ,	@CallType as CallType  ,@fromState as fromState	,@fromCity as fromCity,@toState as toState ,@toCity as toCity,@libCode as 	libCode,
		@ratePlanID as ratePlanID ,		@Surcharge	 as  Surcharge ,		@Increment	as  Increment	,@Balance  as Balance, @DNI as DNI;
	Return 1;
		 
	
 
