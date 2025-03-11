{% snapshot snp_salesforce__leads %}

{{

    config(
        target_schema = 'snapshots',
        unique_key = 'id',
        strategy = 'timestamp',
        updated_at = 'last_modified_date'
    )
}}

with 
    raw_leads as (
       select * from {{ source("sample_data", "salesforce_leads")}}
    )

select * 
from raw_leads

{% endsnapshot %}