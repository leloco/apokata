package main

import (
	"fmt"
	"os"
    xmpp "github.com/xmppo/go-xmpp"
)

func main() {
    checkWorkflowEnv()
    data := getWorkflowData()
    body := renderTemplate(getTemplate(), data)

    room := os.Getenv("WORKFLOW_XMPP_ROOM")
    if room == "" {
        fmt.Println("[Error] WORKFLOW_XMPP_ROOM environment variable is not set.")
        os.Exit(1)
    }

    options := xmpp.Options{
		Host:     os.Getenv("WORKFLOW_XMPP_SERVER"),
		User:     os.Getenv("WORKFLOW_XMPP_USER"),
		Password: os.Getenv("WORKFLOW_XMPP_PASSWORD"),
        NoTLS: true,
        StartTLS: true,
	}

	client, err := options.NewClient()
	if err != nil {
		fmt.Printf("[Connection error] Unable to connect as new client: %v\n", err)
		os.Exit(1)
	}

	client.JoinMUC(room, "runner_alpha", 0, 0, nil)

    if err != nil {
      fmt.Printf("[Join error] Could not join MUC: %v\n", err)
    }

	client.Send(xmpp.Chat{Remote: room, Type: "groupchat", Text: body})

	fmt.Println("NOTIFICATION SENT.")
}
