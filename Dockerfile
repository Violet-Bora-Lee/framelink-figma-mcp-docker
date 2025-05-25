FROM node:18-alpine

# 작업 디렉토리 설정
WORKDIR /app

# figma-developer-mcp 패키지 설치
RUN npm install -g figma-developer-mcp

# 환경 변수 설정을 위한 기본값
ENV FIGMA_API_KEY=""

# MCP 서버 실행을 위한 스크립트 생성
RUN echo '#!/bin/sh' > /app/start.sh && \
    echo 'if [ -z "$FIGMA_API_KEY" ]; then' >> /app/start.sh && \
    echo '  echo "Error: FIGMA_API_KEY environment variable is required"' >> /app/start.sh && \
    echo '  exit 1' >> /app/start.sh && \
    echo 'fi' >> /app/start.sh && \
    echo 'exec figma-developer-mcp --figma-api-key="$FIGMA_API_KEY" --stdio' >> /app/start.sh && \
    chmod +x /app/start.sh

# 기본 사용자 생성 (보안상 권장)
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

USER nodejs

# 컨테이너 시작 명령어
CMD ["/app/start.sh"]