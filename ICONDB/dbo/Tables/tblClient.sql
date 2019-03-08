CREATE TABLE [dbo].[tblClient] (
    [clientID]     VARCHAR (10)  NULL,
    [clientName]   VARCHAR (50)  NULL,
    [Address]      VARCHAR (100) NULL,
    [city]         VARCHAR (30)  NULL,
    [zipcode]      VARCHAR (9)   NULL,
    [state]        CHAR (2)      NULL,
    [officePhone]  CHAR (10)     NULL,
    [techPhone]    CHAR (10)     NULL,
    [cellPhone]    CHAR (10)     NULL,
    [email]        VARCHAR (50)  NULL,
    [fax]          CHAR (10)     NULL,
    [contractDate] DATETIME      NULL,
    [contractTerm] DATETIME      NULL,
    [inputDate]    DATETIME      NULL,
    [modifyDate]   DATETIME      NULL
);

