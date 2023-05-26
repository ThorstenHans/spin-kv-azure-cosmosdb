# create a run PHONY
.PHONY: run

run:
	cd app; \
	spin build; \
	spin up --runtime-config-file ./rt-config.toml
