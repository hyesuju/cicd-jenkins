# FROM golang:1.10
# WORKDIR /go/src/app
# COPY . .
# RUN go install -v
# CMD ["app"]
FROM busybox
RUN echo "hello world"
