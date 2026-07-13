import { PrismaClient } from "@prisma/client";

function configureDatabaseUrl(): void {
  if (process.env.DATABASE_URL) {
    return;
  }

  const host = process.env.DB_HOST;
  const port = process.env.DB_PORT ?? "5432";
  const database = process.env.DB_NAME;
  const username = process.env.DB_USER;
  const password = process.env.DB_PASSWORD;

  if (!host || !database || !username || !password) {
    throw new Error(
      "Database configuration is incomplete. Provide DATABASE_URL or DB_HOST, DB_NAME, DB_USER, and DB_PASSWORD."
    );
  }

  const encodedUsername = encodeURIComponent(username);
  const encodedPassword = encodeURIComponent(password);

  process.env.DATABASE_URL =
    `postgresql://${encodedUsername}:${encodedPassword}` +
    `@${host}:${port}/${database}?schema=public`;
}

configureDatabaseUrl();

const prisma = new PrismaClient();

export default prisma;