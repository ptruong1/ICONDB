CREATE ROLE [db_execute]
    AUTHORIZATION [dbo];


GO
EXECUTE sp_addrolemember @rolename = N'db_execute', @membername = N'CypressDBAccess';


GO
EXECUTE sp_addrolemember @rolename = N'db_execute', @membername = N'ACPDBAccess';

