## Overview

The Botify connector provides programmatic access to the [Botify](https://www.botify.com/) SaaS API, which exposes SEO crawl, log and search analytics for websites. This connector supports version 1.0 of the Botify REST API and lets Ballerina integrations read projects, analyses and crawl results, query URL data, and run exports and jobs.

### Key features

- Browse projects, analyses and saved filters of a Botify account
- Retrieve crawl statistics, sitemap reports, link metrics and scoring summaries for an analysis
- Query URL datasets and run aggregation queries against an analysis or a whole project
- Create and track CSV URL exports and asynchronous jobs

## Setup guide

1. Sign in to your [Botify](https://app.botify.com/) account.

2. Open your account settings and generate an API token in the API section.

3. Keep the token and your Botify username (and project slug, when working on a project) at hand.

> **Note:** Botify expects the `Authorization` header in the form `Token <your-token>`, not `Bearer <your-token>`. The connector sends the `authorization` value exactly as you give it, so prefix the token with `Token ` yourself when creating the client (see Step 3 below).

## Quickstart

To use the Botify connector in your Ballerina application, update the `.bal` file as follows:

**Step 1:** Import the module and declare the configuration.

```ballerina
import ballerinax/botify;

configurable string apiToken = ?;
configurable string username = ?;
```

**Step 2:** Create a `Config.toml` file with your credentials.

```toml
apiToken = "<your-botify-api-token>"
username = "<your-botify-username>"
```

**Step 3:** Create a client. Pass the token with the `Token ` prefix; a bare token is rejected by Botify.

```ballerina
botify:Client botifyClient = check new ({authorization: "Token " + apiToken});
```

**Step 4:** Call an operation, for example list the projects of a user.

```ballerina
public function main() returns error? {
    botify:UserProjectsList _ = check botifyClient->getUserProjects(username);
}
```

## Examples

The Botify connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-botify/tree/main/examples/), covering the following use cases:

- [Site crawl health report](../examples/site_crawl_health_report/site_crawl_health_report.md) - Collect a project's analyses and report crawl statistics and sitemap coverage for the latest one.
- [Crawl data export workflow](../examples/crawl_data_export_workflow/crawl_data_export_workflow.md) - Validate fields against the datamodel, start a URL export and wait for it to finish.
