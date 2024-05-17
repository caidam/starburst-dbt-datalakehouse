with data as (
    select *
    from {{ source("tpch", "orders") }} data
)

select *
from data