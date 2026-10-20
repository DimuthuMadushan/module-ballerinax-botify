// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations

import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.botify.com/v1" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("BOTIFY_API_TOKEN") : "test_token";
final string username = isLiveServer ? os:getEnv("BOTIFY_USERNAME") : "jane.doe";
final string projectSlug = isLiveServer ? os:getEnv("BOTIFY_PROJECT_SLUG") : "example-site";
final string analysisSlug = isLiveServer ? os:getEnv("BOTIFY_ANALYSIS_SLUG") : "20240301";

final Client botify = check new ({authorization: "Token " + token}, serviceUrl = serviceUrl,
    config = {httpVersion: http:HTTP_1_1});

function jsonRequest(json payload) returns http:Request {
    http:Request request = new;
    request.setJsonPayload(payload);
    return request;
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetProjectAnalyses() returns error? {
    ProjectAnalysesList response = check botify->getProjectAnalyses(username, projectSlug);
    test:assertTrue(response.results is Analysis[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testLaunchAnalysisCreate() returns error? {
    if isLiveServer {
        return;
    }
    AnalysisCreateAndLaunch _ = check botify->launchAnalysisCreate(username, projectSlug);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetAnalysisSummary() returns error? {
    AnalysisDetail response = check botify->getAnalysisSummary(username, projectSlug, analysisSlug);
    test:assertTrue(response.slug is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetCrawlStatistics() returns error? {
    CrawlStatistics response = check botify->getCrawlStatistics(username, projectSlug, analysisSlug);
    test:assertTrue(response.pagesDones > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetCrawlStatisticsByFrequency() returns error? {
    CrawlStatisticsTime response = check botify->getCrawlStatisticsByFrequency(username, projectSlug, analysisSlug, frequency = "5mn");
    test:assertTrue(response.httpCode2xx.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetLinksPercentiles() returns error? {
    LinksPercentiles response = check botify->getLinksPercentiles(username, projectSlug, analysisSlug);
    test:assertTrue(response.percentiles.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetScoring() returns error? {
    ScoringSummary response = check botify->getScoring(username, projectSlug, analysisSlug);
    test:assertTrue(response.results.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetSitemapsReport() returns error? {
    SitemapsReport response = check botify->getSitemapsReport(username, projectSlug, analysisSlug);
    test:assertTrue(response.sitemaps is SitemapsReportSitemap[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testPauseAnalysis() returns error? {
    if isLiveServer {
        return;
    }
    AnalysisPause _ = check botify->pauseAnalysis(username, projectSlug, analysisSlug);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testResumeAnalysis() returns error? {
    if isLiveServer {
        return;
    }
    AnalysisResume _ = check botify->resumeAnalysis(username, projectSlug, analysisSlug);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetAnalysisSegments() returns error? {
    AnalysisSegmentsList response = check botify->getAnalysisSegments(username, projectSlug, analysisSlug);
    test:assertTrue(response.results is AnalysisSegments[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetUrls() returns error? {
    UrlsPage response = check botify->getUrls(username, projectSlug, analysisSlug,
        jsonRequest({fields: ["url", "http_code"]}));
    test:assertTrue(response.results is UrlDetail[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetUrlsAggs() returns error? {
    Aggs[] response = check botify->getUrlsAggs(username, projectSlug, analysisSlug,
        jsonRequest({queries: []}));
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetUrlsDatamodel() returns error? {
    Datamodel response = check botify->getUrlsDatamodel(username, projectSlug, analysisSlug);
    test:assertTrue(response.fields.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetUrlsExports() returns error? {
    UrlsExportsList response = check botify->getUrlsExports(username, projectSlug, analysisSlug);
    test:assertTrue(response.results is CsvExportStatus[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateUrlsExport() returns error? {
    if isLiveServer {
        return;
    }
    CsvExportStatus response = check botify->createUrlsExport(username, projectSlug, analysisSlug,
        jsonRequest({fields: ["url"]}));
    test:assertTrue(response.jobId is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetUrlsExportStatus() returns error? {
    if isLiveServer {
        return;
    }
    CsvExportStatus response = check botify->getUrlsExportStatus(username, projectSlug, analysisSlug, "1001");
    test:assertEquals(response.jobStatus, "DONE");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetUrlDetail() returns error? {
    UrlDetail _ = check botify->getUrlDetail(username, projectSlug, analysisSlug, "https%3A%2F%2Fwww.example.com%2F");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetJobs() returns error? {
    JobsList response = check botify->getJobs();
    test:assertTrue(response.results is JobResults[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateJob() returns error? {
    if isLiveServer {
        return;
    }
    JobResults response = check botify->createJob(jsonRequest({job_type: "export"}));
    test:assertTrue(response.jobId is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetJob() returns error? {
    if isLiveServer {
        return;
    }
    JobResults response = check botify->getJob("1001");
    test:assertEquals(response.jobId, "1001");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetUserProjects() returns error? {
    UserProjectsList response = check botify->getUserProjects(username);
    test:assertTrue(response.results is Project[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetProjectCollections() returns error? {
    if isLiveServer {
        return;
    }
    Collection response = check botify->getProjectCollections(username, projectSlug);
    test:assertTrue(response.id.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testProjectQuery() returns error? {
    ProjectQueryResult response = check botify->projectQuery(username, projectSlug,
        jsonRequest({collections: ["crawl.20240301"]}));
    test:assertTrue(response.results is QueryResponses[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetAllUserProjects() returns error? {
    if isLiveServer {
        return;
    }
    Project response = check botify->getAllUserProjects(username);
    test:assertTrue(response.slug.length() > 0);
}
