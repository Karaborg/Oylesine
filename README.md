# Welcome
This is a project that provides a basic playground for its users to practice some of the monitoring tools such as Grafana, Prometheus, Kafka-UI, and Opensearch while data flows from [fixer API](https://fixer.io/) via Python scripts and Apache Kafka. Other tools including Logstash, Kafka Exporter, and Influx DB are to help integrate this data flow into monitoring tools.

Everything is automated for a basic setup. The only thing the user needs to do is to use the run scripts from `/Run-Scripts` as they want.

Be aware that since we are using [fixer API](https://fixer.io/), users need to create an account so they can have an *API_KEY* to use.

Since this project aims to be a playground, it will only have basic integrations and monitoring dashboards. And even unnecessary data flow inside Apache Kafka too.

# How to Start
Clone the project and make sure your docker is running. Once you set up everything, you can run `/Run-Scripts/start-all.sh` to start everything.

Once you run the `/Run-Scripts/start-all.sh` script, it will ask you a couple of questions to create a `.env` file for you. You can use the defaults by pressing the enter button or modify it however you want. 

> Make sure to give an actual *API_KEY* from [fixer API](https://fixer.io/).

# Good to Know
### Fixer
- We use [fixer API](https://fixer.io/) to gather currency data into project.

### Producer
- Inside this container, we have a Python script that gets the data from the API and pushes it into Apache Kafka.

### Error Producer
- This is added only to creating some error logs, so users can practice on error logs too.

### Consumer
- Another Python container to consume data from Apache Kafka and insert the data into Influx DB, so we can monitor the actual table from Grafana.

### Centos
- This container has a [kafka_exporter](https://github.com/danielqsj/kafka_exporter) volume so when it runs, we also automatically get Apache Kafka metrics for Prometheus.

Other containers such as *Zookeeper*, *Broker*, *Kafka-UI*, *Grafana*, *Prometheus*, *InfluxDB*, *Opensearch*, *Opensearch-Dashboards*, *Logstash* and *Filebeat* are only the applications themselves, with prefixed integrations.

![plot](./Oylesine.drawio.png)

# Environment File
All the environment parameters are accessible inside the `.env` file.

# Application URL's
Once you installed the project and run it, you can access monitoring applications via below links:

- [Grafana](http://localhost:3000/)

- [Prometheus](http://localhost:9090/)

- [Kafka-UI](http://localhost:8080/)

- [Opensearch](http://localhost:5601/)

