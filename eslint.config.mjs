import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTypeScript from "eslint-config-next/typescript";

const sourceFiles = ["src/**/*.{js,jsx,ts,tsx}"];
const appFiles = ["app/**/*.{js,jsx,ts,tsx}"];

const environmentAccessRestriction = [
  "error",
  {
    object: "process",
    property: "env",
    message:
      "Application environment access belongs in src/infrastructure/config.",
  },
];

const appImports = {
  regex: "^(?:app(?:/|$)|@/app(?:/|$)|(?:\\.\\./)+app(?:/|$))",
  message: "Code under src must not depend on the Next.js app boundary.",
};

const moduleInternalAliases = {
  regex: "^(?:@modules/[^/]+/.+|@/src/modules(?:/|$))",
  message: "Consume a module through its public surface, never through module internals.",
};

const sharedModuleImports = {
  regex:
    "^(?:@modules(?:/|$)|@/src/modules(?:/|$)|src/modules(?:/|$)|(?:\\.\\./)+modules(?:/|$))",
  message: "Shared code must not depend on functional modules.",
};

const sharedInfrastructureImports = {
  regex:
    "^(?:@infrastructure(?:/|$)|@/src/infrastructure(?:/|$)|src/infrastructure(?:/|$)|(?:\\.\\./)+infrastructure(?:/|$))",
  message: "Shared code must not depend on common infrastructure.",
};

export default defineConfig([
  ...nextVitals,
  ...nextTypeScript,
  {
    files: sourceFiles,
    rules: {
      "no-restricted-properties": environmentAccessRestriction,
      "no-restricted-imports": [
        "error",
        { patterns: [appImports, moduleInternalAliases] },
      ],
    },
  },
  {
    files: appFiles,
    rules: {
      "no-restricted-properties": environmentAccessRestriction,
      "no-restricted-imports": [
        "error",
        { patterns: [moduleInternalAliases] },
      ],
    },
  },
  {
    files: ["src/shared/**/*.{js,jsx,ts,tsx}"],
    rules: {
      "no-restricted-imports": [
        "error",
        {
          patterns: [
            appImports,
            sharedModuleImports,
            sharedInfrastructureImports,
          ],
        },
      ],
    },
  },
  {
    files: ["src/infrastructure/**/*.{js,jsx,ts,tsx}"],
    rules: {
      "no-restricted-imports": [
        "error",
        { patterns: [appImports, moduleInternalAliases] },
      ],
    },
  },
  {
    files: ["src/infrastructure/config/**/*.{js,jsx,ts,tsx}"],
    rules: {
      "no-restricted-properties": "off",
    },
  },
  globalIgnores([".next/**", "out/**", "build/**", "next-env.d.ts"]),
]);
