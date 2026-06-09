CREATE VIEW vw_BillingClaims AS
SELECT
    ClaimId,
    Status,
    BilledAmount,
    ReimbursedAmt
FROM Claim;

CREATE PROCEDURE sp_RevenueLeakageReport
AS
BEGIN
    SELECT
        Status,
        COUNT(*) AS TotalClaims,
        SUM(BilledAmount) AS TotalBilledAmount,
        SUM(ReimbursedAmt) AS TotalReimbursedAmount,
        SUM(BilledAmount - ReimbursedAmt) AS OutstandingAmount,
        RANK() OVER (
            ORDER BY SUM(BilledAmount - ReimbursedAmt) DESC
        ) AS StatusRank
    FROM vw_BillingClaims
    GROUP BY Status
    ORDER BY OutstandingAmount DESC;
END;

EXEC sp_RevenueLeakageReport;