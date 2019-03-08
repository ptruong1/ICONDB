CREATE PROCEDURE [dbo].[p_verify_Debit_account3]
@accountNo	varchar(12),
@fromNo	char(10),
@PIN		varchar(12),
@InmateID   varchar(12),
@facilityID	int,
@userName	varchar(23),
@toNo		varchar(16),
@Minbilled   numeric(4,2),
@localTime datetime,
@RecordID  bigint,
@balance  	numeric(6,2)  OUTPUT
AS
Declare @DebitType	tinyint, @callType  char(2), @status tinyint,@CurrentPhone varchar(10) ;
SET @DebitType =0;
SET @balance =-1;
SET @status =0;
If(left(@toNo ,3) ='011'  or (select count(*) from tblNorthAmerica with(nolock) where NPA = left(@toNo ,3)) > 0 )
	SET @callType  = 'IN';
else
 	SET @callType  = 'DO';

select  @balance = balance,  @DebitType = isnull( DebitType,0),  @status =[status]   from tblDebit  with(nolock) where accountNo = @accountNo  and (FacilityID = @facilityID or FacilityID=1) ;




--if (@status =1)
 --begin
	If(@balance <@Minbilled)
	 begin
		EXEC  p_insert_unbilled_calls4   '','',  @fromNo ,@toNo,'07', 76,@PIN	,@InmateID ,@facilityID	,@userName, '', '',@accountNo , @localtime,'',@RecordID ;
		return 0;
	 end
	return 1;
-- end
--IF (@status >1)
-- Begin
--	SET @balance =0 ;
--	select @CurrentPhone = fromNo from tblInmateOncall with(nolock) where FacilityID=@facilityID and PIN= @PIN;
--	if(@CurrentPhone = @fromNo)
--	 begin
--		select  @balance = balance,  @DebitType = isnull( DebitType,0)   from tblDebit  with(nolock) where accountNo = @accountNo and username ='Oncall' and (FacilityID = @facilityID ) ;
--		if(@balance > 0)
--			set @status =1;
--	 end
--	else
--	 begin
--		EXEC  p_insert_unbilled_calls4   '','',  @fromNo ,@toNo,'07', 74,@PIN	,@InmateID ,@facilityID	,@userName, '', '',@accountNo , @localtime,'',@RecordID ;
--		return -1;
--	 end
-- end  
--If ( @status =0 or  @balance is NULL OR @balance=-1  OR  ( @callType ='IN' and  @DebitType =1) OR ( @callType  = 'DO'  and @DebitType =2))
-- Begin
--	EXEC  p_insert_unbilled_calls4   '','',  @fromNo ,@toNo,'07', 75,@PIN	,@InmateID ,@facilityID	,@userName, '', '',@accountNo , @localtime,'',@RecordID ;
--	SET @balance =-1;
--	Return -1;
--  End
--Return 0;
