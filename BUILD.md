# Building Dirt Claude Dojo

## Prerequisites
- Go 1.21 or later
- Git

## Quick Build
```bash
# Install Go dependencies
go mod tidy

# Build the CLI tool
go build -o dojo cmd/main.go

# Make executable and test
chmod +x dojo
./dojo --help
```

## Installation
```bash
# Build and install to system
go build -o dojo cmd/main.go
sudo mv dojo /usr/local/bin/

# Or install locally
mkdir -p ~/bin
go build -o ~/bin/dojo cmd/main.go
export PATH="$HOME/bin:$PATH"
```

## Development
```bash
# Run without building
go run cmd/main.go init

# Run tests (when we add them)
go test ./...

# Build for different platforms
GOOS=linux GOARCH=amd64 go build -o dojo-linux cmd/main.go
GOOS=darwin GOARCH=amd64 go build -o dojo-mac cmd/main.go
GOOS=windows GOARCH=amd64 go build -o dojo.exe cmd/main.go
```

## First Run
```bash
# Initialize your dojo
./dojo init

# Start a learning session  
./dojo start

# Begin first lesson
./dojo learn cli-basics
```

## Project Structure
```
dirt-claude-dojo/
├── cmd/main.go              # CLI tool source
├── go.mod                   # Go dependencies
├── dojo                     # Built binary
├── .dojo/                   # User data (created by init)
├── foundations/             # Lesson content
├── practice/               # Workspace for exercises
└── summaries/              # Auto-generated learning summaries
```