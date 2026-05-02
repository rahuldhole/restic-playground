package restic

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os/exec"
	"time"
)

// Snapshot represents a restic snapshot
type Snapshot struct {
	ID       string    `json:"id"`
	Time     time.Time `json:"time"`
	Tree     string    `json:"tree"`
	Paths    []string  `json:"paths"`
	Hostname string    `json:"hostname"`
	Username string    `json:"username"`
	Tags     []string  `json:"tags"`
}

// Client is a wrapper for the restic CLI
type Client struct {
	Repository string
	Password   string
	Env        []string
}

// NewClient creates a new restic client
func NewClient(repo, password string) *Client {
	return &Client{
		Repository: repo,
		Password:   password,
		Env: []string{
			fmt.Sprintf("RESTIC_REPOSITORY=%s", repo),
			fmt.Sprintf("RESTIC_PASSWORD=%s", password),
		},
	}
}

// AddEnv adds environment variables to the client
func (c *Client) AddEnv(key, value string) {
	c.Env = append(c.Env, fmt.Sprintf("%s=%s", key, value))
}

// Run executes a restic command and returns the output
func (c *Client) Run(args ...string) (string, error) {
	cmd := exec.Command("restic", args...)
	cmd.Env = append(cmd.Environ(), c.Env...)
	
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()
	if err != nil {
		return "", fmt.Errorf("restic error: %v, stderr: %s", err, stderr.String())
	}

	return stdout.String(), nil
}

// Snapshots returns a list of snapshots in JSON format
func (c *Client) Snapshots() ([]Snapshot, error) {
	output, err := c.Run("snapshots", "--json")
	if err != nil {
		return nil, err
	}

	var snapshots []Snapshot
	err = json.Unmarshal([]byte(output), &snapshots)
	if err != nil {
		return nil, fmt.Errorf("failed to parse snapshots: %v", err)
	}

	return snapshots, nil
}

// Backup performs a backup of the specified paths
func (c *Client) Backup(paths []string) (string, error) {
	args := append([]string{"backup"}, paths...)
	return c.Run(args...)
}

// Stats returns statistics about the repository
func (c *Client) Stats() (string, error) {
	return c.Run("stats")
}
