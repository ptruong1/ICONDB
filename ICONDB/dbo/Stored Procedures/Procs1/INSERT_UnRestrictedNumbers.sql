
CREATE PROCEDURE [dbo].[INSERT_UnRestrictedNumbers]
(
	@PhoneNo char(10),
	@Description Varchar(50),
	@Billabe int
)
AS
	SET NOCOUNT OFF;

if (select count(AuthNo)  from tblOfficeAnI  with(nolock)  where  AuthNo = @PhoneNo)  > 0
 begin
	RETURN -1;

 end 
Else
	INSERT INTO [leg_Icon].[dbo].[tblOfficeANI]
           ([AuthNo]
           ,[Description]
           ,[Billabe])
     VALUES
           (@PhoneNo
           ,@Description
           ,@Billabe)

