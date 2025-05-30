# Generated by https://smithery.ai. See: https://smithery.ai/docs/config#dockerfile
# Build stage
FROM node:lts-alpine AS build
WORKDIR /app

# Copy dependency manifests and TypeScript config
COPY package.json package-lock.json tsconfig.json ./

# Copy TypeScript source files and public assets
COPY src ./src
COPY public ./public

# Install dependencies and build
RUN npm install
RUN npm run build

# Runtime stage
FROM node:lts-alpine AS runtime
WORKDIR /app

# Copy built artifacts and production modules
COPY --from=build /app/build ./build
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/public ./public

# Expose port for MCP server if needed
EXPOSE 8888

# Default command to start the MCP server
CMD ["node", "build/index.js"]