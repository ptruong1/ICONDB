
CREATE PROCEDURE [dbo].[p_get_CallRecording1]
@userName	varchar(20),
@LastRecord	varchar(15),
@CurrentRecord	varchar(35)  OUTPUT

AS
Declare  @ip  varchar(25),   @Schannel  varchar(6) ,   @iChannel smallint,  @folder  varchar(10) ,  @RecordName varchar(15),  @RecordID bigint 
SET @CurrentRecord	=''


select    @ip  =  IpAddress   From tblACPs  where      ComputerName  =@userName	



SELECT top 1  @iChannel = Channel, @folder  = folderDate, @RecordName = RecordFile ,  @RecordID = recordID   FROM tblOncalls with(nolock)  
WHERE   username =  @ip   and  upload  is null   and   datediff(hh,RecordDate,getdate()) < 24  and  RecordFile <> 'NA' and duration >0  and Errorcode =0

update  tblOncalls set upload = 1 where   recordID = @RecordID
 
If @iChannel < 10   SET   @Schannel = 'Line0' +  cast(@iChannel  as char)
else    SET   @Schannel =   'Line' +  cast(@iChannel  as char (2))

SET @CurrentRecord	=  @Schannel  + '\' + @folder  + '\' +  @RecordName 

IF @CurrentRecord	 is null set @CurrentRecord	=''

