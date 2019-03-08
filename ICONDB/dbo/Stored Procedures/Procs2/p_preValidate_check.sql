
CREATE PROCEDURE [dbo].[p_preValidate_check]
@ToNo  varchar(10)
 AS


If ( SELECT count (*) from tblOfficeANI  with(nolock)  WHERE  AuthNo  = @tono ) > 0
	Return  1

If (SELECT count (*) from  tblcallsbilled with(nolock) WHERE  tono = @tono and billtype ='01' and  ResponseCode = '061' and   datediff(d,RecordDate,getdate()) < 14 ) > 0 
	Return 1

