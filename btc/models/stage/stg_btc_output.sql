{{ config(materialized = 'incremental', incremental_strategy = 'append')}}


with flattened_outputs as (

select
tx.HASH_KEY
, tx.BLOCK_NUMBER
, tx.BLOCK_TIMESTAMP
, tx.is_coinbase
, f.value:address::string as  output_address
, f.value:value::float as output_value

from {{ref ('stage_btc')}} tx,
LATERAL FLATTEN (input => outputs) f

where f.value:address is not null

{%if is_incremental()%}

where tx.BLOCK_TIMESTAMP >= (select max(tx.BLOCK_TIMESTAMP) from {{this}})

{%endif%}

)

select
HASH_KEY,
BLOCK_NUMBER,
BLOCK_TIMESTAMP,
is_coinbase,
output_address,
output_value
from flattened_outputs