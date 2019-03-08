EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'ICONAccess';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'RepUser';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'ChicagoDev';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'CypressDev';


GO
EXECUTE sp_addrolemember @rolename = N'db_backupoperator', @membername = N'RepUser';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'CypressDBAccess';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'ProductDBAccess';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'CypressDBAccess';

