FROM amd64/buildpack-deps:buster-curl AS installer

ARG SENTINEL_VERSION=1.8.10

RUN set -x \
    && curl -SL --output /home/sentinel-dashboard.jar https://github.com/alibaba/Sentinel/releases/download/${SENTINEL_VERSION}/sentinel-dashboard-${SENTINEL_VERSION}.jar

FROM eclipse-temurin:8-jre-jammy

# 时区修复，避免日志时间差
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 拷贝jar包
COPY --from=installer ["/home/sentinel-dashboard.jar", "/home/sentinel-dashboard.jar"]

# ====================== 独立环境变量，可外部覆盖 ======================
ENV SERVER_PORT=8080
ENV DASHBOARD_SERVER=localhost:8080
ENV DASH_USER=admin
ENV DASH_PASS=Admin@123456

ENV JAVA_OPTS=""

EXPOSE ${SERVER_PORT}

CMD ["sh", "-c", "exec java ${JAVA_OPTS} -Dserver.port=\"${SERVER_PORT}\" -Dcsp.sentinel.dashboard.server=\"${DASHBOARD_SERVER}\" -Dsentinel.dashboard.auth.username=\"${DASH_USER}\" -Dsentinel.dashboard.auth.password=\"${DASH_PASS}\" -Dfile.encoding=UTF-8 -Dserver.servlet.session.timeout=3600 -jar /home/sentinel-dashboard.jar"]
