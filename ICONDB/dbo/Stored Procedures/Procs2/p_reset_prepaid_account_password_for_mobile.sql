create proc p_reset_prepaid_account_password_for_mobile(@userName varchar(50), @email varchar(50), @result varchar(200) output) 
as
begin
	BEGIN TRY  
 		if exists(select * from tblEndusers where UserName=@userName and Email=@email)
		begin
			declare @passwordReset varchar(50);
			set @passwordReset ='temp' + SUBSTRING(@userName,0,4);
			-----------------------
			update tblEndusers 
			set Password=@passwordReset
			where UserName=@userName and Email=@email
			---------------------------------------------
			--declare @bodyText varchar(500);
			--set @bodyText ='Here is your temporary password:'+ CHAR(13) + 'Please login with your temp password with http://legacyinmate.com/ to edit your password.'
			--EXEC msdb.dbo.sp_send_dbmail @recipients = @email, @body = @bodyText, @subject = 'Password Recovery' ; 
			--------------------------------------------------------------------------------------
			set @result=@passwordReset;
		end	
		else 
			set @result= 'notmatch'
	END TRY  
	BEGIN CATCH  
		set @result = ERROR_MESSAGE();
	END CATCH;  
end
