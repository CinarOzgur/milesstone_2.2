-- Kazalar Tablosu (Ana Tablo)
CREATE TABLE Crashes (
    id INT PRIMARY KEY,
    lga VARCHAR(100),            -- Local Government Area (Yarra Ranges, Geelong vb.)
    weather VARCHAR(50),          -- Raining, Clear vb.
    surface VARCHAR(50),          -- Wet, Dry vb.
    light VARCHAR(50),            -- Dark, Day vb.
    age_group VARCHAR(20),        -- 15-24, 25-39 vb.
    severity VARCHAR(50),         -- Severe/Fatal, Minor vb.
    smartphone_distraction INT,   -- 1 (Evet) veya 0 (Hayır)
    single_rule_violation INT,    -- 1 (Evet) veya 0 (Hayır)
    infrastructure_deficit VARCHAR(255)
);