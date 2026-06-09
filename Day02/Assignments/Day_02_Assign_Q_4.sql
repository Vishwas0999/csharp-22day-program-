CREATE PROCEDURE sp_ExecutiveDashboard
AS
BEGIN

    SELECT 
        'Total Active Patients' AS Metric,
        COUNT(*) AS Value
    FROM Patient
    WHERE IsActive = 1;

    SELECT TOP 5
        d.Name,
        COUNT(e.EncounterId) AS TotalEncounters
    FROM Department d
    INNER JOIN Provider p ON p.DepartmentId = d.DepartmentId
    INNER JOIN Encounter e ON e.ProviderId = p.ProviderId
    GROUP BY d.Name
    ORDER BY TotalEncounters DESC;

    SELECT TOP 5
        p.FullName,
        d.Name,
        COUNT(e.EncounterId) AS TotalEncounters,
        RANK() OVER (
            ORDER BY COUNT(e.EncounterId) DESC
        ) AS ProviderRank
    FROM Provider p
    INNER JOIN Department d ON d.DepartmentId = p.DepartmentId
    INNER JOIN Encounter e ON e.ProviderId = p.ProviderId
    GROUP BY 
        p.FullName,
        d.Name
    ORDER BY TotalEncounters DESC;

END;

exec sp_ExecutiveDashboard;