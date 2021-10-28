USE MarketDev;
GO

ALTER TABLE Marketing.ProspectLocation
  ADD Location GEOGRAPHY NULL;
GO

UPDATE Marketing.ProspectLocation
  SET Location = GEOGRAPHY::STGeomFromText('POINT(' + CAST(Longitude AS varchar(20))
                                         + ' ' + CAST(Latitude AS varchar(20))
                                         + ')',4326);
GO

ALTER TABLE Marketing.ProspectLocation
  DROP COLUMN Latitude;
GO

ALTER TABLE Marketing.ProspectLocation
  DROP COLUMN Longitude;
GO