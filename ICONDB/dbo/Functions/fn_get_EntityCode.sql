
CREATE FUNCTION dbo.fn_get_EntityCode (@AgentID  varchar(7))  
RETURNS char(3) AS  
BEGIN 
	declare  @entityCode   char(3) , @a int
	SET @entityCode= '000'
	IF ( @AgentID = '' OR @AgentID IS NULL or  @AgentID = '9999'  or @agentId = '0')
		Return   @entityCode
	ELSE
	  BEGIN
		SET @AgentID = Isnull(@AgentID,'0')
		SET @a = cast(@AgentID as int)
		If(@a >0) 
			select @entityCode = entitycode from tblAgent where agentID = @a
		else
			SET @entityCode= '000'
	
	  end
	Return   @entityCode
END







