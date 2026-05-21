package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

// APIResponse structures our JSON output
type APIResponse struct {
	Message   string    `json:"message"`
	Timestamp time.Time `json:"timestamp"`
	Status    string    `json:"status"`
}

// LoggerMiddleware logs incoming HTTP traffic
func LoggerMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("[%s] %s %s", r.Method, r.RemoteAddr, r.URL.Path)
		next.ServeHTTP(w, r)
	})
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	mux := http.NewServeMux()

	// 1. Health check endpoint
	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	// 2. Structured JSON API endpoint
	mux.HandleFunc("/api/v1/data", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		response := APIResponse{
			Message:   "Hello from a complex multi-stage Go server deployed natively!",
			Timestamp: time.Now(),
			Status:    "success",
		}
		json.NewEncoder(w).Encode(response)
	})

	// Wrap our router with the logging middleware
	loggedRouter := LoggerMiddleware(mux)

	log.Printf("Production Go server launching on port %s...", port)
	if err := http.ListenAndServe(":"+port, loggedRouter); err != nil {
		log.Fatalf("Server shutdown unexpectedly: %v", err)
	}
}
