

CREATE PROCEDURE [dbo].[p_create_projectCode]
@currentDate  char(6)  ,
@projectCode  char(6)  output

 AS
Declare @currentProjectCode  int
SET  @currentProjectCode = 0
Begin tran
	Select  @currentProjectCode = projectCode From defaultProjectCode  where currentDate = @currentDate
	SET  @currentProjectCode =  @currentProjectCode + 1
	Update defaultProjectCode   SET  projectCode = @currentProjectCode , currentDate = @currentDate
Commit tran
if(  @currentProjectCode < 10 )
	SET  @projectCode  = '50000'  + cast(  @currentProjectCode as varchar(6))
else if(  @currentProjectCode < 100 )
	SET  @projectCode  = '5000'  + cast(  @currentProjectCode as varchar(6))
else if(  @currentProjectCode < 1000 )
	SET  @projectCode  = '500'  + cast(  @currentProjectCode as varchar(6))
else if(  @currentProjectCode < 10000 )
	SET  @projectCode  = '50'  + cast(  @currentProjectCode as varchar(6))
else if(  @currentProjectCode < 100000 )
	SET  @projectCode  = '5'  + cast(  @currentProjectCode as varchar(6))

