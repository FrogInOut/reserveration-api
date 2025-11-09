# Build
FROM node:20-alpine AS build
WORKDIR /app
RUN npm config set registry https://registry.npmjs.org/ && \
    npm config set @jfrog:registry https://registry.npmjs.org/ && \
    npm config delete //@jfrog:_authToken || true
COPY package.json package-lock.json* ./
RUN npm install --omit=dev
COPY . .
# Run
FROM node:20-alpine
WORKDIR /app
COPY --from=build /app /app
EXPOSE 3001
CMD ["node", "server.js"]
