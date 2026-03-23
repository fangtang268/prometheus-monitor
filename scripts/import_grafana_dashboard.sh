#!/bin/bash
sleep 10
TOKEN=$(curl -s -X POST http://admin:admin@localhost:3000/api/auth/keys -H "Content-Type: application/json" -d '{"name":"monitor-token","role":"Admin"}' | jq -r '.key')
# 首次登录修改Grafana密码
curl -s -X PUT http://admin:admin@localhost:3000/api/user/password -H "Content-Type: application/json" -d '{"password":"196745ft","oldPassword":"admin"}'
# 重新获取Token（密码修改后）
TOKEN=$(curl -s -X POST http://admin:196745ft@localhost:3000/api/auth/keys -H "Content-Type: application/json" -d '{"name":"monitor-token","role":"Admin"}' | jq -r '.key')
# 导入面板
curl -s -X POST http://localhost:3000/api/dashboards/import -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{
  "dashboard": {"id": 1860,"uid": "node-exporter-full","title": "Node Exporter Full","tags": ["prometheus","node-exporter"],"timezone": "browser","schemaVersion": 27,"version": 1},
  "inputs": [{"name": "DS_PROMETHEUS","pluginId": "prometheus","type": "datasource","value": "Prometheus"}],
  "overwrite": true
}'
# 添加Prometheus数据源
curl -s -X POST http://localhost:3000/api/datasources -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{
  "name": "Prometheus","type": "prometheus","url": "http://localhost:9090","access": "proxy","isDefault": true,"basicAuth": false
}'
echo "Grafana 面板导入完成！访问 http://192.168.9.131:3000 查看（账号：admin，密码：196745ft）"
