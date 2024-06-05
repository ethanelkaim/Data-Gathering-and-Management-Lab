--1
SELECT CitiesPerCountry.CountryCode
FROM  (Select count(C.City) as count, C.CountryCode
FROM Cities as C
WHERE C.City > 'WOW'
GROUP BY C.CountryCode) as CitiesPerCountry
WHERE CitiesPerCountry.count > 3;

