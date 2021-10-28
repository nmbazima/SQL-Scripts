SELECT PMP.*, MO.City 
FROM Sales.PrintMediaPlacement PMP
JOIN Sales.MediaOutlet MO ON PMP.MediaOutletID=MO.MediaOutletID
WHERE PublicationDate BETWEEN '2015-09-1' AND '2015-09-30'
AND PlacementCost BETWEEN 1 AND 2000
ORDER BY PlacementCost DESC;