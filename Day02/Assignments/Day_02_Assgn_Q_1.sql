SELECT
    p.FullName,
    d.Name,
    COUNT(e.EncounterId) AS TotalEncounters,
    RANK() OVER (
        ORDER BY COUNT(e.EncounterId) DESC
    ) AS ProviderRank
FROM Provider p
INNER JOIN Department d
    ON p.DepartmentId = d.DepartmentId
INNER JOIN Encounter e
    ON p.ProviderId = e.ProviderId
GROUP BY
    p.FullName,
    d.Name
ORDER BY
    TotalEncounters DESC;