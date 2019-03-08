-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_day_of_month]
@inputdate Date,
@whatday varchar(10)	OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @dayOfWeek tinyint, @dayOfMonth tinyint;
	Set @dayOfWeek  = datepart(dw,@inputDate);
	SET @dayOfMonth = datepart(day, @inputDate);
	SET  @whatday ='';
	if(@dayOfMonth <=7)
	 begin
		if(@dayOfWeek =1)
			set @whatday = '1Sun';
		else if(@dayOfWeek =7)
			set @whatday = '1Sat';
	 end
	else if (@dayOfMonth <=14)
	 begin
		if(@dayOfWeek =1)
			set @whatday = '2Sun';
		else if(@dayOfWeek =7)
			set @whatday = '2Sat';
	 end
	else if (@dayOfMonth <=21)
	 begin
		if(@dayOfWeek =1)
			set @whatday = '3Sun';
		else if(@dayOfWeek =7)
			set @whatday = '3Sat';
	 end
	else
	 begin
		if(@dayOfWeek =1)
			set @whatday = '4Sun';
		else if(@dayOfWeek =7)
			set @whatday = '4Sat';
	 end
			
    
END

