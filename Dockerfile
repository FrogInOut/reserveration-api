FROM node:20-alpine AS build

# Build arguments for JFrog configuration
ARG NPM_REGISTRY_URL="https://devreleplus.jfrog.io/artifactory/api/npm/llpd-npm-dev/"
ARG NPM_AUTH_TOKEN

# Configure npm for JFrog registry
RUN npm config set registry $NPM_REGISTRY_URL && \
    npm config set //${NPM_REGISTRY_URL#https://}:_authToken $NPM_AUTH_TOKEN && \
    npm config set always-auth true
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install --omit=dev
COPY . .
# Run
FROM node:20-alpine
WORKDIR /app
COPY --from=build /app /app
EXPOSE 3001
CMD ["node", "server.js"]
