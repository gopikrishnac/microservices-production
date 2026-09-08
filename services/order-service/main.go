package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

type Order struct {
	ID        string  `json:"id"`
	ProductID int     `json:"product_id"`
	Quantity  int     `json:"quantity"`
	Total     float64 `json:"total"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{
		"status":  "healthy",
		"service": "order-service",
	})
}

func orderHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	sampleOrders := []Order{
		{ID: "ord-101", ProductID: 1, Quantity: 2, Total: 99.98},
		{ID: "ord-102", ProductID: 2, Quantity: 1, Total: 29.99},
	}
	json.NewEncoder(w).Encode(sampleOrders)
}

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/healthz", healthHandler)
	mux.HandleFunc("/api/orders", orderHandler)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Printf("Order service running on port %s\n", port)
	if err := http.ListenAndServe(":"+port, mux); err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}