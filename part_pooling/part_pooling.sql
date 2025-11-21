SELECT 
       od_header.orderno,
       od_detail.ac_registr,
       od_rec_detail.partno,
       od_rec_detail.serialno,
       od_rec_detail.batchno,
       od_header.old_orderno,
       od_header.order_type,
       od_header.state,
       od_header.orderdate,
       od_header.responsible,
       od_header.entry_date,
       od_header.entry_sign,
       od_header.address_issue,
       od_header.closing_date,
       od_header.ext_state,
       od_rec_detail.receivingno,
       od_rec_detail.detailno_i, 
       od_rec_detail.status,
       od_rec_detail.recno,
       od_rec_detail.ext_qty 

FROM od_header
LEFT JOIN od_rec_detail ON od_header.orderno = od_rec_detail.orderno
LEFT JOIN od_detail ON od_header.orderno_i = od_detail.orderno_i



WHERE od_header.order_type IN (`PR`,`PX`) 
      AND od_header.ext_state IN ( 'R','PR')
      AND od_rec_detail.status <> 9
      AND od_header.orderdate >= 19541
