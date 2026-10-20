_Author_:  @DimuthuMadushan \
_Created_: 2026/10/20 \
_Updated_: 2026/10/20 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Botify. 
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/botify/botify/1.0.0/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. The original specification had no `summary` on any of its 48 operations (one carried the summary `Legacy`). A short summary was added to every operation in the original spec (`docs/spec/openapi.json`), applied from `docs/spec/description-decisions.json` with `tooling/apply_descriptions.py`. The same file also supplies the missing property and parameter descriptions (`Query`, `SavedExplorer`, `JobResults`, `AnalysisSegments`, `ProjectSavedFilter`, `QueryResponses`, `DefaultPayload.error` and the `identifier` path parameter of `getFilter`), added in the original spec only. A description was also added to the `DjangoRestToken` security definition in the original spec.

2. The `url` path parameter of `getUrlAI`, `getUrlHTML` and `getUrlDetail` was described as `(Urlencoded) Searched URL`, which invites callers to pre-encode a value that the client encodes again. Its description was changed in the original spec to ask for a raw, unencoded URL. The same wording was also written into `aligned_ballerina_openapi.json` so the client could be regenerated without a re-align; a re-align reproduces it from the original spec.

3. The `info.description` was only the name `Botify Saas API`. It was rewritten in the original spec as two plain sentences describing the API, and the same text was written into `aligned_ballerina_openapi.json` so the client could be regenerated without a re-align.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --license docs/license.txt --client-methods remote
```

Note: The license year is hardcoded to 2024, change if necessary.
