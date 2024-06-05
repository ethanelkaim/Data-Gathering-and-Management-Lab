--3
CREATE VIEW CityMoreThan10Device
AS
SELECT City, C.CountDevice
FROM (  SELECT count(D.DeviceID) as CountDevice, D.City
        FROM Devices as D
        GROUP BY D.City) as C
WHERE C.CountDevice > 10


CREATE VIEW ImpsByCity
AS
SELECT ImpsByBids.BidFloor, ImpsByBids.ImpID, BidByCity.DeviceID, BidByCity.City
FROM (  SELECT I.*, B.DeviceID
        FROM Imps as I, Bids as B
        WHERE I.ImpID = B.ImpID) as ImpsByBids,
     (  SELECT B.*, D.City
        FROM  Bids as B, Devices as D
        WHERE B.DeviceID = D.DeviceID) as BidByCity
WHERE ImpsByBids.DeviceID = BidByCity.DeviceID AND ImpsByBids.ImpID = BidByCity.ImpID

CREATE VIEW AvgBidFloor
AS
SELECT AVG(IC.BidFloor) as BiDFLoorAVGByCity, IC.City
FROM ImpsByCity as IC
GROUP BY IC.City

CREATE VIEW LegitimeCity
AS
SELECT AvgBidFloor.City
FROM (  SELECT AVG(IC.BidFloor) as BiDFLoorAVGByCity, IC.City
        FROM ImpsByCity as IC
        GROUP BY IC.City) as AvgBidFloor,
     CityMoreThan10Device as CMT10D ,
     (  SELECT AVG(IP.BidFloor) AvgBid
        FROM Imps as IP) AS AvgAllBidFloor
WHERE AvgBidFloor.City = CMT10D.City AND AvgBidFloor.BiDFLoorAVGByCity > AvgAllBidFloor.AvgBid


CREATE VIEW CountLegitimCityByCountry
AS
SELECT count(LegitimeCityWithCountry.City) as count, LegitimeCityWithCountry.CountryCode
FROM (  SELECT L.*, C.CountryCode
        FROM Cities as C, LegitimeCity as L
        WHERE C.City = L.City) as LegitimeCityWithCountry
GROUP BY LegitimeCityWithCountry.CountryCode


CREATE VIEW MaxBidByCountry
AS
SELECT max(I.BidFloor) as MaxBidByCountry, C.CountryCode
FROM Imps as I, Bids as B, Cities as C, Devices as D
WHERE I.ImpID = B.ImpID AND B.DeviceID = D.DeviceID and D.City = C.City
GROUP BY C.CountryCode


SELECT CLCBC.CountryCode, MBBC.MaxBidByCountry
FROM CountLegitimCityByCountry AS CLCBC, MaxBidByCountry as MBBC
WHERE CLCBC.CountryCode = MBBC.CountryCode and CLCBC.count > 1
