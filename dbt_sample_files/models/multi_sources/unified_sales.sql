with 

tpch_orders as (

    select * from {{ source('tpch', 'orders') }}

),

de_rentals as (

    select * from {{ source('mysql_de', 'payment') }}

),

unioned as (

    select
        cast(orderkey as int) as id,
        cast(orderdate as date) as refdate,
        cast(totalprice as int) as amount
    from tpch_orders

    union all

    select
        cast(payment_id as int) as id,
        cast(payment_date as date) as refdate,
        cast(amount as int) as amount

    from de_rentals
)

select * from unioned