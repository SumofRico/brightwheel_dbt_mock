
with 
    source_two_leads as (
        select * from {{ source("sample_data", "source_two")}}
    ),

    base as (

        select             
            *, 
            coalesce(
                regexp_replace(
                    phone,
                    '\\(|\\)|\\-|\\s',
                    ''
                ), 
                0
            )::int as phone_clean,
            coalesce(
                concat(
                    lower(replace(address1, ',', '')),
                    ' ',
                    lower(city),
                    ', ',
                    left(zip, 5)
                ),
                'None'
            ) as address_clean
        from source_two_leads
    ),

    final as ( 

        select 
            {{ dbt_utils.generate_surrogate_key([
                'phone_clean',
                'address_clean'
                
            ])}} as lead_sk,
            *,
            dateadd('days', -1, current_date()) as insert_date -- theoretical load date from extract tool/code
            
        from base 
    ) 

select * from final 