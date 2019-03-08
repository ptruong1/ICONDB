

CREATE PROCEDURE  [dbo].[p_user_login4_test]
@userName  varchar(20),
@password	varchar(20),
@IPaddress	varchar(16)

AS
SET NOCOUNT ON;

Declare @loginID	bigint, @FacilityID int, @u varchar(20) , @p varchar(20), @agentID int , @userLevel   tinyint , @transcriptOpt	tinyint, @ActTime datetime,
	@IPaddressDB  varchar(16), @authID int, @visitOpt tinyint,@EnCryptUser varbinary(200),@EnCryptPass varbinary(200), @UserAction varchar(100);
SET @FacilityID = 0;
SET @agentID =0 ;
SET @userLevel  =0;
SET @transcriptOpt	= 0;
SET @visitOpt=3;
SET  @authID=0;



EXEC [dbo].[LegEncrypt] @password,	@EnCryptPass  OUTPUT;
exec [dbo].[LegEncrypt] @Username,	@EnCryptUser  OUTPUT;

select @u = userID , @p = password , @FacilityID = FacilityID , @agentID= AgentID, @userLevel =userLevel  , @IPaddressDB = isnull(IPaddress,''), @authID=authID
	  from  tbluserprofiles   with(nolock) where  UserID = @userName and PasswordDEC = @EnCryptPass and status =1 and (IPaddress is null or  IPaddress =''  OR  IPaddress ='NA'   or  IPaddress =@IPaddress);

select  @transcriptOpt	= count(*) from  tblFacilityKeywords with(nolock) where  FacilityID = @FacilityID;

EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;



IF (@userLevel = 3 )
Begin
	Insert tblUserLogs(UserName,Password,IPAddess,loginTime) 	Values(@userName,@password,@IPaddress,getdate());
	SET @loginID = @@identity;
	 --If( @IPaddressDB = ''  AND @FacilityID = 352)
	 -- Begin
		--Update  tbluserprofiles  SET   IPaddress =  @IPaddress  where  userID = @userName and password = @password ;
	 -- End
	select F.FacilityID,  F.Location ,  F.Address, F.City, F.State, F.Phone , F.logo, F.PINRequired, F.AgentID,  
		@loginID as LoginID , @userLevel as  userLevel , @transcriptOpt as  transcriptOpt, @authID as authID  , isnull( o.VisitOpt,0)  VisitOpt
	from tblFacility F with(nolock) left outer join leg_Icon.dbo.tblvisitFacilityConfig O with(nolock)
	On 
	F.FacilityID = o.FacilityID 
	where 
		F.FacilityID = @FacilityID ;

End
Else IF   @userLevel = 2  
 Begin
    
	Insert tblUserLogs(UserName,Password,IPAddess,loginTime) 	Values(@userName,@password,@IPaddress,getdate());
	SET @loginID = @@identity ;
	select 0 as FacilityID, Company as  Location ,  Address1, City, StateCode as State, Phone , ''  as Logo ,0  as PINRequired, AgentID,  @loginID as LoginID ,@userLevel as  userLevel ,@transcriptOpt as  transcriptOpt,  @authID as authID ,@visitOpt as VisitOpt    from tblAgent with(nolock)
	where AgentID = @agentID;
  End
Else 
 Begin
	Insert tblUserLogs(UserName,Password,IPAddess,loginTime) 	Values(@userName,@password,@IPaddress,@ActTime);
	SET @loginID = @@identity ;
	select 0 as FacilityID,'Legacy' as  Location ,'Valley View'  Address1,'Cypress'  City, 'CA' as State,'714-826-0547' Phone , ''  as Logo ,0  as PINRequired, '0' as  AgentID,  @loginID as LoginID ,@userLevel as  userLevel  ,@transcriptOpt as  transcriptOpt,  @authID as authID ,@visitOpt as VisitOpt ;
  End

SET  @UserAction =  'Login from IP Address:' +  @IPaddress ;
EXEC  INSERT_ActivityLogs3	@FacilityID ,0,@ActTime ,0,@UserName ,@IPaddress, @loginID,@UserAction ;  
--Insert tblActivityLog (ActivityID ,ActTime ,RecordID , FacilityID , UserName,UserIP,Reference)
--values (0,GETDATE(),0,@FacilityID ,@userName,@IPaddress,@loginID )  ;


