USE MarketDev;
GO

CREATE SPATIAL INDEX IX_ProspectLocation_Location
  ON Marketing.ProspectLocation (Location);
GO              
                                        
CREATE PROCEDURE Marketing.GetNearbyProspects
( @ProspectID int,
  @DistanceInKms int
)
AS BEGIN
  DECLARE @LocationToTest GEOGRAPHY;
  
  SET @LocationToTest = (SELECT pl.Location
                         FROM Marketing.ProspectLocation AS pl
                         WHERE pl.ProspectID = @ProspectID);
  
  SELECT pl.Location.STDistance(@LocationToTest) / 1000 AS Distance,
         p.ProspectID,
         p.LastName,
         p.FirstName,
         p.WorkPhoneNumber,
         p.CellPhoneNumber,
         pl.AddressLine1,
         pl.AddressLine2,
         pl.City,
         pl.Location.Long AS Longitude,
         pl.Location.Lat AS Latitude
  FROM Marketing.Prospect AS p
  INNER JOIN Marketing.ProspectLocation AS pl
  ON p.ProspectID = pl.ProspectID
  WHERE pl.Location.STDistance(@LocationToTest) < (@DistanceInKms * 1000)
  AND p.ProspectID <> @ProspectID 
  ORDER BY Distance;
END;
GO

EXEC Marketing.GetNearbyProspects 2,50;
GO