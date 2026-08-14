{{config(materialized = 'ephemeral')}}

select
*
from {{ref ('stg_btc_output')}}