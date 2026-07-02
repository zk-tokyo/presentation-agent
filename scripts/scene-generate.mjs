#!/usr/bin/env node
// Generate a visually-3d MachineSceneDescriptor for embedding in a Slidev
// slide. Runs the Claude CLI with the 3D scene generation prompt and writes
// public/scenes/<id>.json — which a slide then renders via <Scene3D>.
//
// Usage: node scripts/scene-generate.mjs <id> <name> <hint> [logDir]
//
// Env: CLAUDE_BIN (default claude), CLAUDE_MODEL (default opus)

import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const exec = promisify(execFile);
const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');

const [id, name, hint, logDir] = process.argv.slice(2);
if (!id || !name || !hint) {
  console.error('usage: node scripts/scene-generate.mjs <id> <name> <hint> [logDir]');
  process.exit(1);
}

const CLAUDE_BIN = process.env.CLAUDE_BIN || 'claude';
const CLAUDE_MODEL = process.env.CLAUDE_MODEL || 'opus';
const SHAPES = new Set(['box', 'cylinder', 'sphere', 'cone', 'torus', 'capsule', 'complex']);

const fail = (msg) => {
  console.error(`scene-generate: ${id}: ${msg}`);
  process.exit(1);
};

const system = readFileSync(join(ROOT, 'prompts/3D_Scene_Generation.md'), 'utf8');
const prompt = `${system}

Machine: ${name}
Context: ${hint}

Generate the MachineSceneDescriptor JSON now. Return JSON only.`;

const run = async () => {
  let stdout;
  try {
    // `--tools ""` disables all tools: a pure single-shot generation.
    ({ stdout } = await exec(
      CLAUDE_BIN,
      ['-p', prompt, '--model', CLAUDE_MODEL, '--tools', ''],
      { maxBuffer: 64 * 1024 * 1024, timeout: 600000 },
    ));
  } catch (e) {
    fail(`claude failed: ${e.message}`);
  }

  if (logDir) {
    mkdirSync(logDir, { recursive: true });
    writeFileSync(join(logDir, `${id}-raw.txt`), stdout);
  }

  const a = stdout.indexOf('{');
  const b = stdout.lastIndexOf('}') + 1;
  if (a < 0 || b <= a) fail('no JSON object in claude output');

  let scene;
  try {
    scene = JSON.parse(stdout.slice(a, b));
  } catch (e) {
    fail(`invalid JSON: ${e.message}`);
  }

  if (typeof scene.machine_name !== 'string' || !scene.machine_name.trim()) {
    fail('scene has no machine_name');
  }
  if (!Array.isArray(scene.parts) || scene.parts.length === 0) {
    fail('scene has no parts');
  }
  for (const p of scene.parts) {
    if (!p || !SHAPES.has(p.shape)) fail(`part "${p && p.id}" has invalid shape "${p && p.shape}"`);
  }

  const out = join(ROOT, 'public/scenes', `${id}.json`);
  mkdirSync(dirname(out), { recursive: true });
  writeFileSync(out, JSON.stringify(scene, null, 2) + '\n');
  console.log(`scene-generate: ${id} -> public/scenes/${id}.json (${scene.parts.length} parts)`);
};

run();
