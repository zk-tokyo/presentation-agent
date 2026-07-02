#!/usr/bin/env node
// Parse one refinement iteration: pull the model's JSON review out of the
// Claude stream-json event log, record it, and signal the loop via exit code.
//
//   0  applied — keep iterating
//   10 applied — model reports convergence, stop
//   20 stop — rubric average stopped rising (plateau)
//   1  error — model output unusable
//
// Usage: node scripts/refine-step.mjs <events.jsonl> <runDir> <ii>
//
// The slide files are edited in place by the model itself (Edit/Write tools),
// so this helper only handles the review, not the deck.

import { readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const [eventsPath, runDir, ii] = process.argv.slice(2);
if (!eventsPath || !runDir || !ii) {
  console.error('usage: node scripts/refine-step.mjs <events.jsonl> <runDir> <ii>');
  process.exit(1);
}

const fail = (msg) => {
  console.error(`  ✗ ${msg}`);
  process.exit(1);
};

const AXES = [
  'clarity', 'desire', 'story', 'emotional_impact', 'credibility',
  'differentiation', 'culture', 'visual_readability', 'executive_pitch',
];

// --- pull the final assistant message out of the stream-json log -----------
let result = '';
for (const line of readFileSync(eventsPath, 'utf8').trim().split('\n')) {
  try {
    const o = JSON.parse(line);
    if (o.type === 'result' && typeof o.result === 'string') result = o.result;
  } catch {
    /* skip non-JSON lines */
  }
}
if (!result.trim()) fail('no final message in the model event log');
writeFileSync(join(runDir, `iter-${ii}-message.txt`), result);

// --- extract the JSON review (balanced-brace, string-aware) ----------------
const extractJson = (text) => {
  const start = text.indexOf('{');
  if (start === -1) return null;
  let depth = 0, inStr = false, esc = false;
  for (let i = start; i < text.length; i++) {
    const c = text[i];
    if (inStr) {
      if (esc) esc = false;
      else if (c === '\\') esc = true;
      else if (c === '"') inStr = false;
    } else if (c === '"') inStr = true;
    else if (c === '{') depth++;
    else if (c === '}') { depth--; if (depth === 0) return text.slice(start, i + 1); }
  }
  return null;
};

const jsonText = extractJson(result);
if (!jsonText) fail('no JSON review object in the final message');

let review;
try {
  review = JSON.parse(jsonText);
} catch (e) {
  fail(`review JSON did not parse: ${e.message}`);
}

const scores = review.scores || {};
const present = AXES.filter((a) => typeof scores[a] === 'number');
if (present.length !== AXES.length) {
  fail(`review is missing rubric axes: ${AXES.filter((a) => !present.includes(a)).join(', ')}`);
}

const average =
  typeof review.average === 'number'
    ? review.average
    : AXES.reduce((s, a) => s + scores[a], 0) / AXES.length;
const minAxis = Math.min(...AXES.map((a) => scores[a]));

// --- compare with the previous iteration -----------------------------------
const prevPath = join(runDir, 'last-review.json');
let prevAvg = null;
try {
  prevAvg = Number(JSON.parse(readFileSync(prevPath, 'utf8')).average);
} catch {
  /* first iteration */
}

writeFileSync(join(runDir, `iter-${ii}-review.json`), JSON.stringify(review, null, 2));
writeFileSync(prevPath, JSON.stringify(review, null, 2));

console.log(
  `  rubric: avg ${average.toFixed(2)}/5  (min axis ${minAxis.toFixed(1)})` +
    (Number.isFinite(prevAvg) ? `  prev ${prevAvg.toFixed(2)}` : ''),
);
if (review.critique) console.log(`  critique: ${review.critique}`);
for (const c of review.changelog || []) console.log(`  + ${c}`);
for (const g of review.remaining_gaps || []) console.log(`  · gap: ${g}`);

// --- loop control ----------------------------------------------------------
if (review.verdict === 'converged') process.exit(10);
if (Number.isFinite(prevAvg) && average <= prevAvg + 0.01) {
  console.log('  (no rubric gain — plateau)');
  process.exit(20);
}
process.exit(0);
