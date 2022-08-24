DUSER=aceberg
DNAME=watchyourlan

IFACE=virbr-bw
DBPATH=data/hosts.db

mod:
	cd src && \
	rm go.mod && \
	go mod init $(DNAME) && \
	go mod tidy

run:
	cd src && \
	sudo \
	env IFACE=$(IFACE) DBPATH=$(DBPATH) \
	go run .

go-build:
	cd src && \
	go build .

docker-build:
	docker build -t $(DUSER)/$(DNAME) .

docker-run:
	docker rm wyl || true
	docker run --name wyl \
	-e "IFACE=$(IFACE)" \
	-e "TZ=Asia/Novosibirsk" \
	--network="host" \
	-v ~/.dockerdata/wyl:/data \
	$(DUSER)/$(DNAME)

clean:
	rm src/$(DNAME) || true
	docker rmi -f $(DUSER)/$(DNAME)

dev: docker-build docker-run