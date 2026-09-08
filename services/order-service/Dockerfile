# Stage 1: Compile binary
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod ./
COPY main.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o order-service main.go

# Stage 2: Distroless minimal container
FROM alpine:3.19 AS runner
WORKDIR /app
COPY --from=builder /app/order-service .
USER 1000:1000
EXPOSE 8080
CMD ["./order-service"]