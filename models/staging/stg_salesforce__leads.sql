
with 
    salesforce_leads as (
        select * from {{ ref("snp_salesforce__leads")}}
    ),

    base as (

        select 
            *,
            coalesce(phone, 0)::int as phone_clean,
            coalesce(
                concat(
                    lower(replace(street, ',', '')),
                    ' ',
                    lower(city),
                    ', ',
                    left(postal_code, 5)
                ),
                'None'
            ) as address_clean

        from salesforce_leads
        where dbt_valid_to is null 
    ),

    final as (

        select 
            {{ dbt_utils.generate_surrogate_key([
                'phone_clean',
                'address_clean'
                
            ])}} as lead_sk,
            * 

        from base
    ) 

select * from final 