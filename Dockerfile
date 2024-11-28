# Stage 1: Build the application
FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
COPY . .
RUN yarn install && \
    # yarn run test && \ 
    # yarn run cypress:run && \
    yarn run build

# Stage 2: Run the application
FROM node:18-alpine
WORKDIR /app
# Copy only necessary files from the build stage
COPY --from=build /app/package.json /app/next.config* ./
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/.env ./.env
RUN yarn install
CMD ["yarn" , "start"]
EXPOSE 3000