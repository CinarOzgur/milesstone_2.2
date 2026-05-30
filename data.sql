-- LEVEL 2'DEN GELEN PARAMETRELERİN SQL SORGUSUNA ETKİSİ
-- Sürücü Yaşı: '15-24', Hava Durumu: 'Raining', Işık: 'Dark' seçildiğinde:

WITH FilteredData AS (
    SELECT 
        lga_name,
        COUNT(incident_id) AS crash_count,
        MAX(infrastructure_defect_log) AS deficit_profile
    FROM vic_accident_master
    WHERE weather_condition = :input_weather        -- Level 2 Bağlantısı
      AND light_condition = :input_light            -- Level 2 Bağlantısı
      AND severity_level = :input_severity          -- Level 2 Bağlantısı
    GROUP BY lga_name
),
ComputedMetrics AS (
    SELECT 
        lga_name,
        crash_count,
        deficit_profile,
        -- Eşik Çizgisi Mantığı (Macro State Baseline: 2.0)
        CASE 
            WHEN crash_count > 2.0 THEN 1 
            ELSE 0 
        END AS is_anomaly,
        -- Statü Atamaları
        CASE 
            WHEN crash_count >= 4 THEN 'CRITICAL'
            WHEN crash_count >= 3 THEN 'WARNING'
            ELSE 'SAFE'
        END AS safety_status
    FROM FilteredData
)
SELECT 
    -- Sadece anomalilere dinamik sıra numarası (Rank) ver (Görseldeki #01, #02 yapısı)
    CASE 
        WHEN is_anomaly = 1 THEN ROW_NUMBER() OVER (PARTITION BY is_anomaly ORDER BY crash_count DESC) 
        ELSE NULL 
    END AS rank_id,
    lga_name,
    crash_count,
    deficit_profile,
    safety_status,
    is_anomaly
FROM ComputedMetrics
ORDER BY is_anomaly DESC, crash_count DESC;