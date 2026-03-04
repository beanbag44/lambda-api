FROM golang:1.24.1-alpine AS builder
WORKDIR /app
COPY go.* ./
RUN go mod download
COPY . ./
RUN GOOS=linux GOARCH=amd64 go build -o lambda-api .

FROM alpine:3.20.3
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/lambda-api /app/lambda-api
WORKDIR /app
EXPOSE 8080
EXPOSE 9100
CMD ["/app/lambda-api"]
