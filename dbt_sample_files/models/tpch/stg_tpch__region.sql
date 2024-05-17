with 

source as (

    select * from {{ source('tpch', 'region') }}

),

renamed as (

    select
        regionkey,
        name,
        comment

    from source

)

select * from renamed
