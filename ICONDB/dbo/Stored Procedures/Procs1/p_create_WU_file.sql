
CREATE PROCEDURE [dbo].[p_create_WU_file] 

 AS

declare  @recount int, @l_recount char(6) , @CustSeqNo int

truncate table  tempWU

if ( select count(*)  From tblWUPrepaid  where upLoadFTP =0)  > 0
 Begin

	INSERT INTO tempWU (	[CustSeqNo] ,
					[RecordType],
					[PSCNo] ,
					[ClientID] ,
					[CustAcctNo],
					[FirstName] ,
					[LastName],
					[Address] ,
					[City],
					[State] ,
					[Zip],
					[Country] ,
					[Phone],
					[ProcessType],
					[IssueCard])
	
	select 
					[CustSeqNo] ,
					[RecordType],
					[PSCNo] ,
					[ClientID] ,
					[CustAcctNo],
					[FirstName] ,
					[LastName],
					[Address] ,
					[City],
					[State] ,
					left([Zip],5)  + '0000',
					[Country] ,
					[Phone],
					[ProcessType],
					[IssueCard]  From tblWUPrepaid  where upLoadFTP =0  order by CustSeqNo 
	
	Select @recount = count(*) from  tempWU
	SET @l_recount =  dbo.fn_NumRec( @recount)   
	select @CustSeqNo = CustSeqNo from   tempWU  order by CustSeqNo
	
	INSERT INTO tempWU  (	CustSeqNo, 
					[RecordType],
					[PSCNo] ,
					[ClientID] ,
					[CustAcctNo],
					
					processType	 )
					
	
			values(		@CustSeqNo + 1,
					'T',
					 @l_recount + 'ALA4671790' ,
					'000000000',
					'0000000000000000000000',
					
					' ' )
	
	update  tblWUPrepaid  SET upLoadFTP = 1  from tempWU where tempWU.CustAcctNo = tblWUPrepaid.CustAcctNo
	
	EXEC p_writeWURecordToFile 

End
--select * from   ##tempWU
--drop table ##tempWU
