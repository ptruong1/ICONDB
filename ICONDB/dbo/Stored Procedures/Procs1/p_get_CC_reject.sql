CREATE PROCEDURE [dbo].[p_get_CC_reject] 
@CCno  varchar(16),
@ToNo	 varchar(15)
AS
If(@CCno <>'' and @ToNo<>'')
	select FromNo   ,  Tono   ,        ConnectDate, ConnectTime, Duration,  CCNo, CAST( Charge as numeric(6,2))/100 from  tblTBRreject where  ccno = @CCno and tono =@ToNo	 

else If(@CCno <>'')
	select FromNo   ,  Tono   ,        ConnectDate, ConnectTime, Duration,  CCNo, CAST( Charge as numeric(6,2))/100 from  tblTBRreject where  ccno = @CCno 

else
	select FromNo   ,  Tono   ,        ConnectDate, ConnectTime, Duration,  CCNo, CAST( Charge as numeric(6,2))/100 from  tblTBRreject where  tono =@ToNo	 
