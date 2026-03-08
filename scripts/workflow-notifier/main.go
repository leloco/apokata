package main

import (
	"fmt"
	"os"
    xmpp "github.com/xmppo/go-xmpp"
)

func main() {
    data := getData()
    body := renderTemplate(getTemplate(), data)

    room := os.Getenv("XMPP_ROOM")
    if room == "" {
        fmt.Println("[Error] XMPP_ROOM environment variable is not set.")
        os.Exit(1)
    }

    options := xmpp.Options{
		Host:     os.Getenv("XMPP_SERVER"),
		User:     os.Getenv("XMPP_USER"),
		Password: os.Getenv("XMPP_PASSWORD"),
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
