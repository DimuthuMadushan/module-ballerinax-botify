# Running Tests

## Prerequisites

To run the tests against the live Botify API, you need a Botify API token, the owner's username, a project slug and an analysis slug.

## Test environments

The tests run against a local mock service by default. The mock serves the 25 operations that are tested: analyses, crawl statistics, sitemaps, segments, URL queries, exports, jobs and projects.

To run against the live API, set the `IS_LIVE_SERVER` environment variable to `true` and provide the credentials:

```bash
export IS_LIVE_SERVER=true
export BOTIFY_API_TOKEN=<api-token>
export BOTIFY_USERNAME=<username>
export BOTIFY_PROJECT_SLUG=<project-slug>
export BOTIFY_ANALYSIS_SLUG=<analysis-slug>
```

Operations that create or change state (launch, pause, resume, exports and jobs) are skipped against the live API.

## Running the tests

1. To run the tests against the mock service:

   ```bash
   bal test --groups mock_tests
   ```

2. To run the tests against the live API:

   ```bash
   bal test --groups live_tests
   ```
