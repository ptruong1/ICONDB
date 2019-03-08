


CREATE PROCEDURE  [dbo].[p_user_login]
@userName  varchar(20),
@password	varchar(20),
@IPaddress	varchar(16)
AS
SET NOCOUNT ON

Declare @loginID	bigint, @FacilityID int, @u varchar(20) , @p varchar(20), @agentID int 
set @FacilityID = 0
SET @agentID =0 
select @u = userID , @p = password , @FacilityID = FacilityID , @agentID= AgentID  from  tbluserprofiles   with(nolock) where  userID = @userName and password = @password and status =1

IF @FacilityID >0 and  dbo.fn_comp_string ( @u, @userName)  =1  and dbo.fn_comp_string (  @p,  @password)  =1  
Begin
	Insert tblUserLogs(UserName,Password,IPAddess,loginTime) 	Values(@userName,@password,@IPaddress,getdate())
	SET @loginID = @@identity 
	select FacilityID,  Location ,  Address, City, State, Phone , logo, PINRequired, AgentID,  @loginID as LoginID   from tblFacility with(nolock)
	where FacilityID = @FacilityID

End
Else IF   @agentID > 0 and  dbo.fn_comp_string ( @u, @userName)  =1  and dbo.fn_comp_string (  @p,  @password)  =1  
 Begin
	Insert tblUserLogs(UserName,Password,IPAddess,loginTime) 	Values(@userName,@password,@IPaddress,getdate())
	SET @loginID = @@identity 
	select 0, Company as  Location ,  Address1, City, StateCode as State, Phone , '',0 , AgentID,  @loginID as LoginID   from tblAgent with(nolock)
	where AgentID = @agentID
  End

