FROM node:20-alpine AS build

# Build arguments for JFrog configuration
ARG NPM_REGISTRY_URL="https://devreleplus.jfrog.io/artifactory/api/npm/llpd-npm-dev/"
ARG NPM_AUTH_TOKEN

WORKDIR /app

# Create .npmrc file for authentication
RUN echo "registry=${NPM_REGISTRY_URL}" > .npmrc && \
    echo "//${NPM_REGISTRY_URL#https://}:_authToken=${NPM_AUTH_TOKEN}" >> .npmrc && \
    echo "always-auth=true" >> .npmrc
COPY package.json package-lock.json* ./
RUN npm install --omit=dev && rm -f .npmrc
COPY . .
# Run
FROM node:20-alpine
WORKDIR /app
COPY --from=build /app /app
EXPOSE 3001
CMD ["node", "server.js"]
