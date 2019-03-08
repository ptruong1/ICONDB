CREATE ROLE [periscope]
    AUTHORIZATION [RepUser];


GO
EXECUTE sp_addrolemember @rolename = N'periscope', @membername = N'EdovoScope';

