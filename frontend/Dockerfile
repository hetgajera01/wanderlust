FROM node:21 as frontend-build
WORKDIR /app
COPY package* ./
RUN npm install
COPY . .

FROM node:21-slim 
WORKDIR /app
RUN groupadd -r nodegrp && useradd -r -g nodegrp nodeusr
COPY --from=frontend-build /app /app
COPY .env.sample .env
RUN chown -R nodeusr:nodegrp /app
USER nodeusr
EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

