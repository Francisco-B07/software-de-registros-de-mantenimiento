# Modular skeleton

This non-normative note describes the minimal internal structure established by
TASK-003. The Next.js `app/` directory remains the routing, layout, metadata, and
composition boundary; code under `src/` must not depend on it.

## Containers

- `modules/` is reserved for future product capabilities. Modules are created
  only when an approved task introduces real behavior.
- `shared/` is reserved for genuinely cross-cutting, domain-neutral code with no
  clear module owner. It must not depend on `app/`, modules, or common
  infrastructure, and it is not a default home for generic helpers.
- `infrastructure/` is reserved for technical infrastructure genuinely shared
  by more than one module. It may depend on neutral shared code, but not on
  `app/` or the internals of a module. Module-specific adapters remain with their
  owning module.

## Growth rules

The structure is module-first. A future `src/modules/<module>/` creates only the
layers justified by real code at that time; no module or layer is pre-created.
When those responsibilities exist, the conceptual direction is:

- domain may depend on its own domain and neutral shared code;
- application may depend on domain and neutral shared code;
- infrastructure may depend on application, domain, shared code, and necessary
  common infrastructure;
- presentation may depend on application, strictly necessary domain types, and
  permitted shared code, but not directly on infrastructure adapters;
- `app/` composes the module through its public surface.

A real module exposes a small public surface, preferably
`src/modules/<module>/index.ts`, only when external consumers need one.
Cross-module consumers import that surface; deep imports into another module are
prohibited. Circular dependencies are also prohibited. Relative imports remain
appropriate inside one coherent module or subtree.

The explicit aliases are:

- `@modules/*` for `src/modules/*`;
- `@shared/*` for `src/shared/*`;
- `@infrastructure/*` for `src/infrastructure/*`.

## Environment configuration

`src/infrastructure/config/` owns future access to application environment
variables. The only versioned list of application variables is the root
`.env.example`; this README describes the policy without duplicating that list.
No application-specific environment variables are currently required.

Each future variable must be classified when introduced:

- public or private server-side;
- secret or non-secret;
- required or optional;
- available during build, server runtime, or both;
- applicable environments and technical owner.

Public configuration must be deliberately non-secret and safe to bundle. It
uses `NEXT_PUBLIC_*` when browser access is required and never grants
authorization or determines tenancy. Private configuration remains server-side,
does not use the public prefix, and must not be reexported through a client-safe
surface. Public and private entrypoints remain separate; no mixed barrel is
allowed.

A required value must be validated before use and fail with an error that names
the variable without revealing its value. An optional value keeps an honest
type that represents absence. Availability during build and runtime must be
declared independently from public/private exposure. No validation object,
parser, or entrypoint is created until a real variable requires it.

Application code reads `process.env` only inside
`src/infrastructure/config/`. Explicit framework or tooling configuration may
retain a direct technical access when genuinely required. Next.js-managed
`.env*` files remain at the project root, and local variants stay unversioned.

ESLint enforces the robust static import/export patterns available today:
`src` to `app`, `shared` to modules or common infrastructure, common
infrastructure to `app`, modular deep imports through `@modules`, and modular
access through the unsupported general `@/src/modules` form. This is
proportional enforcement, not exhaustive graph analysis: dynamic imports,
every possible future relative cross-module path, and circular dependencies
still require architectural review and module-specific enforcement as real
modules are introduced.
