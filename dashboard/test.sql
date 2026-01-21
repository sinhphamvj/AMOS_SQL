INSERT INTO part_special (
          part_specialno_i,
          partno,
          special,
          remarks,
          mutator,
          mutation,
          mutation_time
       ) VALUES (
          (
             SELECT COALESCE(
                       MAX(part_specialno_i),
                       0
                    ) + 1
             FROM part_special
          ),
          '11-028',
          'NO_PRU',
          'NO LIV UPDATE FROM JAN2026',
          'VJC18599',
          19737,
          12334507
       )   - Pid:3,
       697,
       771 - 1 row(s) affected
