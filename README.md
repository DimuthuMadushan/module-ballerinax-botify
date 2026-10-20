# Ballerina Botify connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-botify/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-botify/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-botify.svg)](https://github.com/ballerina-platform/module-ballerinax-botify/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/botify.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fbotify)

## Overview

The Botify connector provides programmatic access to the [Botify](https://www.botify.com/) SaaS API, which exposes SEO crawl, log and search analytics for websites. This connector supports version 1.0 of the Botify REST API and lets Ballerina integrations read projects, analyses and crawl results, query URL data, and run exports and jobs.

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

- [Site crawl health report](examples/site_crawl_health_report/site_crawl_health_report.md) - Collect a project's analyses and report crawl statistics and sitemap coverage for the latest one.
- [Crawl data export workflow](examples/crawl_data_export_workflow/crawl_data_export_workflow.md) - Validate fields against the datamodel, start a URL export and wait for it to finish.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`botify` package](https://central.ballerina.io/ballerinax/botify/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
