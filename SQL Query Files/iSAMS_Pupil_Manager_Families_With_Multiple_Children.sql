WITH cteFamiliesWithMultipleChildren AS
(
	SELECT
		p.intFamily, COUNT(*) as numPupilsInFamily
	FROM
		TblPupilManagementFamily f
	JOIN
		TblPupilManagementPupils p ON p.intFamily = f.TblPupilManagementFamilyID
	GROUP BY
		p.intFamily
	HAVING
		COUNT (*) > 1
)
SELECT 
	f.intFamily as familyID, 
	contact.TblPupilManagementAddressesID as contactID,
	f.numPupilsInFamily
FROM
	cteFamiliesWithMultipleChildren f
JOIN
	TblPupilManagementPupils p ON p.intFamily = f.intFamily
JOIN
	TblPupilManagementAddressLink link ON link.txtSchoolID = p.txtSchoolID
JOIN
	TblPupilManagementAddresses contact ON contact.TblPupilManagementAddressesID = link.intAddressID
WHERE
	contact.intPrivate = 1
GROUP BY 
	f.intFamily, 
	contact.TblPupilManagementAddressesID, 
	f.numPupilsInFamily
HAVING 
	COUNT(*) = f.numPupilsInFamily;

