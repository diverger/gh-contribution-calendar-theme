# Use Bun's official Alpine image (smallest base)
FROM oven/bun:1-alpine

# Install Chromium and minimal dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Set Puppeteer to use system Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

WORKDIR /action

# Copy only package files first (better layer caching)
COPY package.json ./

# Install production dependencies only
RUN bun install --production --no-save \
    && rm -rf /root/.bun/install/cache

# Copy application files
COPY github_holiday_puppeteer.js entrypoint.sh ./
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/action/entrypoint.sh"]
