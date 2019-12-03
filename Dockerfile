FROM golang:1.13-alpine as builder

WORKDIR /app
COPY . /app

RUN apk update && apk add git
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux GOPROXY=https://proxy.golang.org go build -o app main.go

FROM alpine:latest
RUN addgroup -S app && adduser -S app -G app
USER app
WORKDIR /app

COPY --from=builder /app/app .

EXPOSE 9201
ENTRYPOINT ["./app"]

