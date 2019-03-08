

CREATE PROCEDURE [dbo].[p_mobile_prepaid_login]
@EndUserUserName  varchar(25),
@EnduserPassword	varchar(25)

AS
SET NoCount ON;
declare  @PaymentOpt tinyint, @VideoMessageOpt tinyint, @EmailOpt tinyint, @TextOpt tinyint, @PictureOpt tinyint;
declare  @FirstName varchar(25), @Lastname varchar(25), @FacilityID int, @Status tinyint ,@Balance Numeric(6,2);
SET @FirstName = '';
SET @Lastname = '';
SET @FacilityID =0;
SET @Status =0;
SET @Balance =0;
SET @PaymentOpt =1;
SET @VideoMessageOpt =0; 
SET  @EmailOpt =0; 
SET @TextOpt =0;
SET @PictureOpt =0;


select @FacilityID = FacilityID , @firstName= FirstName , @LastName= LastName  ,  @balance = Balance ,@Status =  [status] from  
		 tblPrepaid with(nolock) ,   tblEndUsers  with(nolock)
		  where  tblPrepaid.EnduserID = tblEndUsers.EnduserID  and  
		  tblEndUsers.UserName =@EndUserUserName and  
		  tblEndUsers.password =@EnduserPassword and tblPrepaid.status = 1 ;
select  @VideoMessageOpt = isnull(VideoMessageOpt,0),  @EmailOpt = isnull(EmailOpt,0), @PictureOpt=isnull( PictureOpt,0) from tblFacilityOption with(nolock) where FacilityID = @FacilityID ;
Select @FacilityID as FacilityID, @firstName as FirstName, @LastName  LastName  ,  @balance as Balance ,@Status  as  Status, 
   @PaymentOpt as PaymentOpt, @VideoMessageOpt as VideoMessageOpt, @EmailOpt as EmailOpt, @TextOpt as TextOpt, @PictureOpt as PictureOpt;

return 0;
 
