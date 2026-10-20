# Crawl data export workflow

This example exports crawled URLs of a Botify analysis to CSV. It reads the analysis datamodel to validate the requested fields, starts an export job, and polls the job until the export is done. Starting the export is disabled by default because it creates a job in the account.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A Botify API token, the project owner's username, the project slug, and an analysis slug
- Create a `Config.toml` in this directory:
  ```toml
  apiToken = "<your-botify-api-token>"
  username = "<botify-username>"
  projectSlug = "<project-slug>"
  analysisSlug = "<analysis-slug>"
  exportFields = "url,http_code"
  maxPolls = 30
  runExport = true
  ```

## Run the example

```bash
bal run
```
