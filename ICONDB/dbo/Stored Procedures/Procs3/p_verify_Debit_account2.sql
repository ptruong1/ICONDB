CREATE PROCEDURE [dbo].[p_verify_Debit_account2]
@accountNo	varchar(12),
@fromNo	char(10),
@PIN		varchar(12),
@facilityID	int,
@userName	varchar(23),
@projectcode	char(6),
@billtype	char(2),
@toNo		varchar(16),
@balance  	numeric(6,2)  OUTPUT
AS
Declare @DebitType	tinyint, @callType  char(2), @CurrentPhone varchar(10), @status tinyint;
SET @DebitType =0;
SET @balance =-1;
SET @status =0;
If(left(@toNo ,3) ='011'  or (select count(*) from tblNorthAmerica with(nolock) where NPA = left(@toNo ,3)) > 0 )
	SET @callType  = 'IN';
else
 	SET @callType  = 'DO';

-- Edit on 10/12/2017
select  @balance = balance,  @DebitType = isnull( DebitType,0),  @status= [status]   from tblDebit  with(nolock) where accountNo = @accountNo  and (FacilityID = @facilityID or FacilityID=1) ;
-- New Update 8/9/2013

if(@status> 1)
 begin
	
	--select @CurrentPhone = fromNo from tblInmateOncall with(nolock) where FacilityID=@facilityID and InmateID= @PIN ;
	--if(@CurrentPhone <> @fromNo)
	-- begin
		If (@status =3)
		 begin
			if(select count(*) from tblDebit  with(nolock) where accountNo = @accountNo and datediff(MINUTE,modifyDate,getdate()) <20) > 0
			 begin
				SET @balance =-3;
				return -1;
			 end
		 end
		Else
		 begin
			SET @balance =-1;
		 end
	-- end
		--select  @balance = balance,  @DebitType = isnull( DebitType,0)   from tblDebit  with(nolock) where accountNo = @accountNo and username ='Oncall' and (FacilityID = @facilityID ) ;
 end
If (@balance >0 and (@status in(1,2,3)))
 begin
	Update tblDebit  set [status]=3, modifyDate =getdate()  where accountNo = @accountNo;
 end

If (  @balance is NULL OR @balance=-1  OR  ( @callType ='IN' and  @DebitType =1) OR ( @callType  = 'DO'  and @DebitType =2))
 Begin
	--EXEC  p_insert_unbilled_calls1   '','',  @fromno ,@toNo,@billtype, 7,@PIN	,0 ,@facilityID	,@userName, '', @projectcode, @accountNo	;
	SET @balance =-1;
	Return -1;
  End

Return 0;
