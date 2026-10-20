// Builds a crawl health report for a Botify project: lists the user's projects, finds the most recent
// analyses of the chosen project and prints crawl statistics and the sitemap report for the latest one.

import ballerina/io;
import ballerinax/botify;

configurable string apiToken = ?;
configurable string username = ?;
configurable string projectSlug = ?;

public function main() returns error? {
    botify:Client botifyClient = check new ({authorization: "Token " + apiToken});

    // Step 1: Confirm the project exists for the user.
    botify:UserProjectsList projects = check botifyClient->getUserProjects(username, name = projectSlug);
    botify:Project[] projectList = projects.results ?: [];
    io:println("Projects visible to ", username, ": ", projectList.length());

    // Step 2: Collect all analyses of the project, following pages until a short page is returned.
    botify:Analysis[] analyses = [];
    int pageNumber = 1;
    while true {
        botify:ProjectAnalysesList page = check botifyClient->getProjectAnalyses(username, projectSlug, page = pageNumber, size = 50);
        botify:Analysis[] pageResults = page.results ?: [];
        analyses.push(...pageResults);
        if pageResults.length() < 50 {
            break;
        }
        pageNumber += 1;
    }
    if analyses.length() == 0 {
        return error("No analyses found for project " + projectSlug);
    }
    string? latestSlug = analyses[0].slug;
    if latestSlug is () {
        return error("The latest analysis has no slug");
    }
    io:println("Analyses found: ", analyses.length(), ", latest: ", latestSlug);

    // Step 3: Crawl statistics of the latest analysis.
    botify:CrawlStatistics stats = check botifyClient->getCrawlStatistics(username, projectSlug, latestSlug);
    io:println("Pages crawled: ", stats.pagesDones, " of ", stats.pagesKnown);
    io:println("2xx: ", stats.pagesDones2xx, ", 3xx: ", stats.pagesDones3xx, ", 4xx: ", stats.pagesDones4xx, ", 5xx: ", stats.pagesDones5xx);

    // Step 4: Sitemap coverage of the latest analysis.
    botify:SitemapsReport sitemaps = check botifyClient->getSitemapsReport(username, projectSlug, latestSlug);
    io:println("Sitemaps found: ", (sitemaps.sitemaps ?: []).length());
}
