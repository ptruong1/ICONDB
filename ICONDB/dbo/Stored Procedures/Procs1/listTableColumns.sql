
CREATE PROCEDURE [dbo].[listTableColumns]  
    @table SYSNAME  
AS  
BEGIN  
     
SET NOCOUNT ON  
 
DECLARE @tid INT,  
    @is VARCHAR(32),  
    @ii VARCHAR(32),  
    @ic VARCHAR(32)  
 
SELECT  
    @tid = OBJECT_ID(@table),  
    @is = CAST(IDENT_SEED(@table) AS VARCHAR(32)),  
    @ii = CAST(IDENT_INCR(@table) AS VARCHAR(32)),  
    @ic = CAST(IDENT_CURRENT(@table) AS VARCHAR(32))  
 
CREATE TABLE #pkeys  
(  
    t_q SYSNAME, t_o SYSNAME, t_n SYSNAME,  
    cn SYSNAME, ks INT, pn SYSNAME  
)  
 
INSERT #pkeys EXEC sp_pkeys @table  
 
CREATE TABLE #sc  
(  
    cn SYSNAME, formula NVARCHAR(2048)  
)  
 
INSERT #sc SELECT  
    cl.name, sc.text  
    FROM syscolumns cl  
    LEFT JOIN syscomments sc  
    ON cl.id = sc.id AND sc.number = cl.colid  
    WHERE cl.id = @tid  
 
SELECT  
 
[COLUMN NAME] = i_s.column_name,  
 
[DATA TYPE] = UPPER(DATA_TYPE)  
    + CASE WHEN DATA_TYPE IN ('NUMERIC', 'DECIMAL') THEN  
    '(' + CAST(NUMERIC_PRECISION AS VARCHAR)  
    + ', ' + CAST(NUMERIC_SCALE AS VARCHAR) + ')'  
    ELSE '' END  
    + CASE COLUMNPROPERTY(@tid, COLUMN_NAME, 'IsIdentity')  
    WHEN 1 THEN  
    ' IDENTITY (' + @is + ', ' + @ii + ')' ELSE '' END  
    + CASE RIGHT(DATA_TYPE, 4) WHEN 'CHAR' THEN  
    ' ('+CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR)+')' ELSE '' END  
    + CASE IS_NULLABLE WHEN 'No' THEN ' NOT ' ELSE ' ' END  
    + 'NULL' + COALESCE(' DEFAULT ' + SUBSTRING(COLUMN_DEFAULT,  
    2, LEN(COLUMN_DEFAULT)-2), ''),  
 /*
[CURRENT IDENTITY] = CASE COLUMNPROPERTY(@tid, COLUMN_NAME, 'IsIdentity')  
    WHEN 1 THEN @ic ELSE '' END,  
 
[FORMULA] = CASE COLUMNPROPERTY(@tid, COLUMN_NAME, 'IsComputed')  
    WHEN 1 THEN (SELECT SUBSTRING(formula, 2, len(formula)-2)  
    FROM #sc WHERE cn=i_s.column_name)  
    ELSE '' END,  
 */
[PRIMARY KEY?] = CASE WHEN pk.cn IS NOT NULL THEN 'Yes' ELSE '' END, 
 
[COLUMN DESCRIPTION] = COALESCE(s.value, '') 
 
FROM  
    INFORMATION_SCHEMA.COLUMNS i_s  
LEFT OUTER JOIN  
    #pkeys pk  
ON 
    pk.cn = i_s.column_name  
LEFT OUTER JOIN 
    sysproperties s 
ON 
    s.id = OBJECT_ID(i_s.TABLE_SCHEMA+'.'+i_s.TABLE_NAME)  
    AND s.smallid = i_s.ORDINAL_POSITION  
    AND s.name = 'MS_Description'  
WHERE  
    i_s.TABLE_NAME = @table 
ORDER BY 
    i_s.ORDINAL_POSITION 
 
DROP TABLE #pkeys  
DROP TABLE #sc  
 
END

