-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_search_inmate_activity_Special_WithFilter]
@TempUserTable varchar(30),
@StrFilter nvarchar(200),
@startRowIndex int,
@maximumRows int,
@Count bigint,
@RecCount int output

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @sql nvarchar(max), @table varchar(30)
	Set @table = @TempUserTable
	
Begin
Declare @StartRow int, @MaxRow int,  @Filter nvarchar(200) set @Filter = @StrFilter
set @StartRow = @startRowIndex set @MaxRow = @startRowIndex + @maximumRows


	if @StrFilter = '' and @count = 1
		begin
		Create table  #Temp5 (RecordID varchar(34), InmateID varchar(12),InmateName varchar(50),  ActivityDate datetime, 
		ActivityType varchar(25), StationID varchar(25), ContactPhone varchar(18),PhoneType varchar(30), ContactName  varchar(50), 
		Duration varchar(20), ActivityStatus varchar(30), RecordOpt varchar(1) Default 'Y', rowNum int) ;
		set @sql = 'insert  #Temp5  (RecordID , InmateID ,InmateName, ActivityDate, ActivityType, StationID , ContactPhone , Phonetype, 
		ContactName, Duration, ActivityStatus ,	RecordOpt, rowNum ) 
			Select RecordID , InmateID ,InmateName, ActivityDate, ActivityType, StationID, ContactPhone , PhoneType,
		   ContactName , Duration, 	ActivityStatus, RecordOpt, Row_Number() Over(Order By [ActivityDate],[InmateID] Desc) As RowNum
			 from ' +  @table 
		  
		exec sp_executesql @sql	 
		set @RecCount = (select Count(RecordID) from #Temp5)
		drop table #Temp5	
		end
	else if @StrFilter = '' and @Count = 0
		Begin
		Create table  #Temp2 (RecordID varchar(34), InmateID varchar(12),InmateName varchar(50),  ActivityDate datetime, 
		ActivityType varchar(25), StationID varchar(25), ContactPhone varchar(18),PhoneType varchar(30), ContactName  varchar(50), 
		Duration varchar(20), ActivityStatus varchar(30), RecordOpt varchar(1) Default 'Y', rowNum int) ;


	set @sql = 'insert  #Temp2  (RecordID , InmateID ,InmateName, ActivityDate, ActivityType, StationID , ContactPhone , Phonetype, ContactName, Duration, ActivityStatus ,
			RecordOpt, rowNum ) 
			Select RecordID , InmateID ,InmateName, ActivityDate, ActivityType, StationID, ContactPhone , PhoneType,
		   ContactName , Duration, 	ActivityStatus, RecordOpt, Row_Number() Over(Order By [ActivityDate],[InmateID] Desc) As RowNum
			 from ' +  @table 
		  
		exec sp_executesql @sql	 

		Select RecordID , InmateID ,InmateName, ActivityDate, ActivityType, StationID, ContactPhone , Phonetype,
		   ContactName , Duration, 	ActivityStatus, RecordOpt,  RowNum
			 from #Temp2 where (rowNum  >=  @startRow and rowNum <  @MaxRow )
			 order by rowNum

			print @Sql
			--exec sp_executesql @sql, N'@startRow int, @MaxRow int',  @startRow =  @startRow,  @MaxRow =  @MaxRow
			set @RecCount = (select Count(RecordID) from #Temp2)
			drop table #Temp2
		end

	else if @StrFilter <> '' and @Count = 1
		begin
		Create table  #Temp3 (RecordID varchar(34), InmateID varchar(12),InmateName varchar(50),  ActivityDate datetime, 
		ActivityType varchar(25), StationID varchar(25), ContactPhone varchar(18),PhoneType varchar(30), ContactName  varchar(50), 
		Duration varchar(20), ActivityStatus varchar(30), RecordOpt varchar(1) Default 'Y', rowNum int) ;

		select @filter =@StrFilter
		set @sql = 'insert  #Temp3  (RecordID , InmateID ,InmateName, ActivityDate, ActivityType, StationID , ContactPhone , Phonetype, ContactName, Duration, ActivityStatus ,
			RecordOpt, rowNum ) 
			Select RecordID , InmateID ,InmateName, ActivityDate,ActivityType, StationID, ContactPhone , Phonetype,
		   ContactName , Duration, 	ActivityStatus, RecordOpt, Row_Number() Over(Order By [ActivityDate],[InmateID] Desc) As RowNum
			 from ' +  @table + ' where ' + @Filter

		exec sp_executesql @sql,N'@Filter nvarchar(200)', @Filter=@StrFilter
		set  @RecCount = (select count(*) from #Temp3)
		drop table #Temp3
		end
	else if @StrFilter <> '' and @Count = 0
		Begin
		Create table  #Temp4 (RecordID varchar(34), InmateID varchar(12),InmateName varchar(50),  ActivityDate datetime, 
		ActivityType varchar(25), StationID varchar(25), ContactPhone varchar(18),PhoneType varchar(30), ContactName  varchar(50), 
		Duration varchar(20), ActivityStatus varchar(30), RecordOpt varchar(1) Default 'Y', rowNum int);

		select @filter =@StrFilter
		set @sql = 'insert  #Temp4  (RecordID , InmateID ,InmateName, ActivityDate, ActivityType, StationID , ContactPhone , Phonetype, ContactName, Duration, ActivityStatus ,
			RecordOpt, rowNum ) 
			Select RecordID , InmateID ,InmateName, ActivityDate,ActivityType, StationID, ContactPhone , Phonetype,
		   ContactName , Duration, 	ActivityStatus, RecordOpt, Row_Number() Over(Order By [ActivityDate],[InmateID] Desc) As RowNum
			 from ' +  @table + ' where ' + @Filter
		 
		print @sql
		exec sp_executesql @sql,N'@Filter nvarchar(200)', @Filter=@StrFilter
		set  @RecCount = (select count(*) from #Temp4)
			
		--set @sql = 'Select RecordID , InmateID ,InmateName, ActivityDate, ActivityType, StationID, ContactPhone , Phonetype,
		--   ContactName , Duration, 	ActivityStatus, RecordOpt,  RowNum
		--	 from #Temp4 where (rowNum  >=  @startRow and rowNum <  @MaxRow)  order by rowNum'

		--	print @Sql
		--	exec sp_executesql @sql, N'@startRow int, @MaxRow int',  @startRow =  @startRow,  @MaxRow =  @MaxRow
		Select RecordID , InmateID ,InmateName, ActivityDate, ActivityType, StationID, ContactPhone , Phonetype,
		   ContactName , Duration, 	ActivityStatus, RecordOpt,  RowNum
			 from #Temp4 where (rowNum  >=  @startRow and rowNum <  @MaxRow)  order by rowNum
			drop table #Temp4

		end
	End
END	
    

