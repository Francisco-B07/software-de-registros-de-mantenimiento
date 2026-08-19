# CORR-004 — Sincronizar estado canónico y autorización externa de TASK-007

# 1. ID

```
CORR-004
```

# 2. Título

```
Sincronizar estado canónico y autorización externa de TASK-007
```

# 3. Tipo

```
CORRECCIÓN DOCUMENTAL DE CONSISTENCIA
```

Esta corrección resuelve exclusivamente una contradicción de estado y autoridad dentro de la especificación canónica de:

```
TASK-007 — Smoke test y revisión integral de Fase 1
```

No modifica ningún requisito técnico, funcional, arquitectónico, de seguridad, Supabase, CI, Gate, aceptación o ejecución de `TASK-007`.

# 4. Estado

```
READY FOR REVIEW
```

**Archivo de entrega propuesto:**

```
CORR-004-task-007-canonical-execution-state.md
```

**Ruta canónica futura propuesta:**

```
docs/tasks/CORR-004-task-007-canonical-execution-state.md
```

Este documento no está aprobado todavía y no autoriza su propia implementación.
No autoriza:

- modificar `TASK-007`;
- ejecutar Codex;
- reintentar `TASK-007`;
- hacer commit;
- hacer push;
- declarar `TASK-007 = DONE`;
- declarar Fase 1 completada;
- avanzar al Paso 9;
- resolver `DO-T03`;
- redactar o modificar `ADR-0003`;
- iniciar Fase 2.

---

# 5. Objetivo

Corregir exclusivamente la metadata y las frases de estado de:

```
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
```

que todavía describen a `TASK-007` como una especificación:

- pendiente de revisión;
- no canónica;
- no aprobada para ejecución.

La redacción final debe reflejar correctamente que:

1. `TASK-007` ya fue revisada humanamente;
2. `TASK-007` ya fue canonicalizada;
3. su ruta canónica es:

    `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`;


4. el canonical commit de referencia de esa canonicalización es:

    `5bde25d96fa73537ebc912115f53c55be8366db9`;


5. el estado documental de la especificación pasa a:

    `APPROVED FOR EXECUTION`;


6. ese estado significa que la especificación está aprobada como contrato que **puede ser ejecutado**;
7. la mera existencia, aprobación o canonicalización de la especificación **NO inicia ni autoriza por sí sola una ejecución concreta**;
8. cada ejecución concreta requiere una autorización humana separada y explícita;
9. una autorización humana externa posterior puede autorizar una ejecución concreta sin entrar en contradicción con la especificación canónica.

La corrección debe eliminar la contradicción de autoridad que provocó correctamente el `BLOCKER` en la primera ejecución autorizada de `TASK-007`.

---

# 6. Contexto

## 6.1 Estado externo verificado

Antes de la primera ejecución autorizada de `TASK-007` se verificó externamente:

- revisión humana de la especificación: realizada;
- aprobación para canonicalización: realizada;
- canonicalización: realizada;
- ruta:

   `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`;


- canonical commit:

   `5bde25d96fa73537ebc912115f53c55be8366db9`;


- push a `origin/main`: realizado;
- `HEAD = main = origin/main`;
- divergencia: `0 0`;
- worktree: limpio.

Posteriormente se emitió una autorización humana separada y explícita para ejecutar `TASK-007` mediante Codex.

## 6.2 Resultado de la primera ejecución

La primera ejecución autorizada terminó correctamente en:

```
BLOCKER
```

Codex aplicó la regla de autoridad definida por `TASK-007` y detectó que la propia especificación canónica todavía declaraba internamente:

- `READY FOR REVIEW`;
- que no era canónica;
- que dicho estado no autorizaba ejecución;
- que la estrategia de ejecución seguía perteneciendo a un documento `READY FOR REVIEW`;
- y, al cierre, que la especificación continuaba `READY FOR REVIEW`.

Por tanto, existía una contradicción entre:

- el estado externo real y la autorización humana separada;

y:

- la metadata normativa contenida dentro de la fuente canónica que Codex debía obedecer.

Detenerse antes del preflight técnico fue el comportamiento correcto.

## 6.3 Naturaleza de la corrección

La contradicción es exclusivamente:

```
documental / metadata / autoridad de ejecución
```

No es una contradicción:

- técnica;
- de producto;
- arquitectónica;
- de seguridad;
- de Supabase;
- de CI;
- de Gate;
- de pruebas;
- de criterios de aceptación;
- de Definition of Done.

`CORR-004` no debe utilizarse para modificar ninguna otra parte de `TASK-007`.

---

# 7. Tres conceptos que deben quedar separados

La corrección debe distinguir inequívocamente tres estados diferentes.

## A. Especificación revisada y canonicalizada

Significa que:

- el documento fue revisado humanamente;
- su contenido fue aceptado para incorporación canónica;
- existe en su ruta canónica;
- forma parte de la documentación normativa del repositorio.

Para `TASK-007` este estado ya se encuentra satisfecho.

## B. Especificación aprobada para poder ser ejecutada

Significa que:

- su contenido constituye un contrato de ejecución aprobado;
- no requiere una nueva revisión conceptual antes de poder ser utilizado;
- puede ser ejecutado cuando exista una autorización humana concreta.

El estado documental que expresará esta condición será:

```
APPROVED FOR EXECUTION
```

Este estado **NO equivale** a afirmar que una ejecución concreta esté ocurriendo.

## C. Ejecución concreta autorizada

Es un acto humano externo y separado mediante el cual se ordena ejecutar una instancia concreta de `TASK-007`.
La autorización concreta:

- no debe almacenarse permanentemente como si toda futura ejecución estuviera autorizada;
- no deriva automáticamente de `APPROVED FOR EXECUTION`;
- debe existir antes de cada ejecución;
- puede ocurrir posteriormente mediante una instrucción humana explícita;
- no contradice a la TASK canónica cuando ésta declara correctamente que está `APPROVED FOR EXECUTION`.

La relación correcta es:
`A + B`
 → especificación canónica utilizable
pero:
`A + B`
 ≠ ejecución concreta iniciada
Para ejecutar se requiere además:

```
C = autorización humana separada
```

Por tanto:
`A + B + C`
 → una ejecución concreta puede comenzar conforme a `TASK-007`.

---

# 8. Fuente afectada

La única fuente que `CORR-004` autoriza modificar en una implementación futura es:

```
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
```

Archivos versionados esperados modificados por la futura implementación de `CORR-004`:

```
1
```

No debe modificarse ningún otro archivo.

---

# 9. Canonical commit de referencia

Debe incorporarse a la metadata de `TASK-007`:

```
5bde25d96fa73537ebc912115f53c55be8366db9
```

con la denominación:

```
Canonical commit de referencia
```

Este SHA representa el commit de referencia de la canonicalización de `TASK-007` previa a `CORR-004`.
La futura implementación de `CORR-004`, si es aprobada, producirá naturalmente un commit posterior que contendrá la corrección documental.
`CORR-004`:

- no reescribe;
- no sustituye;
- no modifica;

el commit histórico:

```
5bde25d96fa73537ebc912115f53c55be8366db9
```

La referencia se conserva como trazabilidad de la primera canonicalización formal de `TASK-007`.

---

# 10. Alcance exacto

`CORR-004` autoriza exclusivamente modificar los siguientes bloques o frases de `TASK-007`:

1. metadata de `# 4. Estado`;
2. primera frase de `# 5. Objetivo`;
3. frase final de `## 6.6 Reconciliación de las fuentes antes faltantes`;
4. introducción de `# 7. Fuentes canónicas`;
5. redacción de `## 15.1 Decisión`;
6. metadata final del documento.

No se autoriza modificar ninguna otra sección.

---

# 11. Cambios exactos requeridos

## 11.1 `# 4. Estado`

### Texto actual

\# 4. Estado

\`READY FOR REVIEW\`

\*\*Archivo de entrega:\*\*

\`TASK-007-phase-1-smoke-docs-review\.md\`

\*\*Ruta canónica futura propuesta:\*\*

\`docs/tasks/TASK-007-phase-1-smoke-docs-review\.md\`

Este documento no es canónico todavía.

Su estado \`READY FOR REVIEW\` no autoriza ejecución, uso de Codex, modificación del repositorio ni avance de fase.

Texto final obligatorio 

\# 4. Estado

\`APPROVED FOR EXECUTION\`

\*\*Archivo de entrega:\*\*

\`TASK-007-phase-1-smoke-docs-review\.md\`

\*\*Ruta canónica:\*\*

\`docs/tasks/TASK-007-phase-1-smoke-docs-review\.md\`

\*\*Canonical commit de referencia:\*\*

\`5bde25d96fa73537ebc912115f53c55be8366db9\`

Este documento fue revisado y canonicalizado en la ruta y commit de referencia indicados.

El estado \`APPROVED FOR EXECUTION\` significa que la especificación está aprobada para poder ser ejecutada cuando exista una autorización humana separada y explícita para una ejecución concreta.

La especificación canónica por sí sola no inicia una ejecución, no constituye una autorización concreta de uso de Codex y no modifica el repositorio.

Cada ejecución concreta de \`TASK-007\` requiere una autorización humana separada. Una autorización humana externa posterior puede autorizar esa ejecución sin contradecir esta especificación.

No debe modificarse ningún texto anterior o posterior a este bloque como consecuencia de este cambio.

---

## 11.2 `# 5. Objetivo`

Debe modificarse únicamente la primera frase del objetivo.

### Texto actual

Ejecutar, una vez que esta especificación sea revisada, aprobada y canonicalizada, el \`Paso 8 — Smoke, documentación y revisión de Fase 1\` definido por el Gate canónico, mediante una validación integral, reproducible y no destructiva del estado real del repositorio.

Texto final obligatorio 

Ejecutar, cuando una ejecución concreta de esta especificación ya revisada, aprobada y canonicalizada haya sido autorizada de forma humana, separada y explícita, el \`Paso 8 — Smoke, documentación y revisión de Fase 1\` definido por el Gate canónico, mediante una validación integral, reproducible y no destructiva del estado real del repositorio.

No debe modificarse el resto de `# 5. Objetivo`.

---

## 11.3 `## 6.6 Reconciliación de las fuentes antes faltantes`

Debe modificarse únicamente la frase final.

### Texto actual

No se detecta una contradicción material entre estas tres fuentes que impida corregir \`TASK-007\` y mantenerla en estado \`READY FOR REVIEW\`.

### Texto final obligatorio

No se detecta una contradicción material entre estas tres fuentes; esta reconciliación forma parte de la especificación canónica de \`TASK-007\` aprobada para ejecución.
No debe modificarse ningún otro contenido de `§6.6`.

---

## 11.4 `# 7. Fuentes canónicas`

Debe modificarse únicamente la frase introductoria inmediatamente posterior al heading.

### Texto actual

Cuando \`TASK-007\` sea revisada y posteriormente ejecutada, deben leerse íntegramente desde el repositorio real, como mínimo, las siguientes fuentes.

### Texto final obligatorio

En cada ejecución concreta de \`TASK-007\` autorizada humanamente de forma separada, deben leerse íntegramente desde el repositorio real, como mínimo, las siguientes fuentes.
La lista de fuentes y todo el resto de la sección deben permanecer exactamente sin cambios.

---

## 11.5 `## 15.1 Decisión`

### Texto actual

La estrategia recomendada para una futura ejecución aprobada es:

\`Codex en modo inspección/verificación local + pasos humanos de evidencia remota + revisión humana final\`

No se autoriza esa ejecución mediante este documento \`READY FOR REVIEW\`.

### Texto final obligatorio

La estrategia recomendada para una ejecución concreta de \`TASK-007\` que haya recibido autorización humana separada es:

\`Codex en modo inspección/verificación local + pasos humanos de evidencia remota + revisión humana final\`

El estado \`APPROVED FOR EXECUTION\` de esta especificación no inicia ni autoriza por sí solo una ejecución concreta. Cada ejecución requiere una autorización humana separada y explícita. Cuando esa autorización externa exista, la ejecución es compatible con esta especificación y debe respetar íntegramente sus límites.
No debe modificarse `§15.2`, `§15.3` ni ninguna otra regla de ejecución.
En particular, debe permanecer intacta la regla existente que limita a Codex a inspección/verificación y prohíbe modificar archivos versionados.

---

## 11.6 Metadata final del documento

Debe reemplazarse únicamente el bloque final de metadata.

### Texto actual

\*\*Estado de esta especificación:\*\* \`READY FOR REVIEW\`

\*\*Ejecución autorizada por esta entrega:\*\* no.

\*\*Codex ejecutado durante esta entrega:\*\* no.

\*\*Repositorio modificado durante esta entrega:\*\* no.

\*\*Fase 1 declarada completada:\*\* no.

\*\*Fase 2 iniciada:\*\* no.

### Texto final obligatorio

\*\*Estado de esta especificación:\*\* \`APPROVED FOR EXECUTION\`

\*\*Documento canónico:\*\* sí.

\*\*Ruta canónica:\*\* \`docs/tasks/TASK-007-phase-1-smoke-docs-review\.md\`

\*\*Canonical commit de referencia:\*\* \`5bde25d96fa73537ebc912115f53c55be8366db9\`

\*\*Esta especificación inicia o autoriza por sí sola una ejecución concreta:\*\* no.

\*\*Cada ejecución concreta requiere autorización humana separada:\*\* sí.

\*\*Codex ejecutado por la mera aprobación/canonicalización de esta especificación:\*\* no.

\*\*Repositorio modificado por la mera aprobación/canonicalización de esta especificación:\*\* no.

\*\*Fase 1 declarada completada:\*\* no.

\*\*Fase 2 iniciada:\*\* no.
No deben añadirse declaraciones que indiquen que una ejecución concreta está actualmente autorizada.
La autorización concreta pertenece siempre a la instrucción humana externa.

---

# 12. Fragmentos que NO deben cambiar

`CORR-004` prohíbe expresamente modificar cualquier otro contenido de `TASK-007`.
Deben permanecer intactos, entre otros:

- ID;
- título;
- tipo:

   `VALIDATION / REVIEW TASK`;


- objetivo técnico, salvo la primera frase indicada;
- contexto operativo;
- baseline técnico;
- relación con `463c908`;
- orden de Fase 1;
- alcance del Paso 8;
- exclusión del Paso 9;
- estrategia Supabase vigente;
- baseline CI;
- fuentes canónicas listadas;
- precondiciones de ejecución;
- stop conditions;
- reglas de secretos;
- comandos Git;
- comandos Node/npm;
- `npm ci`;
- lint;
- typecheck;
- test;
- build;
- verify;
- `tsc --showConfig`;
- `npx supabase --version`;
- smoke mediante `npm run start`;
- revisión estructural;
- aliases;
- boundaries;
- configuración de entorno;
- reglas de `.env*.local`;
- reglas Supabase;
- prohibición de Docker;
- prohibición de operaciones Supabase remotas;
- CI;
- SHA de Actions;
- evidencia remota de `TASK-006`;
- auditoría documental;
- matriz de las doce condiciones del Gate;
- estados permitidos de cada fila;
- Gate separado hacia Fase 2;
- archivos modificables durante una ejecución de `TASK-007`:

   `0`;


- alcance;
- fuera de alcance;
- restricciones;
- seguridad;
- RLS;
- criterios de aceptación;
- Definition of Done;
- resultados globales;
- precedencia:

   `BLOCKER`
   `>`
   `REQUIRES CORRECTION`
   `>`
   `FAIL`
   `>`
   `PASS`;


- reporte esperado;
- Gate posterior.

---

# 13. Criterio 81 y revisión humana final

Debe permanecer exactamente intacto el criterio de aceptación:

```
81. revisión humana final del informe realizada
```

`CORR-004` no modifica:

- su texto;
- su orden;
- su significado;
- su obligatoriedad.

En consecuencia:

```
PASS
```

continúa requiriendo que la revisión humana final del informe ya haya sido realizada.
La modificación del estado documental de:

```
READY FOR REVIEW
```

a:

```
APPROVED FOR EXECUTION
```

no debe interpretarse como sustitución, adelanto o satisfacción automática del criterio 81.
Los conceptos son independientes:

- revisión/aprobación de la **especificación**;
- autorización humana de una **ejecución concreta**;
- revisión humana final del **informe producido por esa ejecución**.

Los tres controles deben mantenerse separados.

---

# 14. PASS y resultados globales

`CORR-004` no modifica en absoluto la clasificación de resultados de `TASK-007`.
Continúan siendo exclusivamente:

- `PASS`;
- `FAIL`;
- `BLOCKER`;
- `REQUIRES CORRECTION`.

Continúa aplicándose la precedencia canónica existente:

1. `BLOCKER`;
2. `REQUIRES CORRECTION`;
3. `FAIL`;
4. `PASS`.

`PASS` continúa permitido únicamente cuando se satisfacen todos los criterios de aceptación aplicables, incluyendo:

```
revisión humana final del informe realizada
```

`CORR-004` no convierte la aprobación documental de `TASK-007` en un `PASS`.

---

# 15. Primera ejecución bloqueada

La primera ejecución autorizada de `TASK-007` que terminó en:

```
BLOCKER
```

debe conservarse como hecho histórico válido.
`CORR-004`:

- no reescribe ese resultado;
- no lo convierte retroactivamente en `PASS`;
- no declara que Codex actuó incorrectamente;
- no considera que el preflight técnico haya sido ejecutado si no lo fue;
- no autoriza continuar desde el punto donde se detuvo.

La primera ejecución demostró precisamente el funcionamiento correcto de la regla de autoridad.
Después de que `CORR-004` sea eventualmente:

1. revisada;
2. aprobada;
3. implementada;
4. verificada;
5. canonicalizada;

cualquier nuevo intento de `TASK-007` deberá considerarse:

```
una nueva ejecución concreta
```

y requerirá:
`una nueva autorización humana separada y explícita`.
`CORR-004` no proporciona esa autorización.

---

# 16. Archivos y cambios esperados

## 16.1 Único archivo modificable

En una futura implementación aprobada de `CORR-004`, el único archivo versionado autorizado para modificación será:

```
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
```

## 16.2 Cantidad esperada

Archivos versionados modificados:

```
1
```

## 16.3 Naturaleza del cambio

Únicamente:

- metadata;
- estado documental;
- canonicalización;
- distinción entre aprobación de especificación y autorización de ejecución.

No se esperan cambios en:

- código;
- dependencias;
- lockfile;
- configuración;
- CI;
- Supabase;
- SQL;
- schema;
- tests;
- scripts;
- ADR;
- Gate de producto.

---

# 17. Fuera de alcance

Queda expresamente fuera de `CORR-004`:

- rediseñar `TASK-007`;
- resumir `TASK-007`;
- refactorizar su redacción;
- mejorar estilo;
- reorganizar secciones;
- corregir cualquier tema no relacionado con el blocker descrito;
- modificar un requisito técnico;
- modificar un requisito funcional;
- modificar seguridad;
- modificar semántica de secretos;
- modificar Supabase;
- modificar CI;
- modificar Actions o SHA;
- modificar comandos;
- modificar smoke;
- modificar el Gate;
- añadir o eliminar una condición de Gate;
- modificar criterios de aceptación;
- modificar el criterio 81;
- modificar DoD;
- modificar la precedencia de resultados;
- modificar el reporte esperado;
- modificar el Gate posterior;
- ejecutar `TASK-007`;
- reintentar `TASK-007`;
- declarar `TASK-007 = DONE`;
- declarar Fase 1 completada;
- iniciar o generar el Paso 9;
- resolver `DO-T03`;
- redactar o modificar `ADR-0003`;
- iniciar Fase 2.

---

# 18. Seguridad

Impacto de seguridad:

```
NINGÚN CAMBIO DE MODELO DE SEGURIDAD
```

`CORR-004` no modifica las reglas de seguridad de `TASK-007`.
Deben preservarse íntegramente:

- archivos sensibles locales pueden contener secretos si están correctamente ignorados/no trackeados;
- no deben leerse ni imprimirse valores secretos locales;
- exposición o gestión incorrecta de secretos continúa siendo `BLOCKER`;
- `service-role` no puede incorporarse al contrato de aplicación;
- Codex no recibe credenciales Supabase;
- Codex no recibe GitHub PAT;
- CI no recibe secretos no aprobados;
- no se ejecutan operaciones Supabase Cloud autenticadas;
- no se amplían permisos.

La corrección de estado:

```
READY FOR REVIEW → APPROVED FOR EXECUTION
```

no concede credenciales ni permisos adicionales.

---

# 19. RLS y multitenancy

Impacto RLS:

```
NO APLICA — CORRECCIÓN DOCUMENTAL
```

No se modifica:

- schema;
- migrations;
- RLS;
- tenancy;
- Auth;
- roles;
- datos tenant-owned.

`ADR-0002` y las futuras obligaciones de aislamiento permanecen intactas.

---

# 20. Supabase

`CORR-004` no modifica ninguna regla Supabase.
Debe permanecer exactamente vigente:

- Supabase Cloud Development;
- Supabase CLI reproducible;
- `supabase/config.toml`;
- operación remota manual humana;
- Codex sin credenciales;
- sin Docker obligatorio;
- sin schema funcional;
- sin migrations funcionales;
- sin `db push` de Fase 1;
- sin Auth;
- sin tenancy;
- sin RLS ejecutable;
- sin Staging;
- sin Production.

---

# 21. CI

`CORR-004` no modifica ninguna regla de CI.
Debe permanecer intacto todo el baseline de `TASK-006` consumido por `TASK-007`.
No se modifica:

- `.github/workflows/ci.yml`;
- eventos;
- runner;
- Node;
- npm;
- `npm ci`;
- lint;
- typecheck;
- test;
- build;
- timeout;
- cache;
- permisos;
- SHA de Actions;
- secretos;
- deployment;
- evidencia remota.

---

# 22. Fases, DO-T03 y ADR-0003

Después de `CORR-004` debe continuar siendo cierto:

- Fase 1: no declarada completada por esta corrección;
- Paso 9: no generado ni iniciado;
- `DO-T03`: no resuelto por esta corrección;
- `ADR-0003`: no redactado ni modificado;
- Fase 2: `NO INICIADA`.

`CORR-004` resuelve únicamente el blocker documental que impide que una futura autorización humana de ejecución de `TASK-007` sea coherente con su fuente canónica.
No resuelve ninguna condición de entrada a Fase 2.

---

# 23. ADR requerido

**Decisión:**

```
NO
```

## Justificación

La corrección no introduce una decisión arquitectónica.
No modifica:

- arquitectura de aplicación;
- datos;
- multitenancy;
- RLS;
- offline;
- sincronización;
- CI;
- Supabase;
- seguridad;
- fases.

Corrige únicamente el estado documental y el modelo de autorización externa de una tarea de validación ya definida.
No se requiere ADR nuevo.

---

# 24. Precondiciones para una futura implementación de CORR-004

Antes de modificar `TASK-007`, el ejecutor futuro deberá:

1. confirmar que `CORR-004` fue revisada y formalmente aprobada;
2. confirmar que existe una autorización humana separada para ejecutar `CORR-004`;
3. verificar repositorio Git válido;
4. verificar branch;
5. verificar `HEAD`;
6. verificar upstream;
7. verificar divergencia;
8. exigir worktree limpio;
9. confirmar que:

    `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`

    existe y está trackeado;


10. confirmar que contiene todavía los fragmentos actuales enumerados en `§11`;
11. confirmar que no existe una corrección posterior que ya haya resuelto el mismo blocker;
12. comprobar que el canonical commit:

```
5bde25d96fa73537ebc912115f53c55be8366db9
```

existe en la historia;

13. detenerse con `BLOCKER` si el contenido real difiere materialmente de los fragmentos sobre los cuales fue aprobada `CORR-004`.

No debe utilizarse búsqueda/reemplazo amplio sin verificar contexto.

---

# 25. Instrucciones de implementación futura

Si `CORR-004` es posteriormente aprobada y su ejecución es autorizada, Codex deberá:

1. leer íntegramente esta corrección;
2. leer íntegramente la `TASK-007` canónica;
3. realizar el preflight;
4. modificar únicamente:

    `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`;


5. aplicar exactamente los reemplazos de `§11`;
6. no realizar ningún otro cambio;
7. no reformatear el documento;
8. no normalizar espacios fuera de los bloques afectados;
9. no reorganizar headings;
10. no corregir otras frases;
11. verificar después que no permanezcan declaraciones activas que describan a la especificación como:
    - `READY FOR REVIEW`;
    - no canónica;
    - pendiente de aprobación/canonicalización;
    - incompatible con una autorización humana externa de ejecución;
12. verificar que no haya quedado ninguna frase que afirme permanentemente que una ejecución concreta está autorizada;
13. verificar que `APPROVED FOR EXECUTION` se interprete sólo como estado de la especificación;
14. verificar que continúe existiendo la exigencia de autorización humana separada por ejecución;
15. verificar que el criterio 81 permanezca intacto;
16. verificar que ninguna otra línea haya cambiado.

---

# 26. Verificaciones obligatorias

Después de una futura implementación deberán realizarse verificaciones textuales y Git.

## 26.1 Estado

Debe existir:

```
APPROVED FOR EXECUTION
```

en los lugares exactos definidos por esta corrección.
Las declaraciones activas de estado de la propia `TASK-007` no deben continuar afirmando:

```
READY FOR REVIEW
```

## 26.2 Canonicalización

Debe quedar presente:

```
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
```

como:

```
Ruta canónica
```

y debe quedar presente:

```
5bde25d96fa73537ebc912115f53c55be8366db9
```

como:

```
Canonical commit de referencia
```

## 26.3 Autorización

Debe quedar inequívoco que:

- `APPROVED FOR EXECUTION` es estado de especificación;
- no inicia una ejecución;
- no constituye por sí solo autorización concreta;
- cada ejecución requiere autorización humana separada;
- una autorización humana posterior es compatible con la TASK canónica.

## 26.4 Contenido protegido

Debe confirmarse que permanecen sin cambios:

- `VALIDATION / REVIEW TASK`;
- archivos versionados modificables durante ejecución de TASK-007 = `0`;
- criterio 81;
- resultados globales;
- precedencia;
- Gate;
- seguridad;
- Supabase;
- CI;
- comandos;
- DoD;
- reporte;
- Gate posterior.

## 26.5 Diff

El diff de la futura implementación deberá mostrar cambios exclusivamente en los bloques autorizados de `§11`.
Si aparece cualquier otro cambio:

```
BLOCKER
```

hasta entender y eliminar el cambio no autorizado antes de incorporar la corrección.

---

# 27. Criterios de aceptación

`CORR-004` sólo puede considerarse correctamente implementada si:

1. el único archivo versionado modificado es:

    `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`;


2. `# 4. Estado` pasa exactamente a:

    `APPROVED FOR EXECUTION`;


3. la ruta deja de denominarse futura/propuesta y queda como:

    `Ruta canónica`;


4. la ruta es exactamente:

    `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`;


5. se incorpora exactamente como canonical commit de referencia:

    `5bde25d96fa73537ebc912115f53c55be8366db9`;


6. desaparece la afirmación activa:

    `Este documento no es canónico todavía`;


7. desaparece la asociación:

    `READY FOR REVIEW` → prohibición permanente de ejecución;


8. el objetivo deja de presentar revisión/aprobación/canonicalización como pasos futuros no realizados;
9. `§6.6` deja de indicar que `TASK-007` debe mantenerse `READY FOR REVIEW`;
10. la introducción de fuentes deja de hablar de una futura revisión pendiente;
11. `§15.1` deja de afirmar que se trata de un documento `READY FOR REVIEW`;
12. `§15.1` distingue estado de especificación de autorización de ejecución concreta;
13. la metadata final declara:

`APPROVED FOR EXECUTION`;

14. queda explícito que el documento es canónico;
15. queda explícito que la especificación no inicia ni autoriza por sí sola una ejecución concreta;
16. queda explícito que cada ejecución requiere autorización humana separada;
17. no existe ninguna afirmación de que toda futura ejecución esté ya autorizada;
18. `TASK-007` continúa siendo:

`VALIDATION / REVIEW TASK`;

19. una ejecución de `TASK-007` continúa permitiendo modificar:

```
0
```

archivos versionados;

20. no cambia ningún comando;
21. no cambia ningún check;
22. no cambia el smoke;
23. no cambia seguridad;
24. no cambia Supabase;
25. no cambia CI;
26. no cambia la matriz de doce condiciones;
27. no cambia ningún requisito de Gate;
28. no cambia ningún criterio de aceptación salvo las frases de metadata expresamente autorizadas —y en particular el criterio 81 permanece idéntico;
29. el criterio:

```
81. revisión humana final del informe realizada
```

permanece exactamente intacto;

30. `PASS` continúa requiriendo revisión humana final del informe;
31. no cambia Definition of Done;
32. no cambia la precedencia:

`BLOCKER > REQUIRES CORRECTION > FAIL > PASS`;

33. no se declara `TASK-007 = DONE`;
34. no se declara Fase 1 completada;
35. no se genera ni inicia Paso 9;
36. `DO-T03` no se resuelve;
37. `ADR-0003` no se redacta ni modifica;
38. Fase 2 no se inicia;
39. el diff contiene únicamente los cambios autorizados;
40. worktree final queda coherente con la futura incorporación controlada de la corrección.

---

# 28. Definition of Done

`CORR-004` sólo podrá declararse `DONE` después de que:

- esta especificación haya sido revisada y aprobada;
- su implementación haya sido autorizada separadamente;
- el preflight haya pasado;
- el contenido canónico real de `TASK-007` haya coincidido con el baseline esperado;
- se hayan aplicado exclusivamente los cambios exactos de `§11`;
- no haya modificaciones fuera de alcance;
- se haya verificado el diff;
- el criterio 81 permanezca intacto;
- todos los requisitos técnicos y funcionales de `TASK-007` permanezcan intactos;
- se haya verificado la distinción A/B/C;
- la corrección haya sido revisada humanamente;
- la incorporación canónica de la corrección haya sido autorizada y realizada mediante el flujo normal del proyecto.

Completar `CORR-004`:

- NO ejecuta `TASK-007`;
- NO reintenta `TASK-007`;
- NO convierte el `BLOCKER` anterior en otro resultado;
- NO declara `TASK-007 = DONE`;
- NO declara Fase 1 completada;
- NO inicia Paso 9;
- NO resuelve `DO-T03`;
- NO redacta `ADR-0003`;
- NO inicia Fase 2.

---

# 29. Gate posterior

Si `CORR-004` es posteriormente:

- revisada;
- aprobada;
- implementada;
- verificada;
- incorporada canónicamente;

el único efecto habilitante será eliminar la contradicción documental que impidió la primera ejecución.
Después de ello:

1. `TASK-007` seguirá siendo una especificación `APPROVED FOR EXECUTION`;
2. no existirá una ejecución automáticamente activa;
3. el `BLOCKER` de la primera ejecución permanecerá como resultado histórico de ese intento;
4. para reintentar `TASK-007` deberá emitirse una **nueva autorización humana separada y explícita**;
5. esa nueva ejecución deberá comenzar nuevamente conforme a las precondiciones y reglas canónicas de `TASK-007`;
6. el resultado de esa nueva ejecución deberá determinarse desde cero conforme a la evidencia obtenida y a la precedencia vigente.

No debe generarse automáticamente ningún prompt de reintento, ninguna tarea posterior ni ningún trabajo del Paso 9 como parte de `CORR-004`.

---

# 30. Declaraciones finales

**Estado de CORR-004:** `READY FOR REVIEW`
**Implementación de CORR-004 autorizada por esta especificación:** no.
**CORR-004 ejecutada:** no.
**Codex ejecutado:** no.
**Repositorio modificado:** no.
**TASK-007 reintentada:** no.
**TASK-007 declarada DONE:** no.
**Fase 1 declarada completada:** no.
**Paso 9 generado o iniciado:** no.
**DO-T03 resuelto:** no.
**ADR-0003 redactado o modificado:** no.
**Fase 2 iniciada:** no.