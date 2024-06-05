--2
SELECT CountDeviceAndModel.Make, CountDeviceAndModel.countDeviceByMaker
FROM    (SELECT count(D.DeviceID) as countDeviceByMaker, Count(DISTINCT D.Model) as countModel, D.Make, USACities.CountryCode
        FROM Devices as D, (SELECT C.City, C.CountryCode
                    FROM Cities as C
                    WHERE C.CountryCode = 'USA') AS USACities
        WHERE D.City = USACities.City
        GROUP BY D.Make, CountryCode) as CountDeviceAndModel
WHERE CountDeviceAndModel.countDeviceByMaker > 100 AND CountDeviceAndModel.countModel > 20 AND CountDeviceAndModel.Make IS NOT NULL
ORDER BY CountDeviceAndModel.countDeviceByMaker DESC;
