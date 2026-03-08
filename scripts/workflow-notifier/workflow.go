package main

import (
	"bytes"
	"fmt"
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
	fullRepo := os.Getenv("GITHUB_REPOSITORY")
	parts := strings.Split(fullRepo, "/")

	if len(parts) > 1 {
		return parts[1]
	}
	return fullRepo
}

func computeDuration() string {
	durationStr := "unknown"
	startEnv := os.Getenv("WORKFLOW_START_TIME")
	if startEnv != "" {
		startUnix, err := strconv.ParseInt(startEnv, 10, 64)
		if err == nil {
			startTime := time.Unix(startUnix, 0)
			elapsed := time.Since(startTime)
			return fmt.Sprintf("%dm %ds", int(elapsed.Minutes()), int(elapsed.Seconds())%60)
		}
	}
    return durationStr;
}

func getURL() string {
    return fmt.Sprintf("%s/%s/actions/runs/%s",
		os.Getenv("GITHUB_SERVER_URL"),
		os.Getenv("GITHUB_REPOSITORY"),
		os.Getenv("GITHUB_RUN_ID"),
    )
}

func getData() WorkflowData {
	workflowStatus := os.Getenv("STATUS")
	status := strings.ToUpper(workflowStatus)

	data := WorkflowData{
		Status:  status,
		Project: getProjectName(),
		Commit:  os.Getenv("SHA")[:7],
		Message:  os.Getenv("COMMIT_MSG"),
		Branch:  os.Getenv("BRANCH"),
		Actor:  os.Getenv("GITHUB_ACTOR"),
        Duration:     computeDuration(),
        URL:     getURL(),
	}

	return data
}

func getTemplate() string {
	return `
{{if eq .Status "SUCCESS"}}
✅ Worfklow succeeded.
Event: {{if eq .Branch "main"}} 🚀 Deployed on .Branch {{else}} 🤝 Ready to merge .Branch into main
{{else}}❌ Workflow failed.
Event: {{if eq .Branch "main"}} 💥 Deployment on .Branch has some errors. {{else}} ✋ Not ready to merge .Branch into main {{end}}
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
