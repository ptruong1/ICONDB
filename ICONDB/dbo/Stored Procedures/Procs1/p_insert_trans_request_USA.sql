CREATE PROCEDURE [dbo].[p_insert_trans_request_USA]
@transType tinyint ,
@cNum         varchar(19),
@cExp 	char(4),
@cZipcode       varchar(5),
@cCvv		varchar(4),
@cHolderName       varchar(50),
@cAddress                          varchar(100),
@cCity                  varchar(50),
@cState           varchar(20),
@cCountry             varchar(30),
@cPhone     varchar(10),
@billAmount	 varchar(10),
@cType int	OUTPUT, 
@transID varchar(10)  OUTPUT,
@MerchantProfileID	varchar(15),
@deviceID	varchar(15) OUTPUT,
@LoginID	varchar(15) OUTPUT,
@password	varchar(15) OUTPUT,
@pin		varchar(5) OUTPUT,
@sourceKey	varchar(40) OUTPUT
 AS

Set NOCOUNT ON
Declare  @Abv char(1), @Amount	 numeric(10,2)  ,@iFraud  int
set @transID  =''
set @iFraud =0
SET @cType  =0

if ((isnumeric(@cCvv) = 0  or isnumeric(@cNum) = 0 )   AND @transType =1)
 begin
	SET @transID=''
	return -2
 end

exec @iFraud =  p_Fraud_control2 @MerchantProfileID, @cNum, @cPhone ,@transType,@deviceID  Output, @LoginID output, @password output,@pin OUTPUT,@sourceKey	OUTPUT

If(@iFraud =0)
 begin
	if(@transType =1 or @transType=2 or @transType=4)
		exec   @cType =p_get_creditCard_type @cNum
	exec  p_create_transOrderID @transID   output
	select  @Abv = Abv from tblTranstype with(nolock) where TransTypeID=@transType
	SET @transID = @Abv +  @transID
	SET  @Amount	= cast(@billAmount as numeric(10,2))
	Insert tblBCRequest(RequestTransID,    transDate  ,        transType, cType ,cNum     ,           cExp,cZipcode  ,   cCvv, cHolderName    ,   cAddress     ,  cCity ,   cState    ,  cCountry     ,     cPhone,Amount,MerchantProfileID )
	values(    @transID ,getdate(), @transType,@cType ,@cNum ,@cExp ,@cZipcode   ,@cCvv		,@cHolderName     ,@cAddress  ,@cCity   ,@cState     ,@cCountry ,@cPhone,@Amount,@MerchantProfileID  )
 end
if (((@cType <=0    or  @iFraud <0 )  AND @transType =1))
 Begin
	 EXEC p_insert_trans_response
		'R',
		'R',
		@transType		,
		@cType		,
		@cNum            		,
		@cExp 			,
		@cZipcode                    ,
		@cCvv 			,
		@cPhone     		,
		@Amount      		,
		0,
		'',	
		'',	
		'',	
		'',		
		'',
		'911',
		'Negative DB',
		@MerchantProfileID,
		0
	SET  @iFraud =-2
 end

Return  @iFraud
