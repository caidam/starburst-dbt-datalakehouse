with 

source as (

    select * from {{ source('mysql_de', 'film') }}

),

renamed as (
    -- all casts are necessary for compatibility reasons between sources
    select
        cast(film_id as int) as film_id,
        title,
        description,
        release_year,
        cast(language_id as int) as language_id,
        cast(original_language_id as int) as original_language_id,
        cast(rental_duration as int) as rental_duration,
        rental_rate,
        length,
        replacement_cost,
        rating,
        cast(special_features as varchar) as special_features,
        last_update

    from source

)

select * from renamed
