
CREATE PROCEDURE [dbo].[p_get_ProboNo]
@facilityID	int,
@PhoneNo	char(10)  OUTPUT
 AS
SET NOCOUNT ON
SET   @PhoneNo =   '8772358297' 
Select   @PhoneNo =  phoneNo from tblProbono with(nolock)  where facilityID = @facilityID
