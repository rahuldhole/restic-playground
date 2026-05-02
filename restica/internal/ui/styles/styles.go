package styles

import "github.com/charmbracelet/lipgloss"

var (
	// Colors
	PrimaryColor   = lipgloss.Color("#7D56F4")
	SecondaryColor = lipgloss.Color("#04B575")
	AccentColor    = lipgloss.Color("#EE6FF8")
	BgColor        = lipgloss.Color("#171717")
	FgColor        = lipgloss.Color("#EEEEEE")
	ErrorColor     = lipgloss.Color("#EF4444")
	WarningColor   = lipgloss.Color("#F59E0B")

	// Styles
	MainStyle = lipgloss.NewStyle().
			Padding(1, 2).
			Foreground(FgColor)

	HeaderStyle = lipgloss.NewStyle().
			Foreground(PrimaryColor).
			Bold(true).
			MarginBottom(1)

	TitleStyle = lipgloss.NewStyle().
			Background(PrimaryColor).
			Foreground(lipgloss.Color("#FFF")).
			Padding(0, 1).
			Bold(true)

	SidebarStyle = lipgloss.NewStyle().
			Border(lipgloss.NormalBorder(), false, true, false, false).
			BorderForeground(lipgloss.Color("#333")).
			Padding(1, 1).
			Width(20)

	ContentStyle = lipgloss.NewStyle().
			Padding(1, 2)

	StatusStyle = lipgloss.NewStyle().
			Foreground(SecondaryColor).
			Italic(true)

	SelectedStyle = lipgloss.NewStyle().
			Foreground(AccentColor).
			Bold(true)

	InfoBoxStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(PrimaryColor).
			Padding(1, 2).
			MarginBottom(1)
)
