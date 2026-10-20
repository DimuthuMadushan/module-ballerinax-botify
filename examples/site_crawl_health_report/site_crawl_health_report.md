# Site crawl health report

This example builds a crawl health report for a Botify project. It looks up the project, collects its analyses page by page, and prints the crawl statistics and sitemap coverage of the latest analysis.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A Botify API token, the project owner's username, and the project slug
- Create a `Config.toml` in this directory:
  ```toml
  apiToken = "<your-botify-api-token>"
  username = "<botify-username>"
  projectSlug = "<project-slug>"
  ```

## Run the example

```bash
bal run
```
