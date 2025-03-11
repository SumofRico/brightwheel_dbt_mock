Welcome to my Brightwheel mock dbt project!

## Tradoffs 

- Data clean up
  - Generally, I would have liked to spend more time on cleaning up fields in the staging layer for easier use in downstream models/reports.
  - Spending more time on the fields used for the surrogate key (address (street, city, 5-digit zip code) and phone number) would be essential for a production model. Address is complicated to standardize across the data models. An API source to create a standard address would benefit here. Based on my understanding of using phone numbers and addresses, I used the surrogate key to create a standard primary key across the data sources and drive all other models.
- Confirming incremental model logic work for production models.
- Adding documentation
  - Generally speaking, I would typically like to add documentation as I go so it's not a forgotten to-do item.
- Adding more tests
  - Adding additional tests on source data and unit tests based on requirements/learnings would be good for a production model.
 
## Longer Term ETL Strategies

Long term I would like to confirm the ingestion process for the lead source files. Is it required to do on big load each month with new and existing leads? 
- Is it possible to include a data filter to create better and insert_date of the data > leading to better incremental dbt models.

I set the dbt project to include Staging, Warehouse, and Mart layers.
- Staging: 1:1 with raw data with some light transformations (clean-up and additional transformations that don't require a join)
- Warehouse: meant to house the dim/fct models to build reports for analysts.
  - Also included are incremental models for the ETL process for sources 1-3. This is more of an intermediate step; it could use refining on where to store long-term. Incremental models set to accept schema changes by adding any new columns, which is good if we expect the source formatting to change.
- Mart: reporting layer for business teams.

Snapshtos were also included for the Salesforce Leads, including history tracking for historical reporting. Good for slowly changing dimensions, could answer how long a lead is a particular status, for example. Snapshots could also be used for the other sources, but initial thoughts are that it would be as much of a benefit -- could configure using column check strategy.

## How I explored the data

I started scanning the spreadsheet for the type of data available and matching that with the requirements and possible questions we would be trying to answer with said data. I continued to explore as I built the dbt models and considered what would be needed to make the models work well (incremental model requirements, surrogate keys, etc.,). 

## Testing, QA, and data validation

I made the most tradeoff here based on the time requirements. I added some standard tests for this exercise and a simple unit test. In production, I would work closely with stakeholders to determine the testing needed to valdiate the data in addition to standard tests. 

## Anything else

Hope the review process goes smoothly! This was a fun process!
