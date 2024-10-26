FROM node:18.20.4 
WORKDIR /app
COPY . .
RUN npm ci
EXPOSE 3000
CMD ["npx", "turbo", "dev"]