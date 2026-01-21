SELECT
od_header.orderno,
od_header.order_type,
od_header.state, --O = Open C = Closed T = Temporary N = Not correctly filled (when coming from RA)
    od_detail.currency,
    od_detail.priority,
    od_detail.projectno,
    od_detail.ext_state, --O = Open C = Closed T = Temporary N = Not correctly filled (when coming from RA)
    od_detail.requested_serialno,
    od_detail.serialno,
    od_detail.state,
    od_detail.partno as "PART",
    od_detail.rate,
    od_detail.purch_price,
    od_detail.purch_pricec,
    od_detail.amount,
    od_detail.amountc,
    od_detail.discount,
    od_detail.target_date,
    od_detail.confirmed_date,
    od_detail.reason,
    od_detail.status,
    od_detail.req_qty,
    od_detail.specification,
    part_fa_entity.purch_price,
    part_fa_entity.average_price,
    part.description as "DESC",
(part_fa_entity.purch_price * od_detail.req_qty) AS "AMOUNT"

FROM od_header
LEFT JOIN od_detail ON od_detail.orderno_i = od_header.orderno_i
LEFT JOIN part ON od_detail.partno = part.partno
LEFT JOIN part_fa_entity ON part_fa_entity.partno = od_detail.partno

WHERE
od_detail.projectno = 'PP_TET_2026'
AND od_detail.ext_state NOT IN ('CA','T') -- exclude cancel order and temporary
AND od_header.order_type NOT IN ('T','Q') -- exclude transfer order and quote order

LIMIT 1000