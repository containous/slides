FROM golang:1.13

WORKDIR /app

COPY go.mod ./
COPY . .

RUN CGO_ENABLED=0 go build -o main .

EXPOSE 80

ENTRYPOINT ["./main"]