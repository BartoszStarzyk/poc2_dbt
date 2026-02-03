-- To avoid issues with CREATE OR ALTER, suspend all of the tasks from root to child
-- ALTER TASK IF EXISTS ensures this file can execute on first run each time a task is added
ALTER TASK IF EXISTS run_project_subset SUSPEND;
ALTER TASK IF EXISTS run_project_full SUSPEND;
ALTER TASK IF EXISTS test_project SUSPEND;

-- This would be an example scenario where you have a subset of the DAG that needs to be available early for business needs:
CREATE OR ALTER TASK run_project_subset
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '12 hours'
  AS
      execute dbt project my_dbt_project_object_gh_action args='run --select raw_customers stg_customers customers --target prod';

-- Kick off a complete run of the full project
CREATE OR ALTER TASK run_project_full
  WAREHOUSE = COMPUTE_WH
  AFTER run_project_subset
  AS
      execute dbt project my_dbt_project_object_gh_action args='run --target prod';

-- Run any data quality tests you've defined
CREATE OR ALTER TASK test_project
  WAREHOUSE = COMPUTE_WH
  AFTER run_project_full
  AS
      execute dbt project my_dbt_project_object_gh_action args='test --target prod';

-- When a task is first created or if an existing task it paused, it MUST BE RESUMED to be activated
-- The tasks must be enabled in REVERSE ORDER from child to root
ALTER TASK IF EXISTS test_project RESUME;
ALTER TASK IF EXISTS run_project_full RESUME;
ALTER TASK IF EXISTS run_project_subset RESUME;