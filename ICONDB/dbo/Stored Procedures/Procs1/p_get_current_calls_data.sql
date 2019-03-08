
CREATE PROCEDURE [dbo].[p_get_current_calls_data]
 @projectcode char(6),
@calldate char(6)
AS
SET nocount on
declare @RecordID     bigint,     @ConnectTime  char(6)  , @FromNo char(10)   ,  @ToNo    varchar(18),            @BillToNo   varchar(10) , @MethodOfRecord  char(2),  @billType char(2) ,  @CallType char(2),
	 @FromState  char(2)  , @FromCity  varchar(10) , @ToState char(2), @ToCity  varchar(10),    @CreditCardType  varchar(1) ,  @CreditCardNo  varchar(16),       @CreditCardExp VARCHAR(4),
	 @CreditCardZip  VARCHAR(5),  @CreditCardCVV VARCHAR(4),  @CallPeriod  VARCHAR(1)  ,  @LibraryCode  VARCHAR(2) , @Indicator19  CHAR(1) ,  @SettlementCode CHAR(1) , @complete  CHAR(1),
               @errorCode CHAR(1) ,  @ratePlanID  VARCHAR(7)  ,  @firstMinute  SMALLMONEY,    @nextMinute  SMALLMONEY,   @connectFee  SMALLMONEY,  @minDuration  TINYINT,  @userName   VARCHAR(20), 
	   @RecordDate   DATETIME,   @TotalSurcharge SMALLMONEY  , @Dberror   CHAR(1) , @ResponseCode  VARCHAR(3) ,  @AuthName     VARCHAR(50), @Pif  NUMERIC(4,2),  @AgentID INT , @MinIncrement  TINYINT ,
	  @FolderDate  VARCHAR(12) ,  @Channel  VARCHAR(3) , @InmateID  BIGINT, @PIN BIGINT,                  @FacilityID  INT,  @InRecordFile         VARCHAR (20)

SELECT  *   FROM   tblcalls WITH(NOLOCK)   where  calldate = @calldate and projectcode = @projectcode

Return @@error
