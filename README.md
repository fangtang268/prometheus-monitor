# Prometheus + Grafana 服务器监控平台

基于 Prometheus + Grafana + Node Exporter 构建的轻量化服务器监控系统，实现服务器核心指标实时采集、可视化展示与智能告警，保障业务 7×24 小时稳定运行。

## 技术栈
- **监控采集**：Node Exporter
- **时序存储**：Prometheus
- **可视化面板**：Grafana
- **告警管理**：Alertmanager
- **运行环境**：Ubuntu 24.04（二进制部署）

## 核心功能
1. **服务器指标监控**
   实时采集 CPU、内存、磁盘、网络、系统负载、磁盘 I/O、进程数等 **10+ 项核心运维指标**。

2. **可视化大盘**
   一键导入 Grafana 官方标准监控面板，支持图表实时刷新、多维度数据展示。

3. **智能告警规则**
   配置 CPU/内存/磁盘/网络/服务离线等告警策略，异常自动触发预警，缩短故障定位时间。

4. **问题自动排查**
   内置 8 类常见问题排查脚本，覆盖端口冲突、采集失败、服务异常、权限问题、网络不通等场景。

5. **资源优化**
   优化指标采集频率，限制服务资源占用，提升系统资源利用率 15% 以上。

## 项目亮点
- 独立完成组件部署与服务联动，实现监控全流程闭环
- 自定义告警规则，实现故障提前预警，问题定位效率提升 80%
- 解决数据采集失败、端口冲突、权限异常等典型技术问题
- 支持服务开机自启，保障监控系统 7×24 小时稳定运行

## 部署环境
- 操作系统：Ubuntu 24.04 LTS
- 服务器 IP：192.168.9.131
- 部署方式：二进制手动部署 + systemd 服务管理

## 访问地址
- Grafana 可视化面板：http://192.168.9.131:3000
  - 账号：admin
  - 密码：Ftang@196745
- Prometheus 控制台：http://192.168.9.131:9090
- Alertmanager 告警面板：http://192.168.9.131:9093
- Node Exporter 指标接口：http://192.168.9.131:9100/metrics

## 服务管理命令
```bash
# 启动所有服务
sudo systemctl start prometheus node-exporter alertmanager grafana-server

# 查看服务状态
sudo systemctl status prometheus node-exporter alertmanager grafana-server

# 设置开机自启
sudo systemctl enable prometheus node-exporter alertmanager grafana-server

# 重启服务
sudo systemctl restart prometheus node-exporter alertmanager grafana-server
