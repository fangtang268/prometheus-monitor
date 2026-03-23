#!/bin/bash
sleep 5
# 获取Grafana API Token
TOKEN=$(curl -s -X POST http://admin:Ftang@196745@localhost:3000/api/auth/keys -H "Content-Type: application/json" -d '{"name":"monitor-token","role":"Admin"}' | jq -r '.key')
# 添加Prometheus数据源
curl -s -X POST http://localhost:3000/api/datasources -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{
  "name": "Prometheus","type": "prometheus","url": "http://localhost:9090","access": "proxy","isDefault": true,"basicAuth": false
}'
# 导入Node Exporter面板（ID:1860）
curl -s -X POST http://localhost:3000/api/dashboards/import -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{
  "dashboard": {
    "id": 1860,
    "uid": "node-exporter-full",
    "title": "Node Exporter Full",
    "tags": ["prometheus","node-exporter"],
    "timezone": "browser",
    "schemaVersion": 27,
    "version": 1
  },
  "inputs": [
    {
      "name": "DS_PROMETHEUS",
      "pluginId": "prometheus",
      "type": "datasource",
      "value": "Prometheus"
    }
  ],
  "overwrite": true
}'
echo -e "\nGrafana面板导入成功！登录信息："
echo "地址：http://192.168.9.131:3000"
echo "账号：admin | 密码：Ftang@196745"
