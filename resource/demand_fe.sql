SELECT    ROW_NUMBER() OVER (ORDER BY sp_skill_demand.demandno_i) AS "SEQ",
    sp_skill_demand.demandno_i,
    sp_skill_demand.short_code as "FLT_ROUTE",
    sp_skill_demand.scope as "SCOPE_REQ",
    sp_skill_demand.station as "STATION",
    sp_skill_demand.description as "DESC",
    sp_skill_demand.short_code as "SHORT_CODE"


FROM  
      sp_skill_demand
WHERE
sp_skill_demand.demandno_i IN (@REQ_FE.ID@)