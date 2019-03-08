-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_reset_password]
@UserID varchar(20),
@Email varchar(50),
@PhoneNumber nchar(10)
AS
BEGIN
	--Declare @Email varchar(50)
	Declare @TempPassword UniqueIdentifier 
	Declare @TempEmail varchar(50)
	If @UserID <> ''
	Begin
		    Select @TempEmail= Email from tblUserprofiles where UserID = @UserID
		    if @TempEmail is not null
				Begin
	       			set @TempPassword = NEWID()
					if exists(select * from tblResetPassword where UserID=@UserID)
						Begin
						   Update tblResetPassword set TempPassword = @TempPassword, RequestDate = GETDATE() where UserID =@UserID
						   Select 1 as ReturnCode,@UserID as UserID, @TempPassword as TempPass,  @TempEmail as Email
						End
					else
						Begin
							Insert into tblResetPassword(TempPassword, UserID, RequestDate)
							Values(@TempPassword, @UserID, GETDATE())
							Select 1 as ReturnCode,@UserID as UserID, @TempPassword as TempPass,  @TempEmail as Email
						End
			    End
				else
					Begin
						Select 0 as ReturnCode, Null as UserID, Null as TempPass, Null as Email
					End
End
   else if @UserID = ''
		Begin
			if @Email <> '' and @PhoneNumber <> ''
			Begin
					select @UserID = UserID, @TempEmail = Email from tblUserprofiles 
					    where Phone =@PhoneNumber and Email = @Email
					    If @TempEmail is not Null
		    		 		begin
								set @TempPassword = NEWID()
								if exists(select * from tblResetPassword where UserID=@UserID)
									  begin
										Update tblResetPassword set TempPassword = @TempPassword, RequestDate = GETDATE() where UserID =@UserID
										Select 1 as ReturnCode,@UserID as UserID, @TempPassword as TempPass,  @TempEmail as Email
									  end
						         else
									   begin
											Insert into tblResetPassword(TempPassword, UserID, RequestDate)
											Values(@TempPassword, @userID, GETDATE())
											Select 1 as ReturnCode,@UserID as UserID, @TempPassword as TempPass, @Email as Email
									   end
						     end
				        else
						   Begin
						     	Select 0 as ReturnCode,Null as UserID, Null as TempPass, Null as Email
						   End
			End
			Else
				Begin
					Select 0 as ReturnCode, Null as UserId, Null as TempPass, Null as Email
				End
	   End
	
END



--BEGIN
--	Declare @Email varchar(50)
--	Declare @TempPassword UniqueIdentifier 
	
--	Select @Email=Email
--	from tblUserprofiles where UserID = @userID
--	If (@Email is not null)
--		Begin
--		set @TempPassword = NEWID()
--			Insert into tblResetPassword(TempPassword, UserID, RequestDate)
--			Values(@TempPassword, @userID, GETDATE())
--			Select 1 as ReturnCode, @TempPassword as TempPass, @Email as Email
--		End
--	else
--	Begin
--		Select 0 as ReturnCode, @TempPassword as TempPass, @Email as Email
--	End
	
--END

