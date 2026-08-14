

select 
output_address,
sum(output_value) as total,
count(*) as tx_count

from {{ref('stg_btc_transactions')}}

where output_value > 10

group by output_address
order by total desc