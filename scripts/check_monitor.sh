#!/bin/bash
echo "====================================="
echo "服务器监控系统问题排查（192.168.9.131）"
echo "====================================="
# 1. 端口冲突检查
echo -e "\n【1. 端口冲突检查】"
ports=(9090 9100 9093 3000)
for port in "${ports[@]}"; do
  pid=$(lsof -t -i:$port)
  if [ -n "$pid" ]; then
    echo "端口 $port 被占用（PID: $pid），进程名：$(ps -p $pid -o comm=)"
  else
    echo "端口 $port 未被占用（正常）"
  fi
done
# 2. 系统服务状态检查
echo -e "\n【2. 服务状态检查】"
services=(prometheus node-exporter alertmanager grafana-server)
for service in "${services[@]}"; do
  status=$(sudo systemctl is-active $service)
  if [ "$status" = "active" ]; then
    echo "服务 $service 运行正常（状态：$status）"
  else
    echo "服务 $service 异常（状态：$status）"
  fi
done
# 3. 数据采集检查
echo -e "\n【3. 数据采集检查】"
if curl -s http://localhost:9100/metrics > /dev/null; then
  echo "Node Exporter 数据采集正常"
else
  echo "Node Exporter 数据采集失败"
fi
# 4. Prometheus配置检查
echo -e "\n【4. Prometheus配置检查】"
/usr/local/prometheus/promtool check config ~/prometheus-monitor/config/prometheus/prometheus.yml > /dev/null
if [ $? -eq 0 ]; then
  echo "Prometheus 配置文件语法正确"
else
  echo "Prometheus 配置文件语法错误"
  /usr/local/prometheus/promtool check config ~/prometheus-monitor/config/prometheus/prometheus.yml
fi
# 5. 目录权限检查
echo -e "\n【5. 目录权限检查】"
dirs=(/var/lib/prometheus /var/lib/alertmanager ~/prometheus-monitor)
for dir in "${dirs[@]}"; do
  owner=$(stat -c "%U" $dir)
  if [ "$owner" = "prometheus" ] || [ "$owner" = "alertmanager" ] || [ "$owner" = "fangtang268" ]; then
    echo "目录 $dir 权限正常（属主：$owner）"
  else
    echo "目录 $dir 权限异常（属主：$owner）"
  fi
done
# 6. 系统资源检查
echo -e "\n【6. 系统资源检查】"
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
echo "CPU 使用率：${cpu_usage}%"
echo "内存 使用率：${mem_usage}%"
if ((  )); then
  echo "警告：CPU使用率过高（>90%）"
fi
if ((  )); then
  echo "警告：内存使用率过高（>90%）"
fi
# 7. 网络连通性检查
echo -e "\n【7. 网络连通性检查】"
targets=("localhost:9090" "localhost:9100" "localhost:9093" "localhost:3000")
for target in "${targets[@]}"; do
  host=$(echo $target | cut -d: -f1)
  port=$(echo $target | cut -d: -f2)
  if nc -z $host $port > /dev/null; then
    echo "可连通 $target（正常）"
  else
    echo "无法连通 $target（异常）"
  fi
done
# 8. 告警规则检查
echo -e "\n【8. 告警规则检查】"
/usr/local/prometheus/promtool check rules ~/prometheus-monitor/config/prometheus/rules/alert_rules.yml > /dev/null
if [ $? -eq 0 ]; then
  echo "告警规则语法正确"
else
  echo "告警规则语法错误"
  /usr/local/prometheus/promtool check rules ~/prometheus-monitor/config/prometheus/rules/alert_rules.yml
fi
echo -e "\n====================================="
echo "排查完成！异常项请手动处理"
echo "====================================="
