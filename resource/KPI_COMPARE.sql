SELECT
   -- KPI CRS A FOR SGN LINE
   MAX(
      CASE
         WHEN "SCOPE" = 'A' THEN "KPI_COUNT"
         ELSE 0
      END
   ) AS "KPI_A",
   MAX(
      CASE
         WHEN "SCOPE" = 'B1' THEN "KPI_COUNT"
         ELSE 0
      END
   ) AS "KPI_B1",
   MAX(
      CASE
         WHEN "SCOPE" = 'B2' THEN "KPI_COUNT"
         ELSE 0
      END
   ) AS "KPI_B2",
   MAX(
      CASE
         WHEN "SCOPE" = 'MECH' THEN "KPI_COUNT"
         ELSE 0
      END
   ) AS "KPI_MECH",
   MAX(
      CASE
         WHEN "SCOPE" = 'TRAINEE' THEN "KPI_COUNT"
         ELSE 0
      END
   ) AS "KPI_TRAINEE"
FROM
   (
      -- Query KPI CRS A FOR SGN LINE
      SELECT
         CAST((sp_skill_demand.demand / 720) AS INTEGER) as "KPI_COUNT",
         'A' AS "SCOPE"
      FROM
         sp_skill_demand
      WHERE
         (
            ('@VAR.SHIFT@' = 'M' or '@VAR.SHIFT@' = 'm')
            AND sp_skill_demand.demandno_i = 703
         )
         OR (
            ('@VAR.SHIFT@' = 'N' or '@VAR.SHIFT@' = 'n')
            AND sp_skill_demand.demandno_i = 706
         )
      UNION
      ALL -- Query KPI CRS B1 FOR SGN LINE
      SELECT
         CAST((sp_skill_demand.demand / 720) AS INTEGER) as "KPI_COUNT",
         'B1' AS "SCOPE"
      FROM
         sp_skill_demand
      WHERE
         (
            ('@VAR.SHIFT@' = 'M' or '@VAR.SHIFT@' = 'm')
            AND sp_skill_demand.demandno_i = 502
         )
         OR (
            ('@VAR.SHIFT@' = 'N' or '@VAR.SHIFT@' = 'n')
            AND sp_skill_demand.demandno_i = 707
         )
      UNION
      ALL -- Query KPI CRS B2 FOR SGN LINE
      SELECT
         CAST((sp_skill_demand.demand / 720) AS INTEGER) as "KPI_COUNT",
         'B2' AS "SCOPE"
      FROM
         sp_skill_demand
      WHERE
         (
            ('@VAR.SHIFT@' = 'M' or '@VAR.SHIFT@' = 'm')
            AND sp_skill_demand.demandno_i = 702
         )
         OR (
            ('@VAR.SHIFT@' = 'N' or '@VAR.SHIFT@' = 'n')
            AND sp_skill_demand.demandno_i = 708
         )
      UNION
      ALL -- Query KPI MECH FOR SGN LINE
      SELECT
         CAST((sp_skill_demand.demand / 720) AS INTEGER) as "KPI_COUNT",
         'MECH' AS "SCOPE"
      FROM
         sp_skill_demand
      WHERE
         (
            ('@VAR.SHIFT@' = 'M' or '@VAR.SHIFT@' = 'm')
            AND sp_skill_demand.demandno_i = 704
         )
         OR (
            ('@VAR.SHIFT@' = 'N' or '@VAR.SHIFT@' = 'n')
            AND sp_skill_demand.demandno_i = 709
         )
      UNION
      ALL -- Query KPI TRAINEE FOR SGN LINE
      SELECT
         CAST((sp_skill_demand.demand / 720) AS INTEGER) as "KPI_COUNT",
         'TRAINEE' AS "SCOPE"
      FROM
         sp_skill_demand
      WHERE
         (
            ('@VAR.SHIFT@' = 'M' or '@VAR.SHIFT@' = 'm')
            AND sp_skill_demand.demandno_i = 705
         )
         OR (
            ('@VAR.SHIFT@' = 'N' or '@VAR.SHIFT@' = 'n')
            AND sp_skill_demand.demandno_i = 710
         )
   ) AS KPI_COUNTER