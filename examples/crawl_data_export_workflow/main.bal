// Exports crawled URLs of a Botify analysis to CSV: reads the URL datamodel, starts an export for the
// chosen fields and waits for the export job to finish.

import ballerina/http;
import ballerina/io;
import ballerina/lang.regexp as re;
import ballerina/lang.runtime;
import ballerinax/botify;

configurable string apiToken = ?;
configurable string username = ?;
configurable string projectSlug = ?;
configurable string analysisSlug = ?;
configurable string exportFields = "url,http_code";
configurable int maxPolls = 30;
// Starting an export creates a job in the Botify account, so it is off unless requested.
configurable boolean runExport = false;

public function main() returns error? {
    botify:Client botifyClient = check new ({authorization: "Token " + apiToken});

    // Step 1: Read the datamodel and make sure the requested fields exist.
    botify:Datamodel datamodel = check botifyClient->getUrlsDatamodel(username, projectSlug, analysisSlug);
    string[] knownFields = datamodel.fields.'map(f => f.id);
    string[] fieldList = re:split(re `,`, exportFields);
    foreach string requested in fieldList {
        if knownFields.indexOf(requested) is () {
            return error("Field is not part of the datamodel: " + requested);
        }
    }
    io:println("Datamodel fields available: ", knownFields.length());
    if !runExport {
        io:println("Set runExport = true in Config.toml to start the export.");
        return;
    }

    // Step 2: Start the export.
    http:Request request = new;
    request.setJsonPayload({fields: fieldList});
    botify:CsvExportStatus exportJob = check botifyClient->createUrlsExport(username, projectSlug, analysisSlug, request);
    string? jobId = exportJob.jobId;
    if jobId is () {
        return error("The export response has no job id");
    }
    io:println("Export started: ", jobId);

    // Step 3: Poll the export status until it is done.
    foreach int attempt in 1 ... maxPolls {
        botify:CsvExportStatus status = check botifyClient->getUrlsExportStatus(username, projectSlug, analysisSlug, jobId);
        string? jobStatus = status.jobStatus;
        if jobStatus == "DONE" {
            io:println("Export finished, download URL: ", status.results ?: "not available");
            return;
        }
        if jobStatus == "FAILED" {
            return error("Export failed: " + jobId);
        }
        runtime:sleep(10);
    }
    return error("Export did not finish within " + maxPolls.toString() + " polls");
}
