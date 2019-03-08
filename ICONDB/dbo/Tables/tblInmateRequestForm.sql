CREATE TABLE [dbo].[tblInmateRequestForm] (
    [FormID]         INT            NOT NULL,
    [FacilityID]     INT            NOT NULL,
    [InmateID]       VARCHAR (12)   NOT NULL,
    [BookingNo]      VARCHAR (12)   NOT NULL,
    [InmateLocation] VARCHAR (30)   NOT NULL,
    [RequestDate]    DATETIME       NOT NULL,
    [Request]        VARCHAR (2000) NULL,
    [Reply]          VARCHAR (2000) NULL,
    [ReplyName]      VARCHAR (50)   NULL,
    [ReplyDateTime]  DATETIME       NULL,
    [Status]         TINYINT        NULL,
    [FormType]       TINYINT        CONSTRAINT [DF_tblInmateRequestForm_FormType] DEFAULT ((0)) NULL,
    [DOB]            VARCHAR (10)   NULL,
    [DL]             VARCHAR (10)   NULL,
    [OfficerID]      TINYINT        DEFAULT ((0)) NULL,
    [ReferTo]        VARCHAR (200)  NULL,
    [DeviceName]     VARCHAR (20)   NULL,
    CONSTRAINT [PK_tblInmateRequestForm] PRIMARY KEY CLUSTERED ([FormID] ASC)
);

