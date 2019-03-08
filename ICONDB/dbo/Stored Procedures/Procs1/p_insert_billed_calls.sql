
CREATE PROCEDURE [dbo].[p_insert_billed_calls]
@projectCode  char(6),
@calldate	char(6),
@billtype	char(2)
 AS
If(@billtype =  '06')
 Begin
	Insert tblcallsBilled(RecordID, Calldate, ConnectTime, FromNo,ToNo ,BillToNo , MethodOfRecord ,billType, CallType, FromState ,FromCity ,  ToState, ToCity,
		 CreditCardType, CreditCardNo ,CreditCardExp,CreditCardZip ,CreditCardCVV ,CallPeriod, LibraryCode ,Indicator19,SettlementCode ,ProjectCode,
	 	complete ,errorCode ,ratePlanID, firstMinute , nextMinute ,  connectFee ,  minDuration ,RateClass, userName ,RecordDate  ,Totalsurcharge,duration ,ConnectDate,
	 	Dberror, ResponseCode, AuthName ,ConfigID ,Pif ,   NSF ,PSC , NIF, BDf, RAF ,BSF ,OpSeqNo, AgentID, Fee2 ,  Fee3 , RecordFile,InRecordFile,
	  	MinIncrement, FolderDate, Channel, InmateID,CallRevenue,PIN, facilityID,BadDebtRate,CommRate) 
	select   A.RecordID, L.Calldate, L.ConnectTime, L.FromNo,L.ToNo ,L.BillToNo , L.MethodOfRecord ,L.billType, L.CallType, L.FromState ,L.FromCity ,  L.ToState, L.ToCity,
		 L.CreditCardType, L.CreditCardNo ,L.CreditCardExp,L.CreditCardZip ,L.CreditCardCVV ,L.CallPeriod, L.LibraryCode ,L.Indicator19,L.SettlementCode ,L.ProjectCode,
	 	L.complete ,L.errorCode ,L.ratePlanID, L.firstMinute , L.nextMinute ,  L.connectFee ,  L.minDuration ,L.RateClass, A.userName ,L.RecordDate  ,L.Totalsurcharge,A.duration ,A.ConnectDate,
		 L.Dberror, L.ResponseCode, L.AuthName ,L.ConfigID, L.Pif ,   L.NSF ,L.PSC , L.NIF, L.BDf, L.RAF ,L.BSF ,L.OpSeqNo, L.AgentID, L.Fee2 ,  L.Fee3 , A.RecordFile,  A.InRecordFile, 
	 	 L.MinIncrement, A.FolderDate, A.Channel, A.InmateID , dbo.fn_CalculateCallRevenue(L.firstMinute  , L.NextMinute ,L.connectFee ,A.duration ,L.callType  , L.totalSurcharge  ,L.minDuration ) ,A.PIN  , A.facilityID,
		 dbo.fn_getCurrentBadDebt( L.AgentID , L.FacilityID, L.BillType ,L.Calltype ) ,   dbo.fn_getCurrentCommRate( L.AgentID , L.FacilityID,L.BillType ,L.Calltype ) 
	from tblcalls  A with(nolock) ,   tblcallsLive  L with(nolock) 
	where  A.projectcode = L.ProjectCode and  A.calldate = L.Calldate and 
	 A.projectcode= @projectCode and    A.calldate= @calldate  and  L.errorCode ='0'  
 End

Else
	Insert tblcallsBilled(RecordID, Calldate, ConnectTime, FromNo,ToNo ,BillToNo , MethodOfRecord ,billType, CallType, FromState ,FromCity ,  ToState, ToCity,
		 CreditCardType, CreditCardNo ,CreditCardExp,CreditCardZip ,CreditCardCVV ,CallPeriod, LibraryCode ,Indicator19,SettlementCode ,ProjectCode,
	 	complete ,errorCode ,ratePlanID, firstMinute , nextMinute ,  connectFee ,  minDuration ,RateClass, userName ,RecordDate  ,Totalsurcharge,duration ,ConnectDate,
	 	Dberror, ResponseCode, AuthName ,ConfigID ,Pif ,   NSF ,PSC , NIF, BDf, RAF ,BSF ,OpSeqNo, AgentID, Fee2 ,  Fee3 , RecordFile, InRecordFile, 
	  	MinIncrement, FolderDate, Channel, InmateID,CallRevenue,PIN, facilityID )
	select RecordID, Calldate, ConnectTime, FromNo,ToNo ,BillToNo , MethodOfRecord ,billType, CallType, FromState ,FromCity ,  ToState, ToCity,
		 CreditCardType, CreditCardNo ,CreditCardExp,CreditCardZip ,CreditCardCVV ,CallPeriod, LibraryCode ,Indicator19,SettlementCode ,ProjectCode,
	 	complete ,errorCode ,ratePlanID, firstMinute , nextMinute ,  connectFee ,  minDuration ,RateClass, userName ,RecordDate  ,Totalsurcharge,duration ,ConnectDate,
		 Dberror, ResponseCode, AuthName ,ConfigID, Pif ,   NSF ,PSC , NIF, BDf, RAF ,BSF ,OpSeqNo, AgentID, Fee2 ,  Fee3 , RecordFile,InRecordFile,
	 	 MinIncrement, FolderDate, Channel, InmateID , dbo.fn_CalculateCallRevenue(firstMinute  , NextMinute ,connectFee ,duration ,callType  , totalSurcharge  ,minDuration ) ,PIN  , facilityID   
	from tblcalls with( nolock)   where projectcode= @projectCode and  calldate= @calldate


Return @@error

