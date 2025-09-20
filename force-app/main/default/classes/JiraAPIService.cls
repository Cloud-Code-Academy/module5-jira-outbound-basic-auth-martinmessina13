/**
 * Service class for making callouts to the Jira API
 */
public with sharing class JiraAPIService {
	private static final String NAMED_CREDENTIAL = 'callout:JiraAPI'; //https://martinmessina13.atlassian.net/rest/api/3/
	private static final String PROJECT_ENDPOINT = '/project';
	private static final String ISSUE_ENDPOINT = '/issue';

	/**
	 * Creates a project in Jira
	 * @param projectWrapper The project wrapper object containing all necessary data
	 * @return String The Jira project ID
	 *
	 * TODO: Implement this method to make a callout to Jira API to create a project
	 * Reminder: Extract and return the project ID from the response
	 */
	public static String createProject(JiraWrapper.ProjectWrapper projectWrapper) {
		String endpoint = NAMED_CREDENTIAL + PROJECT_ENDPOINT;
		String body = JSON.serialize(projectWrapper);
		HttpResponse response = makePostCallout(endpoint, body);
		if (response.getStatusCode() == 201) {
			JiraWrapper.ResponseWrapper responseWrapper = parseResponse(response.getBody());
			return responseWrapper.id; // Return project ID
		}
		throw new JiraException(response.getStatus());
	}

	/**
	 * Creates an issue in Jira
	 * @param issueWrapper The issue wrapper object containing all necessary data
	 * @return String The Jira issue key
	 *
	 * TODO: Implement this method to make a callout to Jira API to create an issue
	 * Reminder: Extract and return the issue key from the response
	 */
	public static String createIssue(JiraWrapper.IssueWrapper issueWrapper) {
		// Your implementation goes here
		String endpoint = NAMED_CREDENTIAL + ISSUE_ENDPOINT;
		String body = JSON.serialize(issueWrapper);
		HttpResponse response = makePostCallout(endpoint, body);
		if (response.getStatusCode() == 201) {
			JiraWrapper.ResponseWrapper responseWrapper = parseResponse(response.getBody());
			return responseWrapper.key; // Return issue key
		}
		throw new JiraException(formatErrors(response));
	}

	/**
	 * Helper method to make the HTTP POST callout
	 * @param endpoint The full URL with parameters
	 * @return HttpResponse The HTTP response
	 */
	private static HttpResponse makePostCallout(String endpoint, String body) {
		// - Create and configure HTTP request
		HttpRequest request = new HttpRequest();
		request.setEndpoint(endpoint);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody(body);
		// - Make the callout
		Http http = new Http();
		HttpResponse response = http.send(request);
		return response;
	}

	/**
	 * Helper method to parse the JSON response
	 * @param jsonResponse The JSON response string
	 * @return JiraWrapper.ResponseWrapper The parsed response object
	 */
	private static JiraWrapper.ResponseWrapper parseResponse(String jsonResponse) {
		// - Deserialize JSON to JiraWrapper.ResponseWrapper
		try {
			return (JiraWrapper.ResponseWrapper) JSON.deserialize(
				jsonResponse,
				JiraWrapper.ResponseWrapper.class
			);
		} catch (Exception e) {
			// - Handle exceptions
			CustomLogger.insertLog(e, 'ERROR');
			throw new JiraException(e);
		}
	}

	/**
	 * Helper method to format errors coming in the endpoints response
	 * @param HttpResponse The HTTP response
	 * @return String String formatted errors
	 */
	private static String formatErrors(HttpResponse response) {
		JiraWrapper.ErrorWrapper error = (JiraWrapper.ErrorWrapper) JSON.deserialize(
			response.getBody(),
			JiraWrapper.ErrorWrapper.class
		);
		String errorMessage = response.getStatus() + '. ';
		if (!error.errorMessages.isEmpty()) {
			errorMessage += 'Error Messages: ' + error.errorMessages.toString() + '. ';
		}
		if (error.errors.size() > 0) {
			errorMessage += 'Errors detail: ' + error.errors + '. ';
		}
		return errorMessage;
	}

	public class JiraException extends Exception {
	}
}
