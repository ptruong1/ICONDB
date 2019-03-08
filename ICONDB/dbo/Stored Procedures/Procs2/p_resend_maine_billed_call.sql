-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_resend_maine_billed_call]
@PIN varchar(12)  OUTPUT,
@InmateID varchar(12) OUTPUT,
@FromNo varchar(10) OUTPUT,
@Tono varchar(18) OUTPUT,
@duration int OUTPUT,
@Charge numeric(5,2) OUTPUT, 
@ReferenceNo	varchar(14) OUTPUT,
@APItype tinyint OUTPUT

AS
BEGIN
	Declare @i int;
	SET @i =0;
	SET @PIN ='';

	select distinct top 1 @PIN=PIN,@InmateID=InmateID,@FromNo= Fromno,@Tono=Tono,@duration= Duration,@Charge= charge,@ReferenceNo = cast(ReferenceNo as varchar(14)),@APItype =3 from tblMaineLogs a with(nolock) where dateDiff(MINUTE,RecordDate, getdate()) > 5 and dateDiff(HOUR,RecordDate, getdate()) <1  and APItype=3  and Error_ID ='999' and PIN  not in ('' ,'04041969')
		and Log_ID='0' and ReferenceNo not in (select ReferenceNo from  tblMaineLogs with(nolock) where  dateDiff(HOUR,RecordDate, getdate()) <2 and APItype =3  and Error_ID <> '999' and  PIN =a.PIN );
	
	if(@PIN ='')
		select distinct top 1 @PIN=a.PIN,@InmateID=a.InmateID,@FromNo= a.Fromno,@Tono=a.Tono,@duration= (b.Duration)/60,@Charge=0.09 * ((b.Duration)/60) ,@ReferenceNo = cast(ReferenceNo as varchar(14)), @APItype = 3  from tblMaineLogs a with(nolock), tblcallsbilled b with(nolock)  where a.referenceNo= b.RecordID and dateDiff(MINUTE,a.RecordDate, getdate()) > 60 and dateDiff(MINUTE,a.RecordDate, getdate()) <120  and APItype=2  and  a.PIN   not in ('' ,'04041969')
		and ReferenceNo not in (select ReferenceNo from  tblMaineLogs with(nolock) where  dateDiff(MINUTE,RecordDate, getdate()) <120  and APItype=3  and Error_ID in ('0','113','121','102','127','121','115','128', '114') and PIN =a.PIN);
 
	if(@PIN ='')
		select distinct top 1 @PIN=PIN,@InmateID=InmateID,@FromNo= Fromno,@Tono=Tono,@duration= Duration,@Charge= charge,@ReferenceNo = cast(ReferenceNo as varchar(14)),@APItype = APItype from tblMaineLogs a with(nolock) where dateDiff(MINUTE,RecordDate, getdate()) > 2 and dateDiff(MINUTE,RecordDate, getdate()) <5  and APItype=2  and Error_ID ='999' and PIN  not in ('' ,'04041969')
		and Log_ID='0' and ReferenceNo not in (select ReferenceNo from  tblMaineLogs with(nolock) where  dateDiff(MINUTE,RecordDate, getdate()) <60  and  Error_ID <> '999' and  PIN =a.PIN );


	/*
	if(@PIN='')
	 begin
		select distinct top 1 @PIN=PIN,@InmateID=InmateID,@FromNo= Fromno,@Tono=Tono,@duration= Duration-1,@Charge= charge  ,@ReferenceNo = cast(ReferenceNo as varchar(14))  from tblMaineLogs a with(nolock) where dateDiff(MINUTE,RecordDate, getdate()) > 3 and dateDiff(HOUR,RecordDate, getdate()) <24  and APItype=3  and Error_ID ='128' and PIN  not in ('' ,'04041969')
		and charge > 0 and ReferenceNo not in (select ReferenceNo from  tblMaineLogs with(nolock) where  dateDiff(HOUR,RecordDate, getdate()) <24 and APItype=3  and Error_ID in ('0','113','121','102','121','115') and  PIN =a.PIN );
		SET @Charge = @duration* 0.09;
	 end
  
    if(@PIN='')
	 begin
		select distinct top 1 @PIN=PIN,@InmateID=InmateID,@FromNo= Fromno,@Tono=Tono,@duration= 1 ,@Charge= 0.09  ,@ReferenceNo = cast(ReferenceNo as varchar(14))  from tblMaineLogs a with(nolock) where dateDiff(MINUTE,RecordDate, getdate()) > 3 and dateDiff(HOUR,RecordDate, getdate()) <24  and APItype=3  and Error_ID ='128' and PIN  not in ('' ,'04041969')
		and charge = 0 and ReferenceNo not in (select ReferenceNo from  tblMaineLogs with(nolock) where  dateDiff(HOUR,RecordDate, getdate()) <24 and APItype=3  and Error_ID in ('0','113','121','102','121','115') and  PIN =a.PIN );
		SET @Charge = @duration* 0.09;
	 end
	    if(@PIN ='')
		select distinct top 1 @PIN=PIN,@InmateID=InmateID,@FromNo= Fromno,@Tono=Tono,@duration= Duration,@Charge= charge,@ReferenceNo = cast(ReferenceNo as varchar(14))  from tblMaineLogs a with(nolock) where dateDiff(MINUTE,RecordDate, getdate()) > 5 and dateDiff(HOUR,RecordDate, getdate()) <1  and APItype=3  and Error_ID  = '0' and PIN  not in ('' ,'04041969')
		and ReturnValue=-1 and  ReferenceNo not in (select ReferenceNo from  tblMaineLogs with(nolock) where  dateDiff(HOUR,RecordDate, getdate()) <1  and APItype=3  and ReturnValue=0 and PIN =a.PIN);
      if(@PIN ='')
		select distinct top 1 @PIN=PIN,@InmateID=InmateID,@FromNo= Fromno,@Tono=Tono,@duration= Duration-1,@Charge= charge-0.09,@ReferenceNo = cast(ReferenceNo as varchar(14))  from tblMaineLogs a with(nolock) where dateDiff(MINUTE,RecordDate, getdate()) > 5 and dateDiff(HOUR,RecordDate, getdate()) <1  and APItype=3  and Error_ID  = '115' and PIN  not in ('' ,'04041969')
		and ReturnValue=-1 and Charge >0 and ReferenceNo not in (select ReferenceNo from  tblMaineLogs with(nolock) where  dateDiff(HOUR,RecordDate, getdate()) <1  and APItype=3  and PIN =a.PIN and Error_ID='0' ); 
      if(@PIN ='')
		select distinct top 1 @PIN=a.PIN,@InmateID=a.InmateID,@FromNo= a.Fromno,@Tono=a.Tono,@duration=  (b.Duration)/60,@Charge=0.09 * ((b.Duration)/60), @ReferenceNo = cast(ReferenceNo as varchar(14))  from tblMaineLogs a with(nolock),  tblcallsbilled b with(nolock)  where a.referenceNo= b.RecordID and dateDiff(MINUTE,a.RecordDate, getdate()) > 60  and dateDiff(HOUR,a.RecordDate, getdate()) < 8  and APItype=2  and Error_ID  = '0' and a.PIN   not in ('' ,'04041969')
		and ReferenceNo not in (select ReferenceNo from  tblMaineLogs with(nolock) where  dateDiff(HOUR,RecordDate, getdate()) <8 and  APItype=3  and PIN =a.PIN and Error_ID in ('0','113' ,'121','128'));
       if(@PIN ='')
		select distinct top 1 @PIN=a.PIN,@InmateID=a.InmateID,@FromNo= a.Fromno,@Tono=a.Tono,@duration= 1,@Charge=0.9 , @ReferenceNo = cast(ReferenceNo as varchar(14))  from tblMaineLogs a with(nolock) where dateDiff(MINUTE,a.RecordDate, getdate()) > 60  and dateDiff(HOUR,a.RecordDate, getdate()) < 10  and APItype=2  and Error_ID  = '0' and a.PIN   not in ('' ,'04041969')
		and ReferenceNo not in (select ReferenceNo from  tblMaineLogs with(nolock) where  dateDiff(HOUR,RecordDate, getdate()) <10 and  APItype=3  and PIN =a.PIN and Error_ID in ('0','113' ,'121','128'));
        if(@PIN ='')
		select distinct top 1 @PIN=a.PIN,@InmateID=a.InmateID,@FromNo= a.Fromno,@Tono=a.Tono,@duration=CEILING( duration/60),@Charge=CallRevenue , @ReferenceNo = cast(RecordID as varchar(14))  from tblcallsbilled a with(nolock) where dateDiff(MINUTE,a.RecordDate, getdate()) > 3  and dateDiff(HOUR,a.RecordDate, getdate()) < 10  and AgentID =7
		and RecordID not in (select ReferenceNo from  tblMaineLogs with(nolock) where  dateDiff(HOUR,RecordDate, getdate()) <15 and  APItype=3  and PIN =a.PIN  );
        if(@PIN ='') -- Hard code to clear a call
		  BEGIN
			SET @PIN='957398' ;
			SET @InmateID='63768';
			SET @FromNo= '2072731173';
			SET @Tono='2078690676';
			SET @duration=0;
			SET @Charge=0 ;
			SET @ReferenceNo ='131112432' ;
		  END 
	  If(@PIN ='')
	   begin
		    select @PIN= a.PIN, @i= count(*) from  tblMaineLogs a where  dateDiff(MINUTE,a.RecordDate, getdate()) > 60 and dateDiff(HOUR,RecordDate, getdate()) < 3  and error_ID='114'  and 
			PIN not in (select PIN from  tblMaineLogs with(nolock) where  dateDiff(HOUR,RecordDate, getdate()) <3 and  APItype=3 and Error_ID in ('0','113' ,'121','120'))
			group by  PIN having  count(*)  >6; 
			 If(@PIN <>'')
			  begin
				select  @PIN=a.PIN,@InmateID=a.InmateID,@FromNo= a.Fromno,@Tono=a.Tono,@duration= 1,@Charge=0 , @ReferenceNo = cast(ReferenceNo as varchar(14))  from tblMaineLogs a with(nolock)
				 where  dateDiff(HOUR,RecordDate, getdate()) <3 and PIN=@PIN
			  end 
	   end

      if(@duration <=0)
		SET @duration=1;

	*/
END

