export IMPORT_DASH_HOST = http://127.0.0.1:3000
export IMPORT_DASH_USERNAME = admin
export IMPORT_DASH_PASSWORD = admin

all: build disable install enable
	tput bel

build:
	cd pmm-app && npm run build && cd ..
	tar czf pmm-app.tar.gz pmm-app

install:
	docker exec pmm-server supervisorctl stop grafana
	docker exec pmm-server bash -c 'rm -rf /var/lib/grafana/plugins/pmm-*'
	docker cp pmm-app.tar.gz  pmm-server:/var/lib/grafana/plugins/
	docker exec pmm-server bash -c 'cd /var/lib/grafana/plugins/ && tar xzf pmm-app.tar.gz'
	docker exec pmm-server supervisorctl start grafana

disable:
	curl -X POST 'http://admin:admin@localhost/graph/api/plugins/pmm-app/settings' -d 'enabled=false'

enable:
	curl -X POST 'http://admin:admin@localhost/graph/api/plugins/pmm-app/settings' -d 'enabled=true'

test:
	./misc/import-dash.py
