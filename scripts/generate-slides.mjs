import { readdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const projectRoot = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "..",
);
const slidesDirectory = path.join(projectRoot, "slides");
const slidesIndexPath = path.join(projectRoot, "slides.md");
const exclusionListPath = path.join(projectRoot, "slides.exclude.md");

const generatedStart = "<!-- slides:auto:start -->";
const generatedEnd = "<!-- slides:auto:end -->";
const naturalOrder = new Intl.Collator("ja", {
  numeric: true,
  sensitivity: "base",
});

async function collectMarkdownFiles(directory, relativeDirectory = "slides") {
  const entries = await readdir(directory, { withFileTypes: true });
  const files = [];

  for (const entry of entries) {
    if (entry.name.startsWith(".")) continue;

    const absolutePath = path.join(directory, entry.name);
    const relativePath = path.posix.join(relativeDirectory, entry.name);

    if (entry.isDirectory()) {
      files.push(...(await collectMarkdownFiles(absolutePath, relativePath)));
    } else if (entry.isFile() && entry.name.toLowerCase().endsWith(".md")) {
      files.push(relativePath);
    }
  }

  return files;
}

function normalizeExcludedPath(rawPath) {
  let normalized = rawPath.trim().replaceAll("\\", "/");
  normalized = normalized.replace(/^\.\//, "");

  if (!normalized.startsWith("slides/")) {
    normalized = `slides/${normalized}`;
  }

  normalized = path.posix.normalize(normalized);
  if (!normalized.startsWith("slides/") || !normalized.endsWith(".md")) {
    throw new Error(`Invalid exclusion path: ${rawPath}`);
  }

  return normalized;
}

function parseExclusions(markdown) {
  const exclusions = new Set();

  for (const line of markdown.split(/\r?\n/)) {
    const match = line.match(/^\s*[-*+]\s+`([^`]+\.md)`(?:\s+.*)?$/i);
    if (match) exclusions.add(normalizeExcludedPath(match[1]));
  }

  return exclusions;
}

function updateFirstSlide(frontmatter, firstSlidePath) {
  const srcLine = `src: ./${firstSlidePath}`;

  if (/^src:\s*.*$/m.test(frontmatter)) {
    return frontmatter.replace(/^src:\s*.*$/m, srcLine);
  }

  return `${frontmatter.trimEnd()}\n${srcLine}`;
}

function makeGeneratedBlock(slidePaths) {
  const includes = slidePaths
    .map((slidePath) => `---\nsrc: ./${slidePath}\n---`)
    .join("\n");

  return includes
    ? `${generatedStart}\n${includes}\n${generatedEnd}`
    : `${generatedStart}\n${generatedEnd}`;
}

const [allSlidePaths, exclusionMarkdown, currentIndex] = await Promise.all([
  collectMarkdownFiles(slidesDirectory),
  readFile(exclusionListPath, "utf8"),
  readFile(slidesIndexPath, "utf8"),
]);

allSlidePaths.sort((left, right) => naturalOrder.compare(left, right));

const exclusions = parseExclusions(exclusionMarkdown);
const availableSlides = new Set(allSlidePaths);
for (const excludedPath of exclusions) {
  if (!availableSlides.has(excludedPath)) {
    console.warn(`Excluded slide does not exist: ${excludedPath}`);
  }
}

const visibleSlides = allSlidePaths.filter(
  (slidePath) => !exclusions.has(slidePath),
);
if (visibleSlides.length === 0) {
  throw new Error("No visible Markdown slides were found in slides/.");
}

const frontmatterMatch = currentIndex.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n/);
if (!frontmatterMatch) {
  throw new Error("slides.md must begin with YAML frontmatter.");
}
if (!currentIndex.includes(generatedStart) || !currentIndex.includes(generatedEnd)) {
  throw new Error(
    `slides.md must contain ${generatedStart} and ${generatedEnd}.`,
  );
}

const updatedFrontmatter = updateFirstSlide(
  frontmatterMatch[1],
  visibleSlides[0],
);
let nextIndex = currentIndex.replace(
  frontmatterMatch[0],
  `---\n${updatedFrontmatter}\n---\n`,
);

const generatedBlock = makeGeneratedBlock(visibleSlides.slice(1));
const generatedBlockPattern = new RegExp(
  `${generatedStart.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}[\\s\\S]*?${generatedEnd.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}`,
);
nextIndex = nextIndex.replace(generatedBlockPattern, generatedBlock);

if (!nextIndex.endsWith("\n")) nextIndex += "\n";

if (nextIndex !== currentIndex) {
  await writeFile(slidesIndexPath, nextIndex, "utf8");
}

console.log(
  `Generated slides.md: ${visibleSlides.length} included, ${allSlidePaths.length - visibleSlides.length} excluded.`,
);
