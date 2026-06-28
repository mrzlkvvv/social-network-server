package main

import (
	"encoding/json"
	"log"
	"net/http"

	_ "github.com/mrzlkvvv/social-network-server/docs"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	httpSwagger "github.com/swaggo/http-swagger"
)

type Response struct {
	Message string `json:"message"`
}

// @title			Social Network Server
// @version			0.1
// @description		Hello world на chi+swag
// @host			localhost:8080
// @BasePath		/
func main() {
	r := chi.NewRouter()

	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte("Hello, World!"))
	})

	// Подключаем Swagger UI
	r.Get("/swagger/*", httpSwagger.Handler(
		httpSwagger.URL("http://localhost:8080/swagger/doc.json"),
	))

	log.Println("Server started on http://localhost:8080")
	log.Println("Swagger UI: http://localhost:8080/swagger/index.html")

	_ = http.ListenAndServe(":8080", r)
}

// HelloHandler	godoc
// @Summary		Приветствие
// @Description	Просто возвращает Hello, World!
// @Tags		default
// @Produce		json
// @Success		200	{object} Response
// @Router		/ [get]
func HelloHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(Response{Message: "Hello, World!"})
}
