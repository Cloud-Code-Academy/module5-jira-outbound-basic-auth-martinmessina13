// Create a project wrapper
JiraWrapper.IssueWrapper issueWrapper = new JiraWrapper.IssueWrapper(
    'TP4',
	'Test Issue Summary',
	'Test Description',
	'Task'
);

System.debug('issue wrapper: ' + issueWrapper);

// Call the method to test
String issueId = JiraAPIService.createIssue(issueWrapper);

System.debug('issueId: ' + issueId);