with 

source as (

    select * from {{ source('mysql_de', 'actor') }}

),

renamed as (

    select
        cast(actor_id as int) as actor_id,
        first_name,
        last_name,
        last_update

    from source

)

select * from renamed