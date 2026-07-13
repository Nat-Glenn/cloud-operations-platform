import express, { Request, Response } from "express";
import cors from "cors";
import dotenv from "dotenv";
import prisma from "./db/prisma";

dotenv.config();

const app = express();
const port = Number(process.env.PORT) || 3000;

app.use(cors());
app.use(express.json());

app.get("/", (_req: Request, res: Response) => {
  res.status(200).json({
    service: "cloud-operations-platform",
    status: "running",
  });
});

app.get("/healthz", (_req: Request, res: Response) => {
  res.status(200).json({
    status: "healthy",
  });
});

app.get(
  "/healthz/deps/database",
  async (_req: Request, res: Response) => {
    const startTime = Date.now();

    try {
      await prisma.$queryRaw`SELECT 1`;

      res.status(200).json({
        status: "healthy",
        dependency: "postgresql",
        responseTimeMs: Date.now() - startTime,
      });
    } catch (error) {
      console.error("Database dependency probe failed:", error);

      res.status(503).json({
        status: "unhealthy",
        dependency: "postgresql",
        error: "Database unavailable",
        responseTimeMs: Date.now() - startTime,
      });
    }
  }
);

app.listen(port, () => {
  console.log(`Cloud Operations API listening on port ${port}`);
});