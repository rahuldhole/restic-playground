package main

import (
	"fmt"
	"os"
	"restica/internal/restic"
	"restica/internal/ui"

	tea "github.com/charmbracelet/bubbletea"
)

func main() {
	// Initialize restic client with environment variables or defaults
	repo := os.Getenv("RESTIC_REPOSITORY")
	if repo == "" {
		repo = "/repo" // Default for the playground
	}
	password := os.Getenv("RESTIC_PASSWORD")
	if password == "" {
		password = "playground-password"
	}

	client := restic.NewClient(repo, password)

	// In a real app, we might want to pass more env vars like AWS keys
	if awsKey := os.Getenv("AWS_ACCESS_KEY_ID"); awsKey != "" {
		client.AddEnv("AWS_ACCESS_KEY_ID", awsKey)
	}
	if awsSecret := os.Getenv("AWS_SECRET_ACCESS_KEY"); awsSecret != "" {
		client.AddEnv("AWS_SECRET_ACCESS_KEY", awsSecret)
	}

	m := ui.NewMainModel(client)
	p := tea.NewProgram(m, tea.WithAltScreen())

	if _, err := p.Run(); err != nil {
		fmt.Printf("Alas, there's been an error: %v", err)
		os.Exit(1)
	}
}
