// Create a project wrapper
JiraWrapper.ProjectWrapper projectWrapper = new JiraWrapper.ProjectWrapper(
    'Test Project 4',
    'TP4',
    'Test Description'
);

// Call the method to test
String projectId = JiraAPIService.createProject(projectWrapper);

System.debug('projectId: ' + projectId);