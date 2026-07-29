# alibaba-sentinel-docker-imgae

### 1、docker run 启动覆盖变量（推荐）
```bash
docker run -d \
  -p 8088:8088 \
  -e SERVER_PORT=8088 \
  -e DASHBOARD_SERVER=localhost:8088 \
  -e DASH_USER=admin \
  -e DASH_PASS=MyStrongPass@2026 \
  sentinel-dashboard:1.8.10
```

### 2、docker-compose.yml 写法

```yaml
version: '3.8'
services:
  sentinel-dashboard:
    image: sentinel-dashboard:1.8.10
    ports:
      - "8080:8080"
    environment:
      SERVER_PORT: 8080
      DASHBOARD_SERVER: localhost:8080
      DASH_USER: admin
      DASH_PASS: Sentinel@666
    restart: always
```

### 3、K8s Deployment 环境变量注入（可改用 Secret 存密码）
```yaml
env:
  - name: SERVER_PORT
    value: "8080"
  - name: DASHBOARD_SERVER
    value: "localhost:8080"
  - name: DASH_USER
    value: "admin"
  # 生产密码建议从Secret读取，不要明文
  - name: DASH_PASS
    valueFrom:
      secretKeyRef:
        name: sentinel-secret
        key: dashboard-password
```
### 对应创建 Secret 命令
```bash
kubectl create secret generic sentinel-secret \
--from-literal=dashboard-password='ComplexPassword@2026'
```
