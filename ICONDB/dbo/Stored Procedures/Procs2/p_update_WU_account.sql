
CREATE PROCEDURE [dbo].[p_update_WU_account]

 AS

 declare @fname varchar(10), @str_move   varchar(200),  @str_rename  varchar(200)
Declare  @return_value int, @nextID int, @ID int, @tblWUpaymentTrans nvarchar(32) ;
If (select count(*)  from   tblWUpaymentTemp ) > 0
 	 begin
		update tblprepaid Set balance = balance + cast(  PaymentAmt as numeric(6,2) ) , ModifyDate = getdate() ,  PaymentTypeID=4 from   tblWUpaymentTemp 
		  where tblprepaid.phoneNo = tblWUpaymentTemp.CustAcctNo  
		select @fname =  WUfileName  from tblWUoutput order by fileID asc
		
		SET @str_move = 'move  C:\WU\Output\CurentImport.txt   C:\WU\Output\Archive\' 
			EXEC master.dbo.xp_cmdshell   @str_move
			SET @str_rename   = 'rename   C:\WU\Output\Archive\CurentImport.txt  ' +  @fname +'.DONE'
			EXEC  master.dbo.xp_cmdshell  @str_rename
			 EXEC   @return_value = p_create_nextID 'tblWUpaymentTrans', @nextID   OUTPUT
				set           @ID = @nextID ;  
		insert tblWUpaymentTrans(TransID, CustAcctNo , CustName ,Address , City , State ,zip ,Phone, MTCN ,PaymentAmt ,TransDate  ,AgentZip,Comment ,  ClientID )
			select @ID, CustAcctNo , CustName ,Address , City , State ,zip ,Phone, MTCN ,PaymentAmt ,TransDate  ,AgentZip,Comment ,  ClientID    
			 from tblWUpaymentTemp 
	 End


--declare @fname varchar(10), @str_move   varchar(200),  @str_rename  varchar(200)
--If (select count(*)  from   tblWUpaymentTemp ) > 0
-- 	 begin
--		update tblprepaid Set balance = balance + cast(  PaymentAmt as numeric(6,2) ) , ModifyDate = getdate() ,  PaymentTypeID=4 from   tblWUpaymentTemp 
--		  where tblprepaid.phoneNo = tblWUpaymentTemp.CustAcctNo  
--		select @fname =  WUfileName  from tblWUoutput order by fileID asc
		
--		SET @str_move = 'move  C:\WU\Output\CurentImport.txt   C:\WU\Output\Archive\' 
--			EXEC master.dbo.xp_cmdshell   @str_move
--			SET @str_rename   = 'rename   C:\WU\Output\Archive\CurentImport.txt  ' +  @fname +'.DONE'
--			EXEC  master.dbo.xp_cmdshell  @str_rename
--		insert tblWUpaymentTrans( CustAcctNo , CustName ,Address , City , State ,zip ,Phone, MTCN ,PaymentAmt ,TransDate  ,AgentZip,Comment ,  ClientID )
--			select CustAcctNo , CustName ,Address , City , State ,zip ,Phone, MTCN ,PaymentAmt ,TransDate  ,AgentZip,Comment ,  ClientID    
--			 from tblWUpaymentTemp 
--	 End

