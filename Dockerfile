FROM golang:1.10-alpine AS gobuild-base
RUN apk add --no-cache \
	git \
	make

FROM gobuild-base AS clair-scanner
WORKDIR /go/src/github.com/arminc/clair-scanner
COPY . .
RUN make build && mv clair-scanner /usr/bin/clair-scanner

FROM alpine
RUN apk add --no-cache \
	git
COPY --from=clair-scanner /usr/bin/clair-scanner /usr/bin/clair-scanner
ENTRYPOINT [ "clair-scanner" ]
CMD [ "" ]