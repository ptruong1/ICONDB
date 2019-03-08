CREATE PROCEDURE [dbo].[p_Report_High_volume_calls_by_User]
@FacilityID	int,
@threshold	int, 
@fromDate	smalldatetime,
@toDate	smalldatetime,
@complete	bit,
@uncomplete	bit
 AS

 If(@complete=1 and  @uncomplete =1 )
 Begin
	Select   (LastName  + ',  ' +   FirstName ) as InmateName ,  tblcallsBilled.PIN,  Count( tblcallsBilled.PIN )   as [Total  Calls] , sum(CEILING( Duration/60.00)) as [Total Minutes]  from tblcallsBilled with(nolock) , tblInmate  with(nolock)  
		WHERE   tblcallsBilled.FacilityID = @FacilityID and  tblcallsBilled.Pin  = tblInmate.PIN  and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate  And  tblInmate.PIN <>'0'
			group by   tblcallsBilled.PIN, LastName, FirstName
			 having Count( tblcallsBilled.Pin)  >= @threshold
			--Order by   [Total  Calls]  Desc
	UNION
	Select   (LastName  + ',  ' +   FirstName ) as InmateName ,  tblcallsUnBilled.PIN,  Count( tblcallsUnBilled.PIN )   as [Total  Calls] , 0 as [Total Minutes]  from tblcallsUnBilled with(nolock) , tblInmate  with(nolock)  
		WHERE   tblcallsUnBilled.FacilityID = @FacilityID and  tblcallsUnBilled.Pin  = tblInmate.PIN  and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate  And  tblInmate.PIN <>'0'
			group by   tblcallsUnBilled.PIN, LastName, FirstName
			 having Count( tblcallsUnBilled.Pin)  >= @threshold
		Order by   [Total  Calls]  Desc
 End
Else If(@complete=1 )
 Begin
	Select   (LastName  + ',  ' +   FirstName ) as InmateName ,  tblcallsBilled.PIN,  Count( tblcallsBilled.PIN )   as [Total  Calls] , sum(CEILING( Duration/60.00)) as [Total Minutes]  from tblcallsBilled with(nolock) , tblInmate  with(nolock)  
		WHERE   tblcallsBilled.FacilityID = @FacilityID and  tblcallsBilled.Pin  = tblInmate.PIN  and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate  And  tblInmate.PIN <>'0'
			group by   tblcallsBilled.PIN, LastName, FirstName
			 having Count( tblcallsBilled.Pin)  >= @threshold
			Order by   [Total  Calls]  Desc  
 End

Else 
	Select   (LastName  + ',  ' +   FirstName ) as InmateName ,  tblcallsUnBilled.PIN,  Count( tblcallsUnBilled.PIN )   as [Total  Calls] , 0 as [Total Minutes]  from tblcallsUnBilled with(nolock) , tblInmate  with(nolock)  
		WHERE   tblcallsUnBilled.FacilityID = @FacilityID and  tblcallsUnBilled.Pin  = tblInmate.PIN  and RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate  And  tblInmate.PIN <>'0'
			group by   tblcallsUnBilled.PIN, LastName, FirstName
			 having Count( tblcallsUnBilled.Pin)  >= @threshold
		Order by   [Total  Calls]  Desc
