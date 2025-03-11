Welcome to my Brightwheel mock dbt project!


# Project Implementation Details

## Tradeoffs

- **Data Cleaning and Standardization**
  - With more time, I would have implemented more thorough field cleaning in the staging layer to improve downstream model usability.
  - The surrogate key implementation using address (street, city, 5-digit zip code) and phone number requires additional refinement for production use. Address standardization is particularly challenging across different data sources—an address standardization API would significantly improve matching accuracy. The current surrogate key approach serves as a functional primary key across data sources but would benefit from further optimization.

- **Incremental Model Validation**
  - Additional testing of incremental model logic would be necessary before deploying to production to ensure proper handling of historical and new data.

- **Documentation**
  - In a production environment, I would integrate documentation into the development workflow rather than treating it as a separate phase, ensuring comprehensive and up-to-date documentation.

- **Testing Coverage**
  - The current implementation includes basic tests, but a production model would require expanded test coverage, including source data validation, column-level tests, and business logic validation based on stakeholder requirements.

## Longer-Term ETL Strategies

I would consider revisiting the lead source file ingestion process to answer key questions:

- Is a monthly full load of both new and existing leads necessary, or could we implement a more efficient delta-based approach?
- Could we enhance the source data with reliable insert/update timestamps to better support incremental processing models?

The project follows a three-layer architecture:

- **Staging Layer**: Provides a 1:1 representation of source data with minimal transformations (type casting, basic cleaning, and field standardization without joins)
- **Warehouse Layer**: Houses dimensional and fact models (dim_leads, fct_lead_activity) optimized for analytical queries
  - Includes incremental models for sources 1-3 that accommodate schema changes by automatically incorporating new columns—particularly valuable if source formats evolve over time
- **Mart Layer**: Contains business-specific reporting models tailored for end-user consumption

## Snapshot Implementation

I implemented snapshots for Salesforce Leads to track historical changes, particularly useful for analyzing lead status duration and other slowly changing dimensions. The snapshot strategy uses timestamp-based.

While snapshots could be implemented for other sources, I would say it has limited benefit compared to the Salesforce data at first glance. If needed, we could implement column-check strategy snapshots for these additional sources.

## Data Exploration Approach

My exploration process involved:
1. Analyzing source data structure and content to identify key entities and relationships
2. Mapping available fields to business requirements and potential analytical questions
3. Iteratively refining the data model as I built dbt models, focusing on surrogate key design, incremental processing requirements, and dimensional modeling best practices

## Testing and Validation

While time constraints limited comprehensive test coverage, I implemented:
- Standard dbt tests (not_null, unique, referential integrity)
- A basic unit test for lead classification logic

In a production environment, I would collaborate with stakeholders to develop a more robust testing strategy, including data quality checks, business rule validation, and reconciliation with source systems.


## Anything else

Hope the review process goes smoothly! This was a fun process!
