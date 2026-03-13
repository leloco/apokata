package main

import (
	"bytes"
	"fmt"
    "log"
	"os"
	"strings"
	"text/template"
    "time"
    "strconv"
)

type WorkflowData struct {
	Status  string
	Project string
	Commit  string
	Message string
	Branch  string
	Actor  string
	Duration  string
	URL  string
}

func getProjectName() string {
    fullRepo := os.Getenv("WORKFLOW_GITHUB_REPOSITORY")
    parts := strings.Split(fullRepo, "/")

	if len(parts) > 1 {
		return parts[1]
	}

	return fullRepo
}

func computeDuration() string {
	durationStr := "unknown"
	startEnv := os.Getenv("WORKFLOW_START_TIME")
	startUnix, err := strconv.ParseInt(startEnv, 10, 64)
	if err == nil {
		startTime := time.Unix(startUnix, 0)
		elapsed := time.Since(startTime)
		return fmt.Sprintf("%dm %ds", int(elapsed.Minutes()), int(elapsed.Seconds())%60)
	}
    return durationStr;
}

func getURL() string {
    server := os.Getenv("WORKFLOW_GITHUB_SERVER_URL")
    repo := os.Getenv("WORKFLOW_GITHUB_REPOSITORY")
    runID := os.Getenv("WORKFLOW_GITHUB_RUN_ID")

    return fmt.Sprintf("%s/%s/actions/runs/%s", server, repo, runID)
}

func getWorkflowData() WorkflowData {
    workflowStatus := os.Getenv("WORKFLOW_STATUS")
	status := strings.ToUpper(workflowStatus)
    commit := os.Getenv("WORKFLOW_SHA")

    if len(commit) >= 7  {
        commit = commit[:7]
    }

    message := os.Getenv("WORKFLOW_COMMIT_MSG")
    branch := os.Getenv("WORKFLOW_BRANCH")
    actor := os.Getenv("WORKFLOW_GITHUB_ACTOR")

    data := WorkflowData{
		Status:  status,
		Project: getProjectName(),
		Commit:  commit,
		Message:  message,
		Branch:  branch,
		Actor:  actor,
        Duration: computeDuration(),
        URL: getURL(),
	}

	return data
}

func checkWorkflowEnv() {
    prefix := "WORKFLOW"

    for _, env := range os.Environ() {
        pair := strings.SplitN(env, "=", 2)
        key := pair[0]
        value := pair[1]

        if strings.HasPrefix(key, prefix) && strings.TrimSpace(value) == "" {
                log.Fatalf("ERROR: Workflow Environment variable %s is empty!", key)
        }
    }
}

func getTemplate() string {
	return `
{{if eq .Status "SUCCESS"}}✅ Workflow succeeded.
Event: {{if eq .Branch "main"}}🚀 Deployed on main{{else}}🤝 Ready to merge {{.Branch}} into main{{end}}
{{else}}❌ Workflow failed.
Event: {{if eq .Branch "main"}}💥 Deployment on main failed!{{else}}✋ Not ready to merge {{.Branch}} into main{{end}}
{{end}}
------------------------------------
Repo: {{.Project}}
Triggered by:  {{.Actor}}
Duration: {{.Duration}}
Commit:  {{.Commit}} on ({{.Branch}})
Message:  {{.Message}}

More details: {{.URL}}
------------------------------------`
}

func renderTemplate(templ string, data WorkflowData) string {
	tmpl, err := template.New("xmpp_msg").Parse(templ)
	if err != nil {
		panic(err)
	}

	var templateBuffer bytes.Buffer
	err = tmpl.Execute(&templateBuffer, data)
	if err != nil {
		panic(err)
	}

	return templateBuffer.String()
}
