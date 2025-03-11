
with 
    source_one_leads as (
        select * from {{ source("sample_data", "source_one")}}
    ),

    base as (

        select 
            *, 
            coalesce(replace(phone, '-', ''), 0)::int as phone_clean,
            coalesce(
                concat(
                    left(
                        lower(address), 
                        len(address) - 10
                    ), 
                    ', ', 
                    right(address, 5)
                ),
                'None'
            ) as address_clean

        from source_one_leads
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