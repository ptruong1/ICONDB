

CREATE FUNCTION dbo.fn_CalculateMileage (@ANI_NPANXX char(6), @DNI_NPANXX char(6))
RETURNS   int 
AS  
BEGIN 
	declare @Mileage int,  @ANI_Horizontal int,  @DNI_Horizontal int, @ANI_vertical  int, @DNI_vertical  int
	SET  @Mileage =0
	SET @ANI_Horizontal =0
	SET  @DNI_Horizontal =0
	SET  @DNI_vertical =0
	If( @ANI_NPANXX  = @DNI_NPANXX) return 0
	Select top 1 @ANI_Horizontal =CAST ([Major H] as int) , @ANI_vertical = cast ([Major V] as int)  From tblTPM with(nolock) where  NPA = Left(@ANI_NPANXX,3) and NXX=right(@ANI_NPANXX,3)
	Select top 1 @DNI_Horizontal =CAST ([Major H] as int) , @DNI_vertical = cast ([Major V] as int)  From tblTPM with(nolock) where  NPA = Left(@DNI_NPANXX,3) and NXX=right(@DNI_NPANXX,3)

	SET  @Mileage = SQRT( (SQUARE (@ANI_Horizontal -   @DNI_Horizontal )  + SQUARE  (@ANI_vertical - @DNI_vertical )) / 10)
	return @Mileage
END










