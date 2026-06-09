SELECT
    InsuranceId,
    Payer,
    PolicyNumber,
    EffectiveDate AS ValidFrom,
    ExpiryDate AS ValidTo
FROM Insurance
WHERE PatientId = 3
AND EffectiveDate <= DATEADD(MONTH, -6, GETDATE())
ORDER BY EffectiveDate DESC;