/**
 * Helper class for Jira triggers
 */
public with sharing class JiraTriggerHelper {
	/**
	 * Process Jira_Project__c records after insert
	 * @param newProjects List of newly inserted Jira_Project__c records
	 */
	public static void processProjectAfterInsert(List<Jira_Project__c> newProjects) {
		List<Jira_Project__c> projectsToProcess = new List<Jira_Project__c>();

		// Filter out projects that already have a Jira project ID
		for (Jira_Project__c project : newProjects) {
			if (String.isBlank(project.Project_ID__c)) {
				projectsToProcess.add(project);
			}
		}

		enqueueJob(new JiraCalloutQueueable(projectsToProcess, 20));
	}

	/**
	 * Process Jira_Issue__c records after insert
	 * @param newIssues List of newly inserted Jira_Issue__c records
	 *
	 * TODO: Implement this method to process new Jira issues
	 * The method should:
	 * 1. Filter out issues that already have a Jira issue key
	 * 2. Ensure the Project_Key__c field is not blank
	 * 3. Create a JiraCalloutQueueable for each issue and enqueue it
	 * 4. Don't enqueue if Test.isRunningTest() is true
	 */
	public static void processIssueAfterInsert(List<Jira_Issue__c> newIssues) {
		// Your implementation goes here
		List<Jira_Issue__c> issuesToProcess = new List<Jira_Issue__c>();
		for (Jira_Issue__c newIssue : newIssues) {
			if (String.isBlank(newIssue.Issue_Key__c) && !String.isBlank(newIssue.Project_Key__c)) {
				issuesToProcess.add(newIssue);
			}
		}

		enqueueJob(new JiraCalloutQueueable(issuesToProcess, 20));
	}

	/*
	 * Utilitary method to enqueue Queueable job
	 * @param JiraCalloutQueuable Queueable job to queue
	 */
	private static void enqueueJob(JiraCalloutQueueable callout) {
		if (!Test.isRunningTest()) {
			try {
				// Queue job if within queueable governor limits
				if (Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()) {
					// Queue job passing list of projects, to avoid hitting exceptions by queueing within loops, and batch size for chaining purposes
					System.enqueueJob(callout);
					return;
				}
				throw new JiraAPIService.JiraException(
					'Queueable jobs limit has been reached, the callouts to the Jira API could not be queued.'
				);
			} catch (Exception e) {
				CustomLogger.insertLog(e, 'ERROR');
			}
		}
	}
}
