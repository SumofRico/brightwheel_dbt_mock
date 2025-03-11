{{
    config(
        materialized = "table"
    )

}}


with
    salesforce_leads as (
        select * from {{ ref("stg_salesforce__leads")}}
    ),

    source_one_leads as (
        select * from {{ ref("stg_source_one__leads")}}
    ),

    source_two_leads as (
        select * from {{ ref("stg_source_two__leads")}}
    ),

    source_three_leads as (
        select * from {{ ref("stg_source_three__leads")}}
    ),


    salesforce_join as (
        select 
            sf.*,
            one.credential_type as lead_credential_type,
            two.type_license as lead_license_type,
            three.capacity as lead_capacity

        from salesforce_leads as sf
            left join source_one_leads as one on sf.lead_sk = one.lead_sk
            left join source_two_leads as two on sf.lead_sk = two.lead_sk
            left join source_three_leads as three on sf.lead_sk = three.lead_sk
        where not sf.is_deleted
    ),   

    union_leads as (

        select 
            lead_sk,
            company             as lead_company,
            phone_clean         as lead_phone,
            address_clean       as lead_address,
            lead_source,
            status              as lead_status,
            created_date        as lead_sf_created_date,
            is_converted        as is_lead_converted,
            outreach_stage_c    as lead_out_reach_stage,

            lead_credential_type,
            lead_license_type,
            lead_capacity

        from salesforce_join as sf 

        union all 

        select 

            lead_sk,
            name                as lead_company_name,
            phone_clean         as lead_phone,
            address_clean       as lead_address,
            'source_one'        as lead_source,
            null                as lead_status,
            null                as lead_sf_created_date,
            null                as is_lead_converted,
            null                as lead_out_reach_stage,

            credential_type     as lead_credential_type,
            null                as lead_license_type,
            null                as lead_capacity

        from source_one_leads as one 
        where not exists (select 1 from salesforce_leads as sf where sf.lead_sk = one.lead_sk)

        union all 

        select 
            lead_sk,
            company             as lead_company_name,
            phone_clean         as lead_phone,
            address_clean       as lead_address,
            'source_two'        as lead_source,
            null                as lead_status,
            null                as lead_sf_created_date,
            null                as is_lead_converted,
            null                as lead_out_reach_stage,

            null                as lead_credential_type,
            type_license        as lead_license_type,
            null                as lead_capacity
            
        from source_two_leads as two
        where not exists (select 1 from salesforce_leads as sf where sf.lead_sk = two.lead_sk)
        
        union all 

        select 
            lead_sk,
            operation_name      as lead_company_name,
            phone_clean         as lead_phone,
            address_clean       as lead_address,
            'source_two'        as lead_source,
            null                as lead_status,
            null                as lead_sf_created_date,
            null                as is_lead_converted,
            null                as lead_out_reach_stage,

            null                as lead_credential_type,
            null                as lead_license_type,
            capacity            as lead_capacity

        from source_three_leads as three
        where not exists (select 1 from salesforce_leads as sf where sf.lead_sk = three.lead_sk)

    ),


    final as (

        select *
        from union_leads
    )

select * from final 