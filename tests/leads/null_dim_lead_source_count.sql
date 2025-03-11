with 
    null_lead_source_count as (
        select 
            count(*) as n_nulls

        from {{ ref("dim_leads") }}
        where lead_source is null 
    )

select 'null lead sources in dim_leads model'
from null_lead_source_count
where n_nulls > 0