{{
    config(
        materialized = "incremental",
        unique_key = "lead_sk",
        on_schema_change = "append_new_columns"
    )

}}

with 
    source_leads as (
        select * from {{ ref("stg_source_three__leads") }}

        {% if is_incremental() %}
        -- filter applied to incremental run
        where insert_date > (select max(insert_date) from {{ this}})

        {% endif %}
    ),

    final as (
        select 
            *,
            '{{ invocation_id }}' as batch_id

        from source_leads
    )

select * from final 