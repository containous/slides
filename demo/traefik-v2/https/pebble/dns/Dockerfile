FROM golang:1.13-alpine

COPY ./ /root

RUN cd /root && go mod download

CMD cd /root && go run ./fakedns.go