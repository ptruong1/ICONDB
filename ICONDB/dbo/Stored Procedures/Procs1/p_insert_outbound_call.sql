﻿
CREATE PROCEDURE [dbo].[p_insert_outbound_call]
@calldate  char(6) ,
@calltime   char(6), 
@projectCode  char(6),
@fromno  char(10),    
@tono  varchar(18),      
@billtype char(2),        
@Duration int, 
@OpSeqNo bigint
AS

Insert  tbloutboundcalls (OpSeqNo,calldate ,calltime, projectCode, fromno ,    tono ,      billtype,        Duration )
values (@OpSeqNo,@calldate ,@calltime, @projectCode, @fromno ,    @tono ,      @billtype,        @Duration)
If(@Duration >0 )
	Update  tblLivemonitor   SET  status = 'C',   duration =  @duration , LastUpdate = getdate()    where   projectcode = @projectcode and calldate = @calldate

