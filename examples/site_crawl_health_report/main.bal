// Builds a crawl health report for a Botify project: lists the user's projects, finds the most recent
// analyses of the chosen project and prints crawl statistics and the sitemap report for the latest one.

import ballerina/io;
import ballerinax/botify;

configurable string apiToken = ?;
configurable string username = ?;
configurable string projectSlug = ?;

public function main() returns error? {
    botify:Client botifyClient = check new ({authorization: "Token " + apiToken});

    // Step 1: Confirm the project exists for the user by matching its slug across all project pages.
    botify:Project[] projectList = [];
    int projectPage = 1;
    while true {
        botify:UserProjectsList projects = check botifyClient->getUserProjects(username, page = projectPage, size = 50);
        botify:Project[] pageProjects = projects.results ?: [];
        projectList.push(...pageProjects);
        if pageProjects.length() < 50 {
            break;
        }
        projectPage += 1;
    }
    botify:Project[] matches = projectList.filter(p => p.slug == projectSlug);
    if matches.length() == 0 {
        return error("No project with slug " + projectSlug + " found for " + username);
    }
    io:println("Projects visible to ", username, ": ", projectList.length(), ", reporting on: ", matches[0].name);

    // Step 2: Collect the successfully finished analyses of the project, following pages until a short page
    // is returned. Unfinished analyses are left out on purpose: they have no final crawl statistics to report.
    botify:Analysis[] analyses = [];
    int pageNumber = 1;
    while true {
        botify:ProjectAnalysesList page = check botifyClient->getProjectAnalyses(username, projectSlug, page = pageNumber, size = 50, onlySuccess = true);
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
    botify:SitemapsReportSitemap[] sitemapList = sitemaps.sitemaps ?: [];
    int validUrls = 0;
    int invalidUrls = 0;
    foreach botify:SitemapsReportSitemap sitemap in sitemapList {
        validUrls += sitemap.validUrls ?: 0;
        invalidUrls += sitemap.invalidUrls ?: 0;
    }
    io:println("Sitemaps found: ", sitemapList.length(), ", valid URLs: ", validUrls, ", invalid URLs: ", invalidUrls);
}
