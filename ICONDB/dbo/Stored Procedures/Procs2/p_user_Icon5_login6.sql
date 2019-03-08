

CREATE PROCEDURE  [dbo].[p_user_Icon5_login6]
@userName  varchar(20),
@password	varchar(20),
@IPaddress	varchar(16)

AS
SET NOCOUNT ON;

Declare @loginID	bigint, @FacilityID int, @u varchar(20) , @p varchar(20), @agentID int , @userLevel   tinyint , @transcriptOpt	tinyint, @ActTime datetime, @FormsOpt tinyint,
	@IPaddressDB  varchar(16), @authID int, @visitOpt tinyint,@EnCryptUser varbinary(200),@EnCryptPass varbinary(200), @UserAction varchar(100), @FirstName varchar(25), @LastName varchar(25);
	Declare @return_value int, @nextID int, @ID int, @tblUserLogs nvarchar(32), @UserPhone varchar(10), @Email nvarchar(50), @SecondFactor bit, @userGroupID int, @MasterUserGroupID int  ;
SET @FacilityID = 0;
SET @agentID =0 ;
SET @userLevel  =0;
SET @transcriptOpt	= 0;
SET @visitOpt=3;
SET  @authID=0;
set @FormsOpt =0;
set @UserPhone = '';
set @Email ='';
set @SecondFactor = 0;

select @u = userID , @p = password , @FacilityID = FacilityID , @agentID= AgentID, @userLevel =userLevel  , @IPaddressDB = isnull(IPaddress,''), 
@authID=authID, @FirstName=FirstName, @LastName=LastName, @UserPhone=Phone, @Email=Email, @SecondFactor= isnull(SecondFactor, 0), @userGroupID= ISNULL(UserGroupID,0), @MasterUserGroupID = ISNULL(MasterUserGroupID, 0) 
	  from  tbluserprofiles   with(nolock) where  UserID = @userName and Password = @password and status =1 and (IPaddress is null or  IPaddress =''  OR  IPaddress ='NA'   or  IPaddress =@IPaddress);
select  @transcriptOpt = isnull(AudioMining,0), @FormsOpt = ISNULL (FormsOpt,0) from tblFacilityOption with(nolock) where FacilityID = @FacilityID;

IF (@userLevel = 3 )
Begin
	
       EXEC   @return_value = p_create_nextID 'tblUserLogs', @nextID   OUTPUT
       set           @ID = @nextID ;
	Insert tblUserLogs(LoginID, UserName,Password,IPAddess,loginTime) 	Values(@ID,@userName,@password,@IPaddress,getdate());

	SET @loginID = @@identity;
	
	select F.FacilityID,  F.Location ,  F.Address, F.City, F.State, F.Phone , F.logo, F.PINRequired, F.AgentID, isnull( F.groupID,0)  GroupID,
			@loginID as LoginID , @userLevel as  userLevel , @transcriptOpt as  transcriptOpt, @authID as authID  ,
			 isnull( o.VisitOpt,0)  VisitOpt, @FirstName as FirstName, @LastName as LastName, @FormsOpt as FormsOpt, @UserPhone as UserPhone, @Email as Email,
			 @SecondFactor as SecondFactor, @userGroupID as UserGroupID, @MasterUserGroupID as MasterUserGroupID
	   from tblFacility F with(nolock) left outer join tblvisitFacilityConfig O with(nolock)
		On 
		F.FacilityID = o.FacilityID 
		where 
			F.FacilityID = @FacilityID ;

End
Else IF   (@userLevel = 2  )
 Begin
 
       EXEC   @return_value = p_create_nextID 'tblUserLogs', @nextID   OUTPUT
       set           @ID = @nextID ;
	Insert tblUserLogs(LoginID, UserName,Password,IPAddess,loginTime) 	Values(@ID,@userName,@password,@IPaddress,getdate());
	SET @loginID = @@identity ;
	if (@agentID =1) 
		begin
		select 1 as FacilityID, Company as  Location ,  Address1, City, StateCode as State, 
				Phone , ''  as Logo ,0  as PINRequired, AgentID, 0 as GroupID,  @loginID as LoginID ,@userLevel as  userLevel ,
				@transcriptOpt as  transcriptOpt,  @authID as authID ,@visitOpt as VisitOpt, @FirstName as FirstName, 
				@LastName as LastName,@FormsOpt as FormsOpt, @UserPhone as UserPhone, @Email as Email, @SecondFactor as SecondFactor, @userGroupID as UserGroupID, @MasterUserGroupID as MasterUserGroupID
		from tblAgent with(nolock)
		where AgentID = @agentID;
		end
	else
		begin
		select 0 as FacilityID, Company as  Location ,  Address1, City, StateCode as State, 
				Phone , ''  as Logo ,0  as PINRequired, AgentID, 0 as GroupID,  @loginID as LoginID ,@userLevel as  userLevel ,
				@transcriptOpt as  transcriptOpt,  @authID as authID ,@visitOpt as VisitOpt, @FirstName as FirstName, 
				@LastName as LastName,@FormsOpt as FormsOpt, @UserPhone as UserPhone, @Email as Email, @SecondFactor as SecondFactor, @userGroupID as UserGroupID, @MasterUserGroupID as MasterUserGroupID
		from tblAgent with(nolock)
		where AgentID = @agentID;
		end
	
  End
Else 
 Begin
 
       EXEC   @return_value = p_create_nextID 'tblUserLogs', @nextID   OUTPUT
       set           @ID = @nextID ;
	Insert tblUserLogs(LoginID, UserName,Password,IPAddess,loginTime) 	Values(@ID,@userName,@password,@IPaddress,getdate());
	--Insert tblUserLogs(UserName,Password,IPAddess,loginTime) 	Values(@userName,@password,@IPaddress,@ActTime);
	SET @loginID = @@identity ;
	select 0 as FacilityID,'Legacy' as  Location ,'Valley View'  Address1,'Cypress'  City, 'CA' as State, '5624911991' as Phone , ''  as Logo ,0  as PINRequired, 0 as  AgentID,0 as GroupID,  @loginID as LoginID ,@userLevel as  userLevel  ,
	@transcriptOpt as  transcriptOpt,  @authID as authID ,@visitOpt as VisitOpt, @FirstName as FirstName, @LastName as LastName,@FormsOpt as FormsOpt, @UserPhone as UserPhone, @Email as Email, @SecondFactor as SecondFactor, @userGroupID as UserGroupID, @MasterUserGroupID as MasterUserGroupID ;
  End
 EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
SET  @UserAction =  'Login from IP Address:' +  @IPaddress ;
EXEC  INSERT_ActivityLogs3	@FacilityID ,0,@ActTime ,0,@UserName ,@IPaddress, @loginID,@UserAction ;  
--- live updat user activity
EXEC [172.77.10.22\bigdaddyicon].Leg_LiveCast.dbo.p_update_user_activity @UserName, @FacilityID, 0, @UserAction,@ActTime;




