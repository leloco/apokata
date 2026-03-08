package main

import (
	"bytes"
	"fmt"
	"os"
	"strings"
	"text/template"
)

type MessageData struct {
	Status  string
	Project string
	Commit  string
	Branch  string
	Author  string
	JobURL  string
}

func getProjectName() string {
	fullRepo := os.Getenv("GITHUB_REPOSITORY")
	parts := strings.Split(fullRepo, "/")

	if len(parts) > 1 {
		return parts[1]
	}
	return fullRepo
}

func getData() MessageData {
	workflowStatus := os.Getenv("STATUS")
	status := strings.ToUpper(workflowStatus)

	data := MessageData{
		Status:  status,
		Project: getProjectName(),
		Commit:  os.Getenv("GITHUB_SHA")[:7],
		Branch:  os.Getenv("GITHUB_REF_NAME"),
		Author:  os.Getenv("GITHUB_ACTOR"),
	}

	if status != "SUCCESS" {
		data.JobURL = fmt.Sprintf("%s/%s/actions/runs/%s",
			os.Getenv("GITHUB_SERVER_URL"),
			os.Getenv("GITHUB_REPOSITORY"),
			os.Getenv("GITHUB_RUN_ID"),
		)
	}
	return data
}

func getTemplate() string {
	return `
{{if eq .Status "SUCCESS"}}✅{{else}}❌{{end}} [[ {{.Status}} ]] Repo: {{.Project}}
------------------------------------
Commit:  {{.Commit}} on ({{.Branch}})
Author:  {{.Author}}
{{if .JobURL}}
Details: {{.JobURL}}
{{end}}
------------------------------------`
}

func renderTemplate(templ string, data MessageData) string {
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
