SELECT
    forecast.ac_registr,
 forecast.workorderno_display,
    forecast.remarks,
    forecast.mutation_time,
    forecast.created_by,
    forecast.created_date,
forecast.expected_date
FROM forecast
WHERE forecast.ac_registr IN (
              'A629',
              'A669',
              'A546',
              'A667',
              'A668',
              'A544',
              'A666',
              'A542',
              'A663',
              'A543'
           )
           AND forecast.planner_relevant = 'Y'
           AND forecast.shop_doc = 'N'
           AND forecast.expected_date < 19327  -- Thay đổi điều kiện ở đây
           AND forecast.expected_date <> 19325;