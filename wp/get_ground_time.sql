select
   ac_registr,
   sched_tac_at_arrival,
   fn_number,
   sched_arrival_airport,
   sched_departure_airport,
   sched_arrival_date,
   sched_departure_date,
   sched_arrival_time,
   sched_departure_time,
   legno_i,
   next_departure_time,
   case
      when next_departure_time is null then null
      else case
         when (next_departure_time - sched_arrival_time) < 0 then (next_departure_time + 1440) - sched_arrival_time
         else (next_departure_time - sched_arrival_time)
      end
   end as ground_time
from
   (
      select
         ac_future_flights.ac_registr,
         ac_future_flights.sched_tac_at_arrival,
         ac_future_flights.fn_number,
         ac_future_flights.sched_arrival_airport,
         ac_future_flights.sched_departure_airport,
         ac_future_flights.sched_arrival_date,
         ac_future_flights.sched_departure_date,
         ac_future_flights.sched_arrival_time,
         ac_future_flights.sched_departure_time,
         ac_future_flights.legno_i,
         lead(ac_future_flights.sched_departure_time) over (
            order by
               ac_future_flights.sched_tac_at_arrival
         ) as next_departure_time,
         case
            when lead(ac_future_flights.sched_departure_time) over (
               order by
                  ac_future_flights.sched_tac_at_arrival
            ) is null then null
            else case
               when (lead(ac_future_flights.sched_departure_time) over (
                  order by
                     ac_future_flights.sched_tac_at_arrival
               ) - ac_future_flights.sched_arrival_time) < 0 then (lead(ac_future_flights.sched_departure_time) over (
                  order by
                     ac_future_flights.sched_tac_at_arrival
               ) + 1440) - ac_future_flights.sched_arrival_time
               else (lead(ac_future_flights.sched_departure_time) over (
                  order by
                     ac_future_flights.sched_tac_at_arrival
               ) - ac_future_flights.sched_arrival_time)
            end
         end as ground_time
      from
         ac_future_flights
      where
         ac_future_flights.ac_registr IN ('A522', 'A523', 'A525')
         and ac_future_flights.sched_departure_date = 19359
   ) as flight_data
where
   ground_time = (
      select
         max(ground_time)
      from
         (
            select
               ac_future_flights.ac_registr,
               case
                  when lead(ac_future_flights.sched_departure_time) over (
                     order by
                        ac_future_flights.sched_tac_at_arrival
                  ) is null then null
                  else case
                     when (lead(ac_future_flights.sched_departure_time) over (
                        order by
                           ac_future_flights.sched_tac_at_arrival
                     ) - ac_future_flights.sched_arrival_time) < 0 then (lead(ac_future_flights.sched_departure_time) over (
                        order by
                           ac_future_flights.sched_tac_at_arrival
                     ) + 1440) - ac_future_flights.sched_arrival_time
                     else (lead(ac_future_flights.sched_departure_time) over (
                        order by
                           ac_future_flights.sched_tac_at_arrival
                     ) - ac_future_flights.sched_arrival_time)
                  end
               end as ground_time
            from
               ac_future_flights
            where
               ac_future_flights.ac_registr IN ('A522', 'A523', 'A525')
               and ac_future_flights.sched_departure_date = 19359
         ) as inner_flight_data
      group by
         ac_future_flights.ac_registr
   )
order by
   sched_tac_at_arrival ASC