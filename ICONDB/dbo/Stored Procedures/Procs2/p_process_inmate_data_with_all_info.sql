
CREATE PROCEDURE [dbo].[p_process_inmate_data_with_all_info]
@BookingNo	varchar(12),
@InmateID	varchar(12),
@PIN	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@status		tinyint,
@facilityFolder	varchar(20),
@AtLocation	varchar(20),
@ReleaseDate varchar(12),
@ChargeCode   varchar(12),
@AccountBalance numeric(10,2),
@ChargeDesript  varchar(200),
@BondType		varchar(25),
@BondAmount		 Numeric(10,2),
@OffenseDate	varchar(12),
@ChargeAgency	varchar(200),
@ArrestAgency   varchar(200),
@courtDate		varchar(12)


AS

SET NOCOUNT ON;
Declare @facilityId int, @flatform int, @sendStatus tinyint, @autoPin tinyint, @AtCurrLoc varchar(20), @i tinyint, @locationID int, @fullName varchar(50);
set @facilityId =1;
SET @flatform = 2;
SET @sendStatus =0;
SET @autoPin =0;
SET @AtCurrLoc ='';
SET @locationID =0;
select @facilityId = FacilityID ,@sendStatus= isnull(inmateStatus,0),@autoPin= isnull(autoPin ,0) from tblFacilityOption with(nolock)  where FTPfolderName = @facilityFolder	;


if (@autoPin =0)
	exec [leg_Icon].[dbo].[p_process_inmate_data_with_PIN] 
		@InmateID	,	@PIN	,	@firstName	,	@lastName	,	@MidName	,
		@status		,	@facilityId,	@sendStatus,	@AtLocation	,	@ReleaseDate ,	@AccountBalance ;

else
	exec [leg_Icon].[dbo].[p_process_inmate_data_with_autoPIN1]
		@InmateID	,	@PIN	,	@firstName	,	@lastName	,	@MidName	,
		@status		,	@facilityId,	@sendStatus ;


If(@ChargeDesript<>'')
 begin
    SET  @fullName =  @FirstName + ' ' + @LastName;
	EXEC [p_inmate_info_v2]
					@facilityID ,
					@PIN    ,
					@InmateID ,
					 @fullName,
					'',
					@BookingNo  ,

					@OffenseDate ,
					'',
					'',
					'',
					'',
					'',
					@AtLocation         ,

					@ChargeCode   ,
					@ChargeDesript  ,
					'0' ,
					'' , 
					'' , 
					'', 
					@BondAmount ,
					'',
					@OffenseDate,
					@ReleaseDate ,
					@OffenseDate,

					@bondType,
					'',
					'',

					11,
					0,
					'',
					'',
					@courtDate


 end




