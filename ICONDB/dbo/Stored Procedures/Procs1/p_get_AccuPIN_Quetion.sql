
CREATE PROCEDURE [dbo].[p_get_AccuPIN_Quetion]
@facilityID	int,
@QsID		smallint  OUTPUT
AS
SET nocount on
Declare  @i smallint , @num varchar(20), @nextQsID int
select   @i = count(*) from tblAccuPIN with(nolock)  where facilityID = @facilityID
SET  @num = cast( rand() as varchar(20))
SET @QsID =  right( @num,4) %   (@i +1) 
if(@QsID =0)  set @QsID =1
SET  @num = cast( rand() as varchar(20))
SET @nextQsID  =  right( @num,4) %   (@i +1) 
if(@nextQsID =0)  set @nextQsID =3
If (@nextQsID=@QsID)	SET  @nextQsID =  @QsID + 1
If (@nextQsID > @i )  SET @nextQsID = 1

Return @nextQsID
