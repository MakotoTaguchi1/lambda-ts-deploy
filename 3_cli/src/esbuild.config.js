const esbuild = require("esbuild");

esbuild
  .build({
    entryPoints: ["index.ts"],
    bundle: true,
    platform: "node",
    target: "node22",
    outfile: "dist/index.js",
    external: ["aws-sdk"],
    format: "cjs", // CommonJS
    minify: true,
    sourcemap: true,
    logLevel: "info",
  })
  .catch(() => process.exit(1));
