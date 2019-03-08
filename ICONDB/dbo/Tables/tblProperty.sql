﻿CREATE TABLE [dbo].[tblProperty] (
    [ContactID]         NVARCHAR (6)   NOT NULL,
    [AgentID]           VARCHAR (7)    NULL,
    [COMPANY]           NVARCHAR (30)  NULL,
    [ADDRESS1]          NVARCHAR (30)  NULL,
    [ADDRESS2]          NVARCHAR (30)  NULL,
    [CITY]              NVARCHAR (15)  NULL,
    [STATE]             NVARCHAR (2)   NULL,
    [ZIP]               NVARCHAR (9)   NULL,
    [AUTHCODE]          NVARCHAR (10)  NOT NULL,
    [CONTACTNAME]       NVARCHAR (20)  NULL,
    [ANIID]             NVARCHAR (10)  NULL,
    [NUMROOMS]          NVARCHAR (4)   NULL,
    [GREETING1]         NVARCHAR (40)  NULL,
    [GREETING2]         NVARCHAR (39)  NULL,
    [POLICE]            NVARCHAR (10)  NULL,
    [FIRE]              NVARCHAR (10)  NULL,
    [AMBULANCE]         NVARCHAR (10)  NULL,
    [POISONCONTROL]     NVARCHAR (10)  NULL,
    [CHARGETOROOM]      NVARCHAR (15)  NULL,
    [CREDITCARD]        NVARCHAR (15)  NULL,
    [800NUMBER]         NVARCHAR (15)  NULL,
    [INFORMATION]       NVARCHAR (15)  NULL,
    [HOTELDESK]         NVARCHAR (15)  NULL,
    [ROOMTOROOM]        NVARCHAR (15)  NULL,
    [PROPERTYTYPE]      NVARCHAR (1)   NULL,
    [VERT]              NVARCHAR (5)   NULL,
    [HORT]              NVARCHAR (5)   NULL,
    [LATA]              NVARCHAR (3)   NULL,
    [NPA]               NVARCHAR (3)   NULL,
    [RATEPLANID]        NVARCHAR (4)   NULL,
    [CARRIERID]         NVARCHAR (3)   NULL,
    [LibCode]           CHAR (2)       NULL,
    [CONFIGID]          VARCHAR (4)    NULL,
    [LASTUPDATE]        SMALLDATETIME  NULL,
    [Message]           NVARCHAR (100) NULL,
    [PromptLang]        INT            NULL,
    [RecordOpt]         CHAR (1)       NULL,
    [UserName]          VARCHAR (20)   NULL,
    [primaryLanguageOp] INT            NULL,
    [SubAgentID]        VARCHAR (5)    NULL,
    [PromptFileID]      INT            NULL
);
