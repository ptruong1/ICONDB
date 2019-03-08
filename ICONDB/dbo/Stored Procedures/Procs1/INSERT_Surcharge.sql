
CREATE PROCEDURE [dbo].[INSERT_Surcharge]
(
	@SurchargeID varchar(5),
	@Descript varchar(50)
		
)
AS
	SET NOCOUNT OFF;
if (select count(SurchargeID)  from tblSurcharge  with(nolock)  where  SurchargeID = @SurchargeID)  > 0
 begin
	RETURN -1;

 end 
 else
	INSERT INTO [tblSurcharge] ([SurchargeID], [Descript]) VALUES (@SurchargeID, @Descript);
	
	-- SELECT SurchargeID, Descript FROM tblSurcharge WHERE (SurchargeID = @SurchargeID)

