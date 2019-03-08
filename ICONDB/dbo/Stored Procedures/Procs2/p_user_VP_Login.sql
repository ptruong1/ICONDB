CREATE PROCEDURE  [dbo].[p_user_VP_Login]
@userName  varchar(20),
@password	varchar(20),
@IPaddress	varchar(16)

AS
SET NOCOUNT ON

Declare @loginID	bigint, @FacilityID int, @u varchar(20) , @p varchar(20), @agentID int , @userLevel   tinyint , @transcriptOpt	tinyint,@authID int,
 @IPaddressDB  varchar(16), @EnCryptUser varbinary(200),@EnCryptPass  varbinary(200)
SET @FacilityID = 0
SET @agentID =0 
SET @userLevel  =0
SET @transcriptOpt	= 0
--select @u = userID , @p = password , @FacilityID = FacilityID , @agentID= AgentID, @userLevel =userLevel  , @IPaddressDB = isnull(IPaddress,'') 
--	  from  tbluserprofiles   with(nolock) where  userID = @userName and password = @password  and status =1

EXEC [dbo].[LegEncrypt] @password,	@EnCryptPass  OUTPUT
--exec [dbo].[LegEncrypt] @Username,	@EnCryptUser  OUTPUT
select @u = userID , @p = password , @FacilityID = FacilityID , @agentID= AgentID, @userLevel =userLevel  , @IPaddressDB = isnull(IPaddress,''), @authID=authID
from  tbluserprofiles   with(nolock) where  UserID  = @Username and PasswordDEC = @EnCryptPass and status =1 


select  @transcriptOpt	= count(*) from  tblFacilityKeywords with(nolock) where  FacilityID = @FacilityID

IF @userLevel = 3 -- and  dbo.fn_comp_string ( @u, @userName)  =1  and dbo.fn_comp_string (  @p,  @password)  =1  
Begin
	Insert tblUserLogs(UserName,Password,IPAddess,loginTime) 	Values(@userName,@password,@IPaddress,getdate())
	SET @loginID = @@identity
	 
	select FacilityID,  Location ,  Address, City, State, Phone , logo, PINRequired, AgentID,  @loginID as LoginID , @userLevel as  userLevel , @transcriptOpt as  transcriptOpt   from tblFacility with(nolock)
	where FacilityID = @FacilityID

End
Else IF  @userLevel = 2 -- and  dbo.fn_comp_string ( @u, @userName)  =1  and dbo.fn_comp_string (  @p,  @password)  =1  
 Begin
	Insert tblUserLogs(UserName,Password,IPAddess,loginTime) 	Values(@userName,@password,@IPaddress,getdate())
	SET @loginID = @@identity 
	select 0 as FacilityID, Company as  Location ,  Address1, City, StateCode as State, Phone , ''  as Logo ,0  as PINRequired, AgentID,  @loginID as LoginID ,@userLevel as  userLevel ,@transcriptOpt as  transcriptOpt    from tblAgent with(nolock)
	where AgentID = @agentID
  End
Else IF   @userLevel = 1 -- and  dbo.fn_comp_string ( @u, @userName)  =1  and dbo.fn_comp_string (  @p,  @password)  =1  
 Begin
	Insert tblUserLogs(UserName,Password,IPAddess,loginTime) 	Values(@userName,@password,@IPaddress,getdate())
	SET @loginID = @@identity 
	select 0 as FacilityID,'Legacy' as  Location ,'Valley View'  Address1,'Cypress'  City, 'CA' as State,'714-826-0547' Phone , ''  as Logo ,0  as PINRequired, '0' as  AgentID,  @loginID as LoginID ,@userLevel as  userLevel  ,@transcriptOpt as  transcriptOpt 
  End
