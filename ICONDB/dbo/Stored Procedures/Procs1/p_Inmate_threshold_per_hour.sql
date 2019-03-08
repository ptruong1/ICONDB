
CREATE PROCEDURE [dbo].[p_Inmate_threshold_per_hour] 
@PIN	varchar(12),
@FacilityID	int
AS


Declare  @i int , @DateTimeRestrict  bit,    @localtime  smalldatetime,   @day int,   @h  int
Set  @localtime = getdate()
SET @day = datepart(dw, @localtime)
SET @h = datepart(hh, @localtime)

