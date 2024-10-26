FROM node:18.20.4 
WORKDIR /app
# Installing the dependencies
COPY package.json package-lock.json ./
RUN npm ci
# Copying the rest of the file
COPY . .
EXPOSE 3000
CMD ["npx", "turbo", "dev"]