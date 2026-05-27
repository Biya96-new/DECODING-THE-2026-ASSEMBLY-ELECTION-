create schema tamilnadu_election_2026;
use tamilnadu_election_2026;


-- Q1 Did voter participation increase between 2021 and 2026, and how did engagement vary across regions?​
SELECT 
    CONCAT(ROUND(AVG(t21.poll_pct), 2), '%') AS turnout_2021,
    CONCAT(ROUND(AVG(t26.poll_pct), 2), '%') AS turnout_2026,
    CONCAT(
        ROUND(AVG(t26.poll_pct) - AVG(t21.poll_pct), 2),
        '%'
    ) AS turnout_change
FROM tamilnadu_2026 t26
LEFT JOIN tamilnadu_2021 t21
ON t26.`ac_no.` = t21.`ac_no.`;

-- Q2 — How did regional political dominance change between 2021 and 2026?​
SELECT 
    cm.region,
    t26.party,
    COUNT(*) AS seats_won
FROM tamilnadu_2026 t26
LEFT JOIN constituency_master cm
ON t26.`ac_no.` = cm.ac_number
GROUP BY cm.region, t26.party
ORDER BY cm.region, seats_won DESC;

-- Q3 — Alliance Ecosystem
-- “Which alliances performed best?”
SELECT
    pa.alliance,
    COUNT(*) AS seats_won
FROM tamilnadu_2026 t26
LEFT JOIN partyalliances_2026 pa
ON t26.party = pa.party
GROUP BY pa.alliance
ORDER BY seats_won DESC;

-- Q4 — Where did constituencies swing the most between elections?
SELECT
    t26.ac_name AS constituency,
    t21.party AS party_2021,
    t26.party AS party_2026,
    ROUND(
        t26.margin_pct - t21.margin_pct,
        2
    ) AS margin_change
FROM tamilnadu_2026 t26
LEFT JOIN tamilnadu_2021 t21
ON t26.`ac_no.` = t21.`ac_no.`
ORDER BY margin_change DESC;

-- Q5 Where did voter participation rise or fall the most between 2021 and 2026 across Tamil Nadu’s regions?
SELECT 
    cm.region,
    CONCAT(ROUND(AVG(t21.poll_pct), 2), '%') AS turnout_2021,
    CONCAT(ROUND(AVG(t26.poll_pct), 2), '%') AS turnout_2026,
    CONCAT(
        ROUND(
            AVG(t26.poll_pct) - AVG(t21.poll_pct),
            2
        ),
        '%'
    ) AS turnout_change
FROM tamilnadu_2026 t26
JOIN tamilnadu_2021 t21
    ON t26.`ac_no.` = t21.`ac_no.`
JOIN constituency_master cm
    ON t26.`ac_no.` = cm.ac_number
GROUP BY cm.region
ORDER BY (AVG(t26.poll_pct) - AVG(t21.poll_pct)) DESC;

-- Q6 -  Which regions experienced the highest voter mandate shift?
SELECT 
    cm.region,
    COUNT(*) AS total_seats,
    SUM(CASE WHEN t26.party <> t21.party THEN 1 ELSE 0 END) AS flipped_seats,
    CONCAT(
        ROUND(
            SUM(CASE WHEN t26.party <> t21.party THEN 1 ELSE 0 END) * 100.0 
            / COUNT(*),
            2
        ),
        '%'
    ) AS flip_percent
FROM tamilnadu_2026 t26
JOIN tamilnadu_2021 t21
    ON t26.`ac_no.` = t21.`ac_no.`
JOIN constituency_master cm
    ON t26.`ac_no.` = cm.ac_number
GROUP BY cm.region
ORDER BY 
    SUM(CASE WHEN t26.party <> t21.party THEN 1 ELSE 0 END) * 100.0 
    / COUNT(*) DESC;
    
-- Q7 - How do regions compare in terms of electoral competitiveness and political safety?
SELECT 
    cm.region,
    SUM(CASE WHEN t26.margin_pct < 5 THEN 1 ELSE 0 END) AS nail_biter_seats,
    SUM(CASE WHEN t26.margin_pct >= 5 AND t26.margin_pct < 10 
             THEN 1 ELSE 0 END) AS moderate_seats,
    SUM(CASE WHEN t26.margin_pct >= 10 AND t26.margin_pct < 20 
             THEN 1 ELSE 0 END) AS comfortable_seats,
    SUM(CASE WHEN t26.margin_pct >= 20 THEN 1 ELSE 0 END) AS landslide_seats,
    COUNT(*) AS total_seats
FROM tamilnadu_2026 t26
JOIN constituency_master cm
    ON t26.`ac_no.` = cm.ac_number
GROUP BY cm.region
ORDER BY nail_biter_seats DESC;

-- Q8 -  Which constituencies witnessed the highest surge in voter participation?
SELECT 
    t26.`ac_no.`,
    t26.ac_name,
    ROUND(
        t26.poll_pct - t21.poll_pct,
        2
    ) AS turnout_change,
    ROUND(
        t26.margin_pct - t21.margin_pct,
        2
    ) AS margin_change
FROM tamilnadu_2026 t26
JOIN tamilnadu_2021 t21
    ON t26.`ac_no.` = t21.`ac_no.`
ORDER BY turnout_change DESC
LIMIT 20;

-- Q9 - Which constituencies recorded the weakest voter turnout?
SELECT 
    t26.`ac_no.`,
    t26.ac_name,
    ROUND(
        t26.poll_pct - t21.poll_pct,
        2
    ) AS turnout_change,
    ROUND(
        t26.margin_pct - t21.margin_pct,
        2
    ) AS margin_change
FROM tamilnadu_2026 t26
JOIN tamilnadu_2021 t21
    ON t26.`ac_no.` = t21.`ac_no.`
ORDER BY turnout_change ASC
LIMIT 20;

