

CREATE PROCEDURE [dbo].[p_determine_setlementCode]
@fromState	char(2),
@toState	char(2),
@fromLata	varchar(3),
@tolata		varchar(3),
@setlementCode	char  Output
 AS
Declare  @country  char(3)
SET @country = ''
If (Select  count(*) from   tblstates with(nolock) where  statecode = @fromState  and international = 'Y'   ) > 0  
	Or  (Select  count(*) from   tblstates with(nolock) where  statecode = @tostate  and international = 'Y'  ) > 0
  Begin 
	IF (select count(*)  From   tblstates with(nolock)  where  ( statecode =   @fromState  Or  statecode = @toState ) and country='CAN') > 0
	
		SET  @setlementCode  = 'K'
	Else
		SET  @setlementCode  = 'N'
	Return 0
  End

If ( @fromState	 =   @toState ) 
  Begin
	
	SET  @setlementCode  = '8'
  End
Else
	SET  @setlementCode  = 'J'

