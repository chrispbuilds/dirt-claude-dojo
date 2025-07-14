package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/spf13/cobra"
)

const (
	DojoDir     = ".dojo"
	EventsDir   = ".dojo/events"
	ProgressFile = ".dojo/progress.json"
	ClaudeFile  = ".dojo/claude-integration.json"
)

// Progress tracks user learning progress
type Progress struct {
	User struct {
		Name         string    `json:"name"`
		StartDate    string    `json:"start_date"`
		CurrentLevel string    `json:"current_level"`
		TotalSessions int      `json:"total_sessions"`
		StreakDays   int       `json:"streak_days"`
	} `json:"user"`
	Foundations map[string]struct {
		Status           string `json:"status"`
		LessonsCompleted int    `json:"lessons_completed"`
		TotalLessons     int    `json:"total_lessons"`
		MasteryScore     int    `json:"mastery_score"`
	} `json:"foundations"`
	Achievements []string `json:"achievements"`
	LastSession  *string  `json:"last_session"`
	LearningStyle struct {
		PreferredPace  string   `json:"preferred_pace"`
		StruggleAreas  []string `json:"struggle_areas"`
		StrengthAreas  []string `json:"strength_areas"`
	} `json:"learning_style"`
}

// ClaudeIntegration manages Claude Code communication
type ClaudeIntegration struct {
	Session struct {
		Active        bool    `json:"active"`
		StartTime     *string `json:"start_time"`
		CurrentLesson *string `json:"current_lesson"`
		CurrentTopic  *string `json:"current_topic"`
		LearningMode  string  `json:"learning_mode"`
	} `json:"session"`
	UserState struct {
		StrugglingWith       *string `json:"struggling_with"`
		LastError           *string `json:"last_error"`
		ConsecutiveFailures  int     `json:"consecutive_failures"`
		NeedsEncouragement   bool    `json:"needs_encouragement"`
		AskForHelpCount      int     `json:"ask_for_help_count"`
	} `json:"user_state"`
	ClaudeBehavior struct {
		TeachingStyle         string  `json:"teaching_style"`
		InterventionThreshold int     `json:"intervention_threshold"`
		LastHintTime         *string `json:"last_hint_time"`
		HintLevel            int     `json:"hint_level"`
	} `json:"claude_behavior"`
	LessonContext struct {
		Topic        *string  `json:"topic"`
		Objective    *string  `json:"objective"`
		CurrentStep  int      `json:"current_step"`
		TotalSteps   int      `json:"total_steps"`
		KeyConcepts  []string `json:"key_concepts"`
	} `json:"lesson_context"`
	EventLog []map[string]interface{} `json:"event_log"`
}

var rootCmd = &cobra.Command{
	Use:   "dojo",
	Short: "Dirt Claude Dojo - From dirt claude poor to 10x developer",
	Long: `🥷 Dirt Claude Dojo

Master CLI fundamentals through deliberate practice with LLM partnership.
Learn to think with Claude, not copy from Claude.

Core principles:
- NO_COPY_PASTE: Build muscle memory through typing
- LEARNING_BY_BUILDING: Curriculum evolves as you progress  
- SOCRATIC_METHOD: Claude guides, never provides direct answers
- PROGRESSIVE_DISCLOSURE: Earn your way to advanced features`,
}

var initCmd = &cobra.Command{
	Use:   "init",
	Short: "Initialize your dojo training environment",
	Long: `Sets up your personal development dojo with:
- Progress tracking system
- Claude Code integration  
- Learning environment structure
- Your first foundational lesson`,
	Run: func(cmd *cobra.Command, args []string) {
		initializeDojo()
	},
}

var startCmd = &cobra.Command{
	Use:   "start",
	Short: "Begin daily training session with Claude monitoring",
	Long: `Starts a monitored learning session where Claude Code will:
- Track your progress and struggles
- Provide socratic guidance when you're stuck
- Prevent destructive commands in learning mode
- Celebrate your wins and encourage persistence`,
	Run: func(cmd *cobra.Command, args []string) {
		startSession()
	},
}

var learnCmd = &cobra.Command{
	Use:   "learn [topic]",
	Short: "Start learning a specific topic with context",
	Long: `Begin a structured lesson on a CLI topic.
Claude will monitor your progress and provide guidance.

Available topics will unlock as you progress:
- cli-basics: Terminal navigation and file operations
- version-control: Git fundamentals and workflows  
- scripting: Bash automation and best practices`,
	Args: cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		startLesson(args[0])
	},
}

func main() {
	rootCmd.AddCommand(initCmd, startCmd, learnCmd)
	
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func initializeDojo() {
	fmt.Println("🥷 Initializing Dirt Claude Dojo...")
	
	// Create directory structure
	dirs := []string{DojoDir, EventsDir, "foundations", "practice", "summaries"}
	for _, dir := range dirs {
		if err := os.MkdirAll(dir, 0755); err != nil {
			log.Fatalf("Failed to create directory %s: %v", dir, err)
		}
	}
	
	// Check if already initialized
	if _, err := os.Stat(ProgressFile); err == nil {
		fmt.Println("🎯 Dojo already initialized! Use 'dojo start' to begin training.")
		return
	}
	
	// Get user info
	fmt.Print("Enter your name (or nickname): ")
	var name string
	fmt.Scanln(&name)
	
	// Initialize progress file
	progress := Progress{}
	progress.User.Name = name
	progress.User.StartDate = time.Now().Format("2006-01-02")
	progress.User.CurrentLevel = "dirt_claude"
	
	// Initialize foundations
	progress.Foundations = make(map[string]struct {
		Status           string `json:"status"`
		LessonsCompleted int    `json:"lessons_completed"`
		TotalLessons     int    `json:"total_lessons"`
		MasteryScore     int    `json:"mastery_score"`
	})
	
	progress.Foundations["cli_basics"] = struct {
		Status           string `json:"status"`
		LessonsCompleted int    `json:"lessons_completed"`
		TotalLessons     int    `json:"total_lessons"`
		MasteryScore     int    `json:"mastery_score"`
	}{
		Status:           "available",
		LessonsCompleted: 0,
		TotalLessons:     12,
		MasteryScore:     0,
	}
	
	progress.Foundations["version_control"] = struct {
		Status           string `json:"status"`
		LessonsCompleted int    `json:"lessons_completed"`
		TotalLessons     int    `json:"total_lessons"`
		MasteryScore     int    `json:"mastery_score"`
	}{
		Status:           "locked",
		LessonsCompleted: 0,
		TotalLessons:     8,
		MasteryScore:     0,
	}
	
	progress.Foundations["scripting"] = struct {
		Status           string `json:"status"`
		LessonsCompleted int    `json:"lessons_completed"`
		TotalLessons     int    `json:"total_lessons"`
		MasteryScore     int    `json:"mastery_score"`
	}{
		Status:           "locked",
		LessonsCompleted: 0,
		TotalLessons:     15,
		MasteryScore:     0,
	}
	
	saveProgress(progress)
	
	fmt.Printf("🎉 Welcome to the dojo, %s!\n", name)
	fmt.Println("📚 Your CLI mastery journey begins now.")
	fmt.Println("💪 Remember: No copy-paste, only deliberate practice.")
	fmt.Println("\n🚀 Ready to start? Run: dojo learn cli-basics")
}

func startSession() {
	// Load current progress
	progress, err := loadProgress()
	if err != nil {
		fmt.Println("❌ Dojo not initialized. Run 'dojo init' first.")
		return
	}
	
	// Update session info
	claude := ClaudeIntegration{}
	claude.Session.Active = true
	now := time.Now().Format(time.RFC3339)
	claude.Session.StartTime = &now
	claude.Session.LearningMode = "practice"
	claude.ClaudeBehavior.TeachingStyle = "socratic"
	claude.ClaudeBehavior.InterventionThreshold = 3
	claude.ClaudeBehavior.HintLevel = 1
	
	saveClaudeIntegration(claude)
	
	// Update user stats
	progress.User.TotalSessions++
	saveProgress(progress)
	
	// Create session event for Claude monitoring
	event := map[string]interface{}{
		"timestamp": time.Now().Format(time.RFC3339),
		"type":      "session_start",
		"user":      progress.User.Name,
		"level":     progress.User.CurrentLevel,
		"message":   "User started training session",
	}
	
	logEvent(event)
	
	fmt.Printf("🥷 Training session started for %s\n", progress.User.Name)
	fmt.Printf("📊 Current level: %s\n", progress.User.CurrentLevel)
	fmt.Printf("🔄 Session #%d\n", progress.User.TotalSessions)
	fmt.Println("👁️  Claude Code monitoring enabled")
	fmt.Println("\n💡 Claude will provide guidance when you struggle, but won't give direct answers.")
	fmt.Println("🎯 Use 'dojo learn <topic>' to begin a lesson.")
}

func startLesson(topic string) {
	progress, err := loadProgress()
	if err != nil {
		fmt.Println("❌ Dojo not initialized. Run 'dojo init' first.")
		return
	}
	
	// Check if topic is available
	foundation, exists := progress.Foundations[topic]
	if !exists {
		fmt.Printf("❌ Topic '%s' not found.\n", topic)
		fmt.Println("Available topics: cli-basics")
		return
	}
	
	if foundation.Status == "locked" {
		fmt.Printf("🔒 Topic '%s' is locked. Complete prerequisites first.\n", topic)
		return
	}
	
	// Update Claude integration
	claude, _ := loadClaudeIntegration()
	claude.Session.CurrentTopic = &topic
	claude.LessonContext.Topic = &topic
	
	// Set lesson objectives based on topic
	switch topic {
	case "cli-basics":
		objective := "Master terminal navigation, file operations, and basic commands"
		claude.LessonContext.Objective = &objective
		claude.LessonContext.TotalSteps = 12
		claude.LessonContext.KeyConcepts = []string{"pwd", "ls", "cd", "mkdir", "touch", "cp", "mv", "rm"}
	}
	
	saveClaudeIntegration(claude)
	
	// Log lesson start event
	event := map[string]interface{}{
		"timestamp": time.Now().Format(time.RFC3339),
		"type":      "lesson_start",
		"topic":     topic,
		"user":      progress.User.Name,
		"message":   fmt.Sprintf("Started lesson: %s", topic),
	}
	
	logEvent(event)
	
	fmt.Printf("📚 Starting lesson: %s\n", topic)
	fmt.Printf("🎯 Objective: %s\n", *claude.LessonContext.Objective)
	fmt.Printf("📊 Progress: %d/%d lessons completed\n", foundation.LessonsCompleted, foundation.TotalLessons)
	fmt.Println("\n🥷 Begin your practice. Claude is watching and ready to guide you.")
	fmt.Println("💡 Remember: Type everything manually. No copy-paste!")
}

func loadProgress() (Progress, error) {
	var progress Progress
	data, err := os.ReadFile(ProgressFile)
	if err != nil {
		return progress, err
	}
	err = json.Unmarshal(data, &progress)
	return progress, err
}

func saveProgress(progress Progress) error {
	data, err := json.MarshalIndent(progress, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(ProgressFile, data, 0644)
}

func loadClaudeIntegration() (ClaudeIntegration, error) {
	var claude ClaudeIntegration
	data, err := os.ReadFile(ClaudeFile)
	if err != nil {
		return claude, err
	}
	err = json.Unmarshal(data, &claude)
	return claude, err
}

func saveClaudeIntegration(claude ClaudeIntegration) error {
	data, err := json.MarshalIndent(claude, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(ClaudeFile, data, 0644)
}

func logEvent(event map[string]interface{}) {
	// Create event file with timestamp
	timestamp := time.Now().Format("20060102-150405")
	filename := filepath.Join(EventsDir, fmt.Sprintf("event-%s.json", timestamp))
	
	data, err := json.MarshalIndent(event, "", "  ")
	if err != nil {
		log.Printf("Failed to marshal event: %v", err)
		return
	}
	
	if err := os.WriteFile(filename, data, 0644); err != nil {
		log.Printf("Failed to write event file: %v", err)
	}
}