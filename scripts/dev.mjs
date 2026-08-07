import { unwatchFile, watchFile } from "node:fs";
import path from "node:path";
import { spawn } from "node:child_process";
import { fileURLToPath } from "node:url";

import { generateSlidesIndex } from "./generate-slides.mjs";

const projectRoot = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "..",
);
const slidesDirectory = path.join(projectRoot, "slides");
const exclusionListPath = path.join(projectRoot, "slides.exclude.md");
const slidevCli = path.join(
  projectRoot,
  "node_modules",
  "@slidev",
  "cli",
  "bin",
  "slidev.mjs",
);

let generationTimer;
let generationInProgress = false;
let generationQueued = false;
let shuttingDown = false;

async function regenerateSlides() {
  if (generationInProgress) {
    generationQueued = true;
    return;
  }

  generationInProgress = true;
  try {
    await generateSlidesIndex();
  } catch (error) {
    console.error("Failed to regenerate slides.md:", error);
  } finally {
    generationInProgress = false;
    if (generationQueued) {
      generationQueued = false;
      await regenerateSlides();
    }
  }
}

function scheduleRegeneration() {
  clearTimeout(generationTimer);
  generationTimer = setTimeout(regenerateSlides, 80);
}

await regenerateSlides();

watchFile(slidesDirectory, { interval: 500 }, scheduleRegeneration);
watchFile(exclusionListPath, { interval: 500 }, scheduleRegeneration);

const slidevArguments = process.argv.slice(2);
if (!slidevArguments.some((argument) => argument.startsWith("--open"))) {
  slidevArguments.unshift("--open");
}

const slidev = spawn(process.execPath, [slidevCli, ...slidevArguments], {
  cwd: projectRoot,
  env: process.env,
  stdio: "inherit",
});

function closeWatchers() {
  clearTimeout(generationTimer);
  unwatchFile(slidesDirectory);
  unwatchFile(exclusionListPath);
}

function shutdown(signal) {
  if (shuttingDown) return;
  shuttingDown = true;
  closeWatchers();
  if (!slidev.killed) slidev.kill(signal);
}

process.once("SIGINT", () => shutdown("SIGINT"));
process.once("SIGTERM", () => shutdown("SIGTERM"));

slidev.once("error", (error) => {
  closeWatchers();
  console.error("Failed to start Slidev:", error);
  process.exitCode = 1;
});

slidev.once("exit", (code, signal) => {
  closeWatchers();
  process.exitCode = shuttingDown ? 0 : (code ?? (signal ? 1 : 0));
});
