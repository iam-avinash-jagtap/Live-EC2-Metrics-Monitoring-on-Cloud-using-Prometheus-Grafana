# Live EC2 Metrics Monitoring on Cloud using Prometheus & Grafana
Hello, in this project you are going to set up a cloud-based monitoring solution to track real-time performance metrics (CPU, memory, disk, etc.) of Amazon EC2 instances using Prometheus and Node Exporter. The data was visualized through interactive Grafana dashboards. This project enabled continuous monitoring of system health, detection of performance issues, analysis of resource bottlenecks, and validation of system stability under stress conditions — providing deep insight into infrastructure behavior and boosting cloud observability skills.

---
## 🏗️ Project Infrastructure:
```bash
AWS Cloud
│
├── VPC
│   ├── Subnet (Public or Private)
│   │
│   ├── Security Groups
│   │   ├── Prometheus SG (Allow inbound :9090 from Grafana)
│   │   ├── Grafana SG (Allow inbound :3000 from your IP or anywhere)
│   │   └── Node Exporter SG (Allow inbound :9100 from Prometheus)
│
├── EC2 Instances
│   ├── Prometheus Server
│   │   ├── Installed Prometheus
│   │   ├── Configured `prometheus.yml`
│   │   └── Scraping node exporter metrics from target instance
│   │
│   ├── Grafana Server
│   │   ├── Installed Grafana
│   │   ├── Connected to Prometheus as a data source
│   │   └── Imported dashboard to visualize EC2 metrics
│   │
│   └── Monitored EC2 Node
│       ├── Installed Node Exporter
│       └── Exposing metrics on port :9100
│
└── Optional
    ├── Stress Testing Tools
    │   └── `stress` command to simulate high CPU/Memory load on node
```

## ✅ **Pre-requisites:**
Here are the **Pre-requisites** for your **Live EC2 Metrics Monitoring on Cloud using Prometheus & Grafana** project:
1. **AWS Account**

   * With necessary permissions to launch EC2, configure security groups, and access VPC resources.

2. **EC2 Knowledge**

   * Basic understanding of launching, connecting to, and managing EC2 instances.

3. **2 EC2 Instances (Amazon Linux 2023)**

   * **1 for Prometheus Server**
   * **1 for Grafana Server**
   * (Optional: 3rd EC2 for Node Exporter if you want to separate monitoring target)

4. **Security Groups**

   * Inbound Rules:

     * Prometheus: `9090` (from Grafana SG or your IP)
     * Grafana: `3000` (from your IP)
     * Node Exporter: `9100` (from Prometheus SG)

5. **Linux Commands**

   * Familiarity with `dnf`, `wget`, `tar`, `systemctl`, etc.

6. **Networking**

   * Allow EC2 instances to communicate (same VPC or peered VPCs)
   * Outbound internet access (for downloading packages)

7. **Prometheus Knowledge (Basic)**

   * How to install, configure `prometheus.yml`, and run as a service.

8. **Grafana Knowledge (Basic)**

   * Setup and connect data sources
   * Import dashboards

9. **Node Exporter Setup**

   * Installed and running on the target EC2 instance (monitored node)

10. **Optional Tools**

    * `stress` or `stress-ng` command to generate artificial load for testing.

# Steps:
---
## Step 1: Launch EC2 Instances

- Launch **two Amazon Linux 2023** EC2 instances:  
  - One for **Prometheus** server  
  - One for **Grafana** server  

- Additionally, the **target EC2** instance (can be Prometheus node or another) will run **Node Exporter** to expose system metrics.

- Open relevant ports in Security Groups:  
  - Prometheus: TCP 9090  
  - Grafana: TCP 3000  
  - Node Exporter: TCP 9100

[Linux Server Setup for Project,](https://github.com/iam-avinash-jagtap/Linux-Server-Deployment-on-AWS-E2)

![Instances](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Instances.png)

---

## Step 2: Install & Configure Prometheus
_First, install and configure the data source server — Prometheus._

1. SSH into the **Prometheus EC2 instance**.
```bash
ssh -i "your-key.pem" ec2-user@<Prometheus_EC2_PUBLIC_IP>

```
2. Clone GitHub repository for Prometheus installation script:
```bash  
 git clone https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana
 ``` 
 3. Run Script:
 ```bash
chmod u+x install-prometheus.sh

./install-prometheus.sh

 ```
 4. Verify Prometheus Running or Not:
 ```bash
 sudo systemctl status prometheus
 ```
 5. Access Prometheus Server:
    - Go to AWS Console 
    - Copy Public IP of Prometheus EC2 Instance
    - Paste in New Tab with Port Number
      - http://<Prometheus-EC2-public_IP>:9090

![Prometheus_Server](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Prometheus%20Server.png)

---
## Step 3: Install & Configure Grafana
_Data source is ready now install and configure the dashboard server — Grafana._

1. SSH into the **Grafana EC2 instance**.
```bash
ssh -i "your-key.pem" ec2-user@<GRAFANA_EC2_PUBLIC_IP>

```

2. Clone GitHub repository for Grafana installation script:
```bash  
 git clone https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana
 ``` 

 3. Run Script:
 ```bash
chmod u+x install-grafana.sh

./install-grafana.sh

 ```

 4. Verify Grafana Running or Not:
 ```bash
 sudo systemctl status grafana-server
 ```

 5. Access Grafana Server:
    - Go to AWS Console 
    - Copy Public IP of Grafana EC2 Instance
    - Paste in New Tab with Port Number
      - http://<Grafana-EC2-public_IP>:3000

6. Login to Grafana:
    - Enter Username:
      - admin
    - Enter Password:
      - admin
    - Create New Password:
      - Enter New Password 

![Grafana_Server](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Grafana%20Server.png)

---
## Step 4: Add Prometheus Data Source
_Your Server setup is done, Now Add data source to connect dashboard._

1. In the left sidebar, click "3 lines 

2. Click on **Connections** → **Data Sources**

3. Click on **+ Add new data source**

4. Search Data Source → `Prometheus` → Click on it

5. Open it and Connect with Grafana

   1. Enter name → Prometheus
   2. In **Connnection** → Enter prometheus sever URL →

![Prometheus_URL](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Enter%20Prometheus%20details.png)

   3. Scroll down Click  → **Save & Test**
   - If setup is successful, you’ll see a green message:
        → _Data source is working_
   4. Open Data Source → `Prometheus`

![Add_data_Source](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Add%20data%20source.png)

   5. Choose `Dashboard` → **Prometheus 2.0 Stats**

 ![Prometheus_Dashboard_Selection](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Prometheus%20dashboard%20selection.png)

   6. Click → **Home**
   7. Open dashboard → **Prometheus 2.0 Stats**

![Sample_Dashboard](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Dashboard%20sample.png)

#### ✅ Prometheus and Grafana are successfully installed, configured, and ready for real-time monitoring!

## Step 5: Configure Monitored EC2 Instance as Node Exporter
_In this step you are going to sets up Node Exporter on the monitored EC2 instance to expose system metrics for Prometheus to scrape and Grafana to visualize._

1. Download Node Exporter
```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz

```

2. Extract the Archive
```bash
tar -xvf node_exporter-1.8.0.linux-amd64.tar.gz
```

3. Start Node Exporter
```bash
cd node_exporter-1.8.0.linux-amd64
./node_exporter &

```

4. Confirm Exporter is Working
    - http://< Monitored-EC2-Public-IP >:9100/metrics

![Node_Exporter](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Node%20Executor.png)

---

## Step 6: Add Node Exporter to Prometheus Config
_All three server are ready to connect and test full setup now you can add node exorter to prometheus server._

1. Go to **Prometheus** server Terminal 

2. Edit `prometheus.yml` File 
   - Clean up obsolete entries.
```bash 
# Global config
global:
  scrape_interval: 15s      # Set scrape interval to every 15 seconds
  evaluation_interval: 15s  # Evaluate rules every 15 seconds

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Rule files to load
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# Scrape configurations
scrape_configs:
  # Prometheus server scrape job
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  # Example node exporter scrape job (add your node IP here)
  - job_name: "ec2-node"
    static_configs:
      - targets: ["<Monitored-EC2-Private-IP>:9100"] 
      # Replace <Monitored-EC2-Private-IP> with Your Node Exporter's Private IP     

```
![Edit_prometheus.yml_FIle](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Edit%20Prometheus%20file.png)

3. Save the file and exit the editor

4. Restart Prometheus
```bash
sudo systemctl restart prometheus

```

5. To confirm it's working, visit:
    - http://< Prometheus-EC2-Public-IP >:9090/targets
      - You should see the `node-exporter` **target as UP**
---
## Step 7: Visualize Metrics in Grafana
_This step guides you to import a prebuilt dashboard in Grafana to visualize real-time metrics collected from Node Exporter via Prometheus._

1. Go to `Grafana` Server → Home

2. Click on `+` icon → `New Dashboard`

3. Click → Import a dashboard

![New_DashBoard_Creation](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Create%20Dashboard%20for%20node.png)

4. In the Import via Grafana.com field, enter dashboard ID → 1680

![Node_Exporter_Details](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Import%20Dashboard.png)

5. Click `Load`

6. Go To → Dashboards you will see → `Node Exporter Full` tags `linux`

![Dashboard_list](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Dashboard%20-%20Node.png)

7. Open it 

8. Now you can Monitor your `Targeted EC2 Instance`

![Before_stress](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Node%20dashboard%201st.png)

---

## Step 8: Simulate Load for Real-Time Monitoring 
_To test real-time monitoring, install and run the stress tool on the monitored EC2 instance:_

1. Go to `Node Exporter` Server Terminal 

2. install and run the stress tool
```bash
sudo dnf install -y epel-release
sudo dnf install -y stress

stress --cpu 2 --timeout 300

```

![Stress](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Stress%20command.png)

3. Monitor live CPU usage changes on the Grafana dashboard.

![After_Stress](https://github.com/iam-avinash-jagtap/Live-EC2-Metrics-Monitoring-on-Cloud-using-Prometheus-Grafana/blob/master/Images/Node%20Dashboard%20stress.png)

##### Your complete monitoring stack with Prometheus and Grafana is fully operational, enabling you to actively track and visualize real-time performance metrics of your targeted EC2 instance with precision and efficiency.

---
# Summary 
This project demonstrates how to implement a complete real-time EC2 monitoring solution on AWS using Prometheus and Grafana. By deploying and configuring Prometheus as a data source and Node Exporter on a monitored EC2 instance, users can collect crucial system-level metrics such as CPU, memory, disk, and network activity. Grafana, serving as the visualization layer, connects to Prometheus and presents these metrics through interactive dashboards, enabling users to track infrastructure performance in a single glance.

The infrastructure involves launching multiple EC2 instances for each role — Prometheus, Grafana, and the monitored node — with proper networking, security group configurations, and port mappings. Node Exporter runs on the monitored instance, exposing performance data on port 9100, which is scraped by Prometheus based on a defined scrape configuration. Grafana then imports this data and visualizes it using a prebuilt dashboard, such as “Node Exporter Full”, providing deep insight into resource utilization.

With stress tools like stress, the project also validates how the monitoring stack behaves under load conditions. This simulates real-world performance scenarios and helps evaluate system responsiveness and bottleneck detection. Overall, the project enhances your hands-on skills in Linux, AWS EC2, monitoring stacks, and cloud observability — a must-have capability for any aspiring DevOps or Cloud Engineer.

