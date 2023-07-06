FROM golang:1.19 as build
ARG LDFLAGS
WORKDIR /go/src/app
COPY . .

# Build the binary
# if vendor directory exists, add -mod=vendor flag
RUN if [ -d vendor ]; then \
    CGO_ENABLED=0 GOOS=linux go build -mod=vendor -ldflags="${LDFLAGS:-}" -o /app/main main.go; \
    else \
    CGO_ENABLED=0 GOOS=linux go build -ldflags="${LDFLAGS:-}" -o /app/main main.go; \
    fi

FROM starrocks/static-debian11

COPY --from=build /app/main /main
CMD ["/main"]
