package ui

import (
	"fmt"
	"restica/internal/restic"
	"restica/internal/ui/styles"

	"github.com/charmbracelet/bubbles/list"
	"github.com/charmbracelet/bubbles/spinner"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

const Manifesto = `RESTICA MANIFESTO
-----------------
1. Simplicity over Complexity: Restic is powerful, Restica makes it accessible.
2. S3 Native: Built exclusively for the modern cloud storage era.
3. Reliability: Your data is your most valuable asset; we treat it that way.
4. Transparency: No magic, just a clean wrapper around proven technology.`

type state int

const (
	stateDashboard state = iota
	stateSnapshots
	stateRestore
	stateBackup
	stateStats
	stateMaintenance
	stateSettings
)

type item struct {
	title, desc string
	state       state
}

func (i item) Title() string       { return i.title }
func (i item) Description() string { return i.desc }
func (i item) FilterValue() string { return i.title }

type snapshotMsg []restic.Snapshot
type errorMsg error

func (m MainModel) fetchSnapshots() tea.Cmd {
	return func() tea.Msg {
		snapshots, err := m.client.Snapshots()
		if err != nil {
			return errorMsg(err)
		}
		return snapshotMsg(snapshots)
	}
}

type MainModel struct {
	list           list.Model
	state          state
	client         *restic.Client
	loading        bool
	spinner        spinner.Model
	width          int
	height         int
	err            error
	snapshots      []restic.Snapshot
	input          textinput.Model
	backupPath     string
	restorePath    string
	selectedSnapID string
}

func NewMainModel(client *restic.Client) MainModel {
	items := []list.Item{
		item{title: "Dashboard", desc: "Overview of your repository", state: stateDashboard},
		item{title: "Snapshots", desc: "Browse and manage backups", state: stateSnapshots},
		item{title: "Restore", desc: "Recover data from snapshots", state: stateRestore},
		item{title: "Backup", desc: "Create a new backup", state: stateBackup},
		item{title: "Stats", desc: "View repository statistics", state: stateStats},
		item{title: "Maintenance", desc: "Check and prune repository", state: stateMaintenance},
		item{title: "Settings", desc: "Configure restic environment", state: stateSettings},
	}

	l := list.New(items, list.NewDefaultDelegate(), 20, 10)
	l.Title = "RESTICA"
	l.SetShowStatusBar(false)
	l.SetFilteringEnabled(false)
	l.Styles.Title = styles.TitleStyle

	s := spinner.New()
	s.Spinner = spinner.Dot
	s.Style = lipgloss.NewStyle().Foreground(styles.PrimaryColor)

	ti := textinput.New()
	ti.Placeholder = "/path/to/backup"

	return MainModel{
		list:       l,
		state:      stateDashboard,
		client:     client,
		spinner:    s,
		input:      ti,
		backupPath: "./sample-data",
	}
}

func (m MainModel) Init() tea.Cmd {
	return tea.Batch(m.spinner.Tick, m.fetchSnapshots())
}

type backupMsg string

func (m MainModel) runBackup() tea.Cmd {
	return func() tea.Msg {
		output, err := m.client.Backup([]string{"./sample-data"})
		if err != nil {
			return errorMsg(err)
		}
		return backupMsg(output)
	}
}

type statsMsg string

func (m MainModel) fetchStats() tea.Cmd {
	return func() tea.Msg {
		output, err := m.client.Stats()
		if err != nil {
			return errorMsg(err)
		}
		return statsMsg(output)
	}
}

func (m MainModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd

	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			if !m.input.Focused() {
				return m, tea.Quit
			}
		case "enter":
			if m.state == stateBackup && m.input.Focused() {
				m.backupPath = m.input.Value()
				m.input.Blur()
				m.loading = true
				return m, m.runBackup()
			}
			if m.state == stateRestore && m.input.Focused() {
				m.restorePath = m.input.Value()
				m.input.Blur()
				m.loading = true
				return m, func() tea.Msg {
					output, err := m.client.Restore(m.selectedSnapID, m.restorePath)
					if err != nil {
						return errorMsg(err)
					}
					return backupMsg(output)
				}
			}
			if i, ok := m.list.SelectedItem().(item); ok {
				m.state = i.state
				m.err = nil
				if m.state == stateSnapshots {
					m.loading = true
					return m, m.fetchSnapshots()
				}
				if m.state == stateBackup {
					m.input.SetValue(m.backupPath)
					m.input.Focus()
				}
				if m.state == stateRestore {
					if len(m.snapshots) > 0 {
						m.selectedSnapID = m.snapshots[0].ID
						m.input.SetValue("/tmp/restore")
						m.input.Focus()
					}
				}
				if m.state == stateStats {
					m.loading = true
					return m, m.fetchStats()
				}
			}
		case "esc":
			m.state = stateDashboard
			m.err = nil
			m.input.Blur()
		case "r":
			if m.state == stateSnapshots {
				m.loading = true
				return m, m.fetchSnapshots()
			}
			if m.state == stateStats {
				m.loading = true
				return m, m.fetchStats()
			}
		case "c":
			if m.state == stateMaintenance {
				m.loading = true
				return m, func() tea.Msg {
					output, err := m.client.Check()
					if err != nil {
						return errorMsg(err)
					}
					return backupMsg(output)
				}
			}
		}

	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		m.list.SetSize(20, m.height-4)

	case snapshotMsg:
		m.snapshots = msg
		m.loading = false
		return m, nil

	case backupMsg:
		m.loading = false
		return m, m.fetchSnapshots()

	case statsMsg:
		m.loading = false
		return m, nil

	case errorMsg:
		m.err = msg
		m.loading = false
		return m, nil

	case spinner.TickMsg:
		m.spinner, cmd = m.spinner.Update(msg)
		return m, cmd
	}

	if m.input.Focused() {
		m.input, cmd = m.input.Update(msg)
		return m, cmd
	}

	m.list, cmd = m.list.Update(msg)
	return m, cmd
}

func (m MainModel) statsView() string {
	return styles.HeaderStyle.Render("Repository Stats") + "\n\n" +
		"Fetching detailed statistics...\n\n" +
		"Feature coming soon: Visual charts and size analysis."
}

func (m MainModel) restoreView() string {
	s := styles.HeaderStyle.Render("Restore from S3") + "\n\n"
	if len(m.snapshots) == 0 {
		return s + "No snapshots available to restore. Go to 'Snapshots' tab first."
	}
	s += fmt.Sprintf("Snapshot: %s\n\n", m.selectedSnapID)
	s += "Restore Destination:\n"
	s += m.input.View() + "\n\n"
	s += "Press Enter to start restoration."
	return s
}

func (m MainModel) backupView() string {
	s := styles.HeaderStyle.Render("Run S3 Backup") + "\n\n"
	s += "Target Path:\n"
	s += m.input.View() + "\n\n"
	s += "Press Enter to start backup to S3."
	return s
}

func (m MainModel) View() string {
	if m.width == 0 || m.height == 0 {
		return "Initializing Restica..."
	}

	sidebar := m.list.View()

	var content string
	if m.err != nil {
		content = styles.HeaderStyle.Render("Error") + "\n\n" +
			lipgloss.NewStyle().Foreground(styles.ErrorColor).Render(m.err.Error()) + "\n\n" +
			"Press 'r' to retry."
	} else if m.loading {
		content = m.spinner.View() + " Loading..."
	} else {
		switch m.state {
		case stateDashboard:
			content = m.dashboardView()
		case stateSnapshots:
			content = m.snapshotsView()
		case stateRestore:
			content = m.restoreView()
		case stateBackup:
			content = m.backupView()
		case stateStats:
			content = m.statsView()
		case stateMaintenance:
			content = m.maintenanceView()
		case stateSettings:
			content = m.settingsView()
		}
	}

	mainView := lipgloss.JoinHorizontal(
		lipgloss.Top,
		styles.SidebarStyle.Height(m.height-2).Render(sidebar),
		styles.ContentStyle.Width(m.width-25).Height(m.height-2).Render(content),
	)

	return styles.MainStyle.Render(mainView)
}

func (m MainModel) dashboardView() string {
	s := styles.HeaderStyle.Render("Welcome to Restica") + "\n\n"
	s += styles.InfoBoxStyle.Render(
		"Repository: " + m.client.Repository + "\n" +
			"Snapshots: " + fmt.Sprintf("%d", len(m.snapshots)) + "\n" +
			"Status: Connected",
	) + "\n\n"

	manifestoStyle := lipgloss.NewStyle().
		Foreground(styles.AccentColor).
		Width(m.width - 30).
		Padding(1, 2).
		Border(lipgloss.DoubleBorder(), false, false, false, true).
		BorderForeground(styles.PrimaryColor)

	s += manifestoStyle.Render(Manifesto) + "\n\n"
	s += "Use the arrow keys to navigate and Enter to select.\n"
	s += "Press 'q' to exit."
	return s
}

func (m MainModel) snapshotsView() string {
	s := styles.HeaderStyle.Render("Snapshots") + "\n\n"

	if len(m.snapshots) == 0 {
		return s + "No snapshots found."
	}

	for _, snap := range m.snapshots {
		s += fmt.Sprintf("[%s] %s - %s\n",
			styles.SelectedStyle.Render(snap.ID[:8]),
			snap.Time.Format("2006-01-02 15:04:05"),
			snap.Paths[0],
		)
	}

	s += "\n\nPress 'r' to refresh."
	return s
}

func (m MainModel) maintenanceView() string {
	s := styles.HeaderStyle.Render("Repository Maintenance") + "\n\n"
	s += "Select an operation:\n\n"
	s += "1. [c] Run Consistency Check\n"
	s += "2. [p] Prune Unused Data (Coming Soon)\n\n"
	s += "Maintenance ensures your S3 backups are healthy."
	return s
}

func (m MainModel) settingsView() string {
	s := styles.HeaderStyle.Render("S3 Settings") + "\n\n"
	s += "RESTIC_REPOSITORY: " + m.client.Repository + "\n"
	s += "AWS_ACCESS_KEY_ID: " + "********" + "\n"
	s += "Status: S3 Exclusive Mode Active\n\n"
	s += "Restica is optimized for S3-compatible storage."
	return s
}
