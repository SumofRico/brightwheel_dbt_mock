with 
    dim_leads as (
        select * from {{ ref("dim_leads") }}
    )

select 
    lead_source,
    count(*) as number_of_leads 

from dim_leads
group by lead_source