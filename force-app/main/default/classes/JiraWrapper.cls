/**
 * Wrapper classes for Jira entities (Project and Issue)
 */
public class JiraWrapper {
	private static final String LEAD_ACCOUNT_ID = '70121:d6dfd1f0-16cd-4155-aed4-e1b4f6be5c35';
	private static final String PROJECT_TEMPLATE_KEY = 'com.pyxis.greenhopper.jira:basic-software-development-template';

	/**
	 * Wrapper for Jira Project
	 */
	public class ProjectWrapper {
		public String name;
		public String key;
		public String description;
		public String leadAccountId;
		public String projectTemplateKey;

		/**
		 * Constructor for ProjectWrapper
		 */
		public ProjectWrapper(String name, String key, String description) {
			this.name = name;
			this.key = key;
			this.description = description;
			this.leadAccountId = LEAD_ACCOUNT_ID;
			this.projectTemplateKey = PROJECT_TEMPLATE_KEY;
		}
	}

	/**
	 * Wrapper for Jira Issue
	 */
	public class IssueWrapper {

		public Fields fields;

		/**
		 * Constructor for IssueWrapper
		 */
		public IssueWrapper(
			String projectKey,
			String summary,
			String description,
			String issueType
		) {
			this.fields = new Fields();

			JiraWrapper.Project project = new JiraWrapper.Project();
			project.key = projectKey;

			JiraWrapper.Description descriptionWrapper = new JiraWrapper.Description();
			descriptionWrapper.type = 'doc';
			descriptionWrapper.version = 1;

			JiraWrapper.EmbeddedContent embeddedContent = new JiraWrapper.EmbeddedContent();
			embeddedContent.type = 'text';
			embeddedContent.text = description;

			List<JiraWrapper.EmbeddedContent> embeddedContents = new List<JiraWrapper.EmbeddedContent>{embeddedContent};

			JiraWrapper.Content content = new JiraWrapper.Content();
			content.content = embeddedContents;
			content.type = 'paragraph';
			
			List<JiraWrapper.Content> contents = new List<JiraWrapper.Content>{content};
			descriptionWrapper.content = contents;

			this.fields.project = project;
			this.fields.description = descriptionWrapper;
			this.fields.summary = summary;
			// this.fields.description = (JiraWrapper.Description)JSON.deserializeStrict(description, JiraWrapper.Description.class);
			String issueTypeName = (String.isNotBlank(issueType)) ? issueType : 'Task';
			JiraWrapper.Issuetype issuetypeWrapper = new JiraWrapper.Issuetype();
			issuetypeWrapper.name = issueTypeName;
			this.fields.issuetype = issuetypeWrapper;
		}

		/**
		 * Convert IssueWrapper to a Map for serialization
		 *
		 * TODO: Implement this method to create a Map that represents
		 * the JSON payload needed for the Jira API. The Map should contain:
		 * - fields object with project information (key)
		 * - issuetype object with the issue type name
		 * - summary field
		 * - description field (formatted using formatDescription method)
		 * - Example:
		 */
		public Map<String, Object> generateIssuePayloadMap() {
			// Your implementation goes here
			return null;
		}

		/**
		 * Format description as per Jira Cloud API requirements
		 *
		 * TODO: Implement this method to format the description text
		 * according to Jira Cloud API requirements.
		 * - Create a Map with type="doc" and version=1
		 * - Add content array with paragraph object
		 * - Add text object inside paragraph content with the description
		 * - Example:
		 *   {
		 *     "description": {
		 *       "type": "doc",
		 *       "version": 1,
		 *       "content": [
		 *         {
		 *           "type": "paragraph",
		 *           "content": [
		 *             {
		 *               "type": "text",
		 *               "text": "Order entry fails when selecting supplier."
		 *             }
		 *           ]
		 *         }
		 *       ]
		 *     }
		 *   }
		 */
		private Map<String, Object> formatDescription(String descText) {
			// Your implementation goes here
			return null;
		}
	}

	/**
	 * Wrapper for Jira Issue's fields
	 */
	class Fields{
		public Description description;
		public Project project;
		public String summary;
		public Issuetype issuetype;
	}

	class Project{
		public String key;
	}

	class Issuetype{
		public String name;
	}

	class Description {
		public Content[] content;
		public String type;	//doc
		public Integer version;	//1
	}

	class EmbeddedContent {
		public String text;	
		public String type;	//text
	}

	class Content {
		public EmbeddedContent[] content;
		public String type;	//text
	}

	public class ResponseWrapper{
		/*
		* Wrapper for Jira responses
		*/
		public String id;
		public String key;
		public String self;
	}

	public class ErrorWrapper{
		public List<String> errorMessages;
		public Map<String, String> errors;
	}
}
