# Examples

The `ballerinax/botify` connector provides practical examples illustrating usage in various scenarios.

1. [Site crawl health report](./site_crawl_health_report/site_crawl_health_report.md) - Collect a project's analyses and report crawl statistics and sitemap coverage for the latest one.
2. [Crawl data export workflow](./crawl_data_export_workflow/crawl_data_export_workflow.md) - Validate fields against the datamodel, start a URL export and wait for it to finish.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A Botify API token with access to the project (supplied as `Authorization: Token <token>`)

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
