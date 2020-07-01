PROVIDER=
VARS=

all: build.zookeeper build.kafka_broker build.schema_registry build.kafka_connect build.ksql build.kafka_rest build.control_center

build.zookeeper:
	packer build ${PROVIDER} ${VARS} -var cp_component=zookeeper -force packer/main.json
build.kafka_broker:
	packer build ${PROVIDER} ${VARS} -var cp_component=kafka_broker -force packer/main.json
build.schema_registry:
	packer build ${PROVIDER} ${VARS} -var cp_component=schema_registry -force packer/main.json
build.kafka_connect:
	packer build ${PROVIDER} ${VARS} -var cp_component=kafka_connect -force packer/main.json
build.ksql:
	packer build ${PROVIDER} ${VARS} -var cp_component=ksql -force packer/main.json
build.kafka_rest:
	packer build ${PROVIDER} ${VARS} -var cp_component=kafka_rest -force packer/main.json
build.control_center:
	packer build ${PROVIDER} ${VARS} -var cp_component=control_center -force packer/main.json
  