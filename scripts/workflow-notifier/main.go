package main

import (
	"fmt"
	"os"
    "time"
    xmpp "github.com/xmppo/go-xmpp"
)

func main() {
    checkWorkflowEnv()
    data := getWorkflowData()
    body := renderTemplate(getTemplate(), data)

    room := os.Getenv("WORKFLOW_XMPP_ROOM")

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

	_, err = client.JoinMUC(room, "runner_alpha", 0, 0, nil)

    if err != nil {
      fmt.Printf("[Join error] Could not join MUC: %v\n", err)
    }

    time.Sleep(500 * time.Millisecond)

	_, err = client.Send(xmpp.Chat{Remote: room, Type: "groupchat", Text: body})

    if err != nil {
      fmt.Printf("[Sending error]: Unable to send message: %s", err)
      return
    }
    fmt.Println("NOTIFICATION SENT.")
}
