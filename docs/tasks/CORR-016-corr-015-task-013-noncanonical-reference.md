# CORR-016 — Corrección de la referencia no canónica de TASK-013 en CORR-015

## 1. Identificación

**ID:** `CORR-016`

**Título:** `CORR-016 — Corrección de la referencia no canónica de TASK-013 en CORR-015`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`CORR-016-corr-015-task-013-noncanonical-reference-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-016-corr-015-task-013-noncanonical-reference.md`

**Naturaleza:** exclusivamente documental y de gobernanza.

**Implementación realizada:** `NO`

**Repositorio modificado durante esta preparación:** `NO`

**Supabase Cloud modificado:** `NO`

**Codex utilizado:** `NO`

**Canonicalización realizada:** `NO`

**Git add / commit / push realizados:** `NO / NO / NO`

Estado de aprobación documental:

```text
CORR-016 SPECIFICATION = PASS
CORR-016 SPEC REVIEW = APPROVED
CORR-016 HUMAN APPROVAL = APPROVED

CORR-016 = APPROVED FOR IMPLEMENTATION

CORR-016 determinada = SÍ
CORR-016 generada = SÍ
CORR-016 especificada = SÍ
CORR-016 aprobada = SÍ

CORR-016 canonicalizada = NO
CORR-016 ejecución autorizada = NO
CORR-016 ejecutada = NO
CORR-016 completada = NO
```

`APPROVED FOR IMPLEMENTATION` significa exclusivamente que la especificación documental está aprobada para una futura ejecución y todavía requiere revisión del artefacto aprobado, canonicalización, incorporación Git y autorización humana separada de ejecución. No significa `EXECUTION AUTHORIZED`, `EXECUTED` ni `COMPLETED`.

Este documento especifica una corrección documental futura. No ejecuta CORR-016, no ejecuta CORR-015, no modifica el canon, no crea ni modifica TASK-013 y no determina ni genera TASK-014.

---

## 2. Determinación formal consumida

Se consume como decisión del Revisor Central:

```text
NEXT GOVERNANCE INCREMENT DETERMINATION = APPROVED

CORR-016 DETERMINATION = APPROVED

CORR-016 —
Corrección de la referencia no canónica de TASK-013 en CORR-015
```

La determinación autoriza exclusivamente la generación de esta especificación en estado:

```text
READY FOR REVIEW
```

No autoriza:

- aprobación de CORR-016;
- canonicalización de CORR-016;
- ejecución de CORR-016;
- reanudación automática de CORR-015;
- modificación del repositorio;
- uso de Codex;
- modificación de Supabase Cloud;
- creación, canonicalización o modificación de TASK-013;
- determinación o generación de TASK-014.

---

## 3. Causa raíz confirmada

Durante una ejecución autorizada de CORR-015 se obtuvo legítimamente:

```text
CORR-015 EXECUTION = BLOCKER
```

Blocker exacto:

```text
Fuente canónica obligatoria ausente:
docs/tasks/TASK-013-verification-challenge-foundation.md
```

La ejecución preservó el estado Git:

```text
files modified = 0
worktree = clean
staged = none
untracked = none
NO AUTOREPAIR
```

El blocker fue revisado y confirmado por el Revisor Central.

La causa raíz no es un defecto del repositorio.

TASK-013 no fue canonicalizada legítimamente. Su artefacto histórico permaneció en el lifecycle de especificación bloqueada:

```text
READY FOR REVIEW

TASK-013 SPEC REVIEW = APPROVED AS BLOCKED

TASK-013 SPECIFICATION =
BLOCKER — ARCHITECTURE DECISION REQUIRED
```

La ruta:

`docs/tasks/TASK-013-verification-challenge-foundation.md`

fue únicamente una ruta canónica futura propuesta y nunca fue incorporada legítimamente al canon.

Por tanto, para el estado actual de gobernanza:

```text
ausencia de esa ruta = ESTADO ESPERADO

crear esa ruta para desbloquear CORR-015 = PROHIBIDO

canonicalizar TASK-013 por inferencia = PROHIBIDO
```

La contradicción está dentro de la especificación canónica de CORR-015: trata una ruta inexistente y legítimamente no canonicalizada de TASK-013 como contexto canónico requerido de ejecución y, de forma genérica, convierte la falta de una fuente requerida en `BLOCKER`.

---

## 4. Objetivo único

CORR-016 tiene un único objetivo:

> corregir de forma mínima la especificación canónica de CORR-015 para eliminar la dependencia inválida respecto de una especificación canónica inexistente de TASK-013, permitiendo que una futura ejecución de CORR-015 consuma el estado de gobernanza de TASK-013 sin crear, canonicalizar, modificar ni reconstruir TASK-013.

La regla central es:

```text
corregir referencia no canónica de TASK-013 en CORR-015
!=
crear TASK-013
!=
canonicalizar TASK-013
!=
modificar TASK-013
!=
reescribir su lifecycle histórico
```

CORR-016 no cambia producto, arquitectura, E2, seguridad, multitenancy, RLS ni el alcance documental que CORR-015 aplicará posteriormente sobre los documentos de producto.

---

## 5. Autoridad y fuentes

### 5.1 Fuente afectada principal

La futura ejecución de CORR-016 debe leer íntegramente la especificación canónica vigente de CORR-015:

```text
docs/tasks/CORR-015-adr-0019-accepted-state-sync.md
```

Esta es la única fuente autorizada para modificación.

### 5.2 Fuentes canónicas de preservación

Deben utilizarse read-only para comprobar que la corrección no altera decisiones vigentes:

```text
docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md

docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md

docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

### 5.3 Regla sobre TASK-013

La futura ejecución de CORR-016 no debe exigir la existencia de:

```text
docs/tasks/TASK-013-verification-challenge-foundation.md
```

No debe buscar una copia alternativa para convertirla en canon.

No debe reconstruir TASK-013 desde conversación histórica, artefactos temporales, mensajes previos, memoria, nombres de archivos propuestos ni inferencia.

El estado de TASK-013 necesario para CORR-015 se consume exclusivamente desde:

1. el estado de gobernanza ya fijado dentro de la propia especificación canónica de CORR-015; y
2. las fuentes canónicas existentes que contextualizan ADR-0019, seguridad, multitenancy, RLS y el estado activo de Fase 2.

Debe quedar explícito en CORR-015:

```text
TASK-013 canonical specification required for CORR-015 execution = NO
```

---

## 6. Clasificación documental de CORR-016

### 6.1 `CHANGE REQUIRED`

Debe existir exactamente:

```text
CHANGE REQUIRED = 1
```

Único archivo:

```text
docs/tasks/CORR-015-adr-0019-accepted-state-sync.md
```

No se autoriza ningún segundo archivo.

### 6.2 `NO CHANGE REQUIRED`

Deben permanecer sin modificación, entre otros:

```text
docs/product/03-permissions-rls-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
docs/product/02-domain-model.md

docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

También deben permanecer sin modificación o creación:

```text
TASK-013
TASK-014
```

La ausencia de la ruta futura propuesta de TASK-013 no cambia esta clasificación.

---

## 7. Contradicción exacta que debe corregirse en CORR-015

La especificación de CORR-015 contiene una clasificación de fuentes donde la ruta futura propuesta de TASK-013 aparece dentro de contexto normativo necesario y una regla general posterior ordena detener la ejecución si una fuente requerida falta o no es canónica.

Esa combinación hace que:

```text
docs/tasks/TASK-013-verification-challenge-foundation.md
```

se comporte materialmente como una fuente canónica obligatoria, aunque TASK-013 nunca fue canonicalizada.

La corrección no debe debilitar el principio general de que las fuentes realmente canónicas y obligatorias deben existir y ser coherentes.

Debe corregir exclusivamente la clasificación particular de TASK-013 para que:

```text
TASK-013 canonical specification required for CORR-015 execution = NO
```

Y:

```text
absence of:
docs/tasks/TASK-013-verification-challenge-foundation.md

= EXPECTED
= NOT A BLOCKER
```

La conversación histórica continúa sin sustituir el canon.

---

## 8. Cambio semántico autorizado en CORR-015

La futura ejecución de CORR-016 debe aplicar una edición mínima y coherente de CORR-015 que satisfaga simultáneamente todas las reglas siguientes.

### 8.1 Fuentes de verdad

La ruta:

```text
docs/tasks/TASK-013-verification-challenge-foundation.md
```

no puede permanecer clasificada ni interpretarse como fuente canónica obligatoria de la ejecución de CORR-015.

Las fuentes obligatorias reales y existentes de ADR-0019 y de los tres documentos de producto candidatos permanecen obligatorias.

### 8.2 Ausencia esperada

Debe quedar explícito:

```text
absence of:
docs/tasks/TASK-013-verification-challenge-foundation.md

= EXPECTED
= NOT A BLOCKER
```

La ausencia no autoriza crear el archivo.

### 8.3 No canonicalización previa

Debe quedar explícito:

```text
TASK-013 canonical specification required for CORR-015 execution = NO
```

CORR-015 no puede exigir como precondición la canonicalización previa de TASK-013.

### 8.4 Prohibición de reconstrucción

Debe preservarse y reforzarse la regla:

```text
historical conversation != canonical source
```

CORR-015 no puede reconstruir, regenerar ni inferir la especificación de TASK-013 desde conversación histórica o artefactos no canónicos.

### 8.5 Prohibiciones obligatorias

Debe quedar explícito:

```text
CORR-015
MUST NOT create TASK-013 canonical specification
MUST NOT canonicalize TASK-013
MUST NOT modify TASK-013
```

### 8.6 Estado de gobernanza consumido

CORR-015 puede consumir el estado de TASK-013 ya fijado dentro de su propia especificación como estado de gobernanza cerrado para esta sincronización documental.

Ese consumo no convierte a TASK-013 en una fuente canónica independiente ni modifica su lifecycle.

### 8.7 Regla general sobre fuentes faltantes

La regla de `BLOCKER` por fuente obligatoria ausente debe seguir aplicando a las fuentes que realmente sean obligatorias y canónicas.

Debe quedar fuera de esa regla únicamente la ruta no canonicalizada de TASK-013.

No se autoriza convertir la corrección en una relajación general de controles de fuente.

---

## 9. Superficies de CORR-015 que pueden requerir ajuste mínimo

La futura ejecución debe auditar el documento completo, pero sólo puede modificar texto materialmente necesario para resolver esta contradicción.

Como mínimo debe revisar y reconciliar las siguientes superficies semánticas de CORR-015:

1. la sección de fuentes de verdad/contexto que enumera TASK-013 como ruta documental;
2. cualquier regla que convierta automáticamente la ausencia de esa ruta en `BLOCKER`;
3. la sección que describe TASK-013 como fuera de scope, para que no presuponga que la ruta canónica existe;
4. cualquier precondición, procedimiento, criterio o Definition of Done cuya lectura material exija releer una especificación canónica de TASK-013 inexistente;
5. cualquier frase que pueda interpretarse como autorización para crear, canonicalizar o reconstruir TASK-013 para poder ejecutar CORR-015.

La auditoría puede concluir que alguna de esas superficies no necesita cambio físico porque ya queda correcta tras corregir la clasificación principal. En ese caso debe permanecer intacta.

No se autoriza reescritura general de CORR-015.

---

## 10. Estado de TASK-013 que debe preservarse

CORR-016 debe preservar semánticamente:

```text
TASK-013 DETERMINATION = APPROVED
TASK-013 determinada = SÍ
TASK-013 generada = SÍ
TASK-013 SPEC REVIEW = APPROVED AS BLOCKED

TASK-013 implementación autorizada = NO
TASK-013 implementada = NO
```

También debe preservarse como resultado histórico de la especificación original:

```text
TASK-013 SPECIFICATION =
BLOCKER — ARCHITECTURE DECISION REQUIRED
```

La aceptación posterior de ADR-0019 resuelve la decisión arquitectónica que faltaba para el futuro, pero no autoriza reescritura retrospectiva del artefacto histórico de TASK-013.

Debe permanecer:

```text
ADR-0019 accepted/canonicalized
!=
TASK-013 corrected
!=
TASK-013 approved for implementation
!=
TASK-013 implemented
```

La ausencia de una especificación canónica de TASK-013 es coherente con ese lifecycle y no debe corregirse mediante autorepair.

---

## 11. Scope de CORR-015 que debe permanecer sin cambio

CORR-016 no modifica el objetivo ni el alcance documental final de CORR-015.

La futura ejecución de CORR-015 debe continuar modificando exclusivamente:

```text
docs/product/03-permissions-rls-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

Debe continuar:

```text
CHANGE REQUIRED = 3
```

Debe continuar:

```text
docs/product/02-domain-model.md = NO CHANGE REQUIRED
```

CORR-016 no cambia:

- el cambio esperado de `03`;
- el cambio esperado de `10`;
- el cambio esperado de `11`;
- la clasificación de `02`;
- el número de archivos que CORR-015 modificará;
- los criterios técnicos o arquitectónicos de esas modificaciones.

Debe quedar semánticamente demostrado:

```text
CORR-015 product scope changed = NO
```

---

## 12. ADR-0019 y E2

Debe preservarse:

```text
ADR-0019 = ACCEPTED
```

Decisión:

```text
E2 — APPLICATION-OWNED VERIFICATION CHALLENGE
+ ONE-TIME SESSION GRANT
+ SERVER-ONLY TECHNICAL PASSWORD BRIDGE
+ CUSTOM ACCESS TOKEN HOOK GATE
```

CORR-016 no puede:

- reabrir ADR-0019;
- cambiar E2;
- reinterpretar E2;
- ampliar E2;
- convertir E2 en implementación;
- autorizar TASK-013 por efecto indirecto.

Debe demostrarse:

```text
ADR-0019 changed = NO
E2 changed = NO
```

---

## 13. Seguridad, multitenancy y RLS

CORR-016 no cambia ningún invariante de seguridad.

Debe permanecer:

```text
tenant = MaintenanceCompany

authenticated != authorized

valid Auth session != tenant authorization

RLS = primary remote isolation boundary para datos tenant-owned

service-role / secret key != ordinary request client

SUPER_ADMIN global != tenant member
```

Debe permanecer:

```text
VerificationChallenge = platform-owned
SessionGrant = platform-owned
```

La corrección de una referencia documental no puede utilizarse para modificar:

- tenant ownership;
- membership;
- roles;
- client scope;
- `SupportAccessGrant`;
- RLS;
- privilegios de `service-role` o secret key;
- `supabase_auth_admin`;
- Auth Admin boundary;
- policies;
- grants físicos;
- schema;
- migrations;
- Supabase Cloud.

Debe demostrarse:

```text
security changed = NO
RLS changed = NO
multitenancy changed = NO
```

---

## 14. TASK-014

Debe permanecer:

```text
TASK-014 determinada = NO
TASK-014 generada = NO
```

CORR-016 no determina, diseña, genera, aprueba ni autoriza TASK-014.

Debe demostrarse:

```text
TASK-014 = NO
```

---

## 15. Fuera de alcance

CORR-016 no incluye ni autoriza:

- implementación de CORR-015;
- implementación de CORR-016 durante esta preparación;
- código;
- TypeScript;
- SQL;
- migrations;
- RLS ejecutable;
- `CREATE POLICY`;
- grants/revokes ejecutables;
- schema físico;
- cambios de Supabase Cloud;
- secrets;
- configuración de Auth Hook;
- technical password implementation;
- `SessionGrant` implementation;
- `VerificationChallenge` implementation;
- creación de archivo de TASK-013;
- canonicalización de TASK-013;
- modificación de TASK-013;
- regeneración o reconstrucción de TASK-013;
- aprobación o autorización de TASK-013;
- modificación de ADR-0019;
- modificación de ADR-0002;
- modificación de ADR-0003;
- cambio de los tres documentos de producto que CORR-015 modificará posteriormente;
- cambio de `02-domain-model.md`;
- determinación o generación de TASK-014;
- nuevo ADR;
- resolución de un `DO-*`;
- resolución de un `*-OPEN-*`;
- Git add;
- commit;
- push.

---

## 16. Precondiciones de una futura ejecución de CORR-016

Antes de ejecutar CORR-016 debe verificarse:

1. CORR-016 fue revisada y aprobada mediante actos humanos posteriores;
2. CORR-016 fue canonicalizada e incorporada a Git mediante Gates separados;
3. existe autorización humana separada para una ejecución concreta de CORR-016;
4. la especificación canónica de CORR-015 existe en:
   `docs/tasks/CORR-015-adr-0019-accepted-state-sync.md`;
5. CORR-015 continúa siendo la corrección documental aprobada cuyo objetivo y scope corresponden a ADR-0019;
6. ADR-0019 continúa `ACCEPTED`;
7. E2 continúa siendo la decisión vigente;
8. TASK-013 continúa sin especificación canónica en la ruta futura propuesta, salvo que un acto humano posterior y legítimo haya cambiado expresamente ese estado;
9. si TASK-013 hubiera sido legítimamente canonicalizada mediante un acto posterior, la ejecución debe detenerse para revisión humana porque la causa y el cambio mínimo de CORR-016 tendrían una baseline distinta;
10. TASK-013 continúa sin autorización de implementación;
11. TASK-014 continúa sin determinar/generar;
12. el repositorio está en estado Git compatible con una corrección documental aislada.

No se debe usar la falta de TASK-013 canónica como blocker cuando el estado continúe siendo el descrito por esta especificación.

---

## 17. Preflight Git futuro obligatorio

La futura ejecución debe realizar un preflight fresco y reportar como mínimo:

```text
git rev-parse --show-toplevel
git branch --show-current
git rev-parse HEAD
git rev-parse --abbrev-ref --symbolic-full-name @{u}
git rev-parse origin/main
git rev-list --left-right --count HEAD...origin/main
git status --short
git status --porcelain=v1 --untracked-files=all
git diff --cached --name-only
```

Debe verificar además que no exista una operación Git en progreso.

El preflight debe confirmar una baseline apta para aislar exactamente un archivo de cambio.

No se autoriza autorepair mediante:

```text
git fetch correctivo por inferencia
git pull
git merge
git rebase
git reset
git restore
git stash
git clean
```

Ante drift material inesperado:

```text
CORR-016 EXECUTION = BLOCKER
```

---

## 18. Auditoría documental read-only previa a edición

Antes de modificar CORR-015, la futura ejecución debe leerlo íntegramente y buscar como mínimo:

```text
TASK-013
docs/tasks/TASK-013-verification-challenge-foundation.md
fuente obligatoria
fuentes obligatorias
contexto normativo
canon
canónica
canonical
conversation
conversación histórica
BLOCKER
precondition
precondición
releer fuentes
CHANGE REQUIRED
NO CHANGE REQUIRED
ADR-0019
E2
TASK-014
```

Cada coincidencia material relacionada con la contradicción debe clasificarse exclusivamente como:

```text
INVALID TASK-013 CANONICAL DEPENDENCY — CHANGE
VALID REQUIRED CANONICAL SOURCE — KEEP
HISTORICAL/GOVERNANCE — KEEP
UNEXPECTED — BLOCKER
```

La auditoría debe demostrar que todas las modificaciones necesarias caben dentro del único archivo autorizado.

Si otro archivo necesita modificación:

```text
CORR-016 EXECUTION = BLOCKER
```

No ampliar scope.

---

## 19. Procedimiento futuro de ejecución

Sólo después de satisfacer precondiciones y preflight:

### Paso 1 — Leer CORR-016 canónica

Consumir esta especificación aprobada sin ampliarla por inferencia.

### Paso 2 — Leer íntegramente CORR-015 canónica

Fuente modificable:

```text
docs/tasks/CORR-015-adr-0019-accepted-state-sync.md
```

### Paso 3 — Revisar fuentes de preservación

Leer read-only ADR-0019, ADR-0002, ADR-0003 y los documentos de producto necesarios para verificar invariantes.

No exigir TASK-013 canónica.

### Paso 4 — Ejecutar la auditoría de §18

Clasificar todas las coincidencias materiales.

### Paso 5 — Confirmar scope

Resultado obligatorio:

```text
CHANGE REQUIRED = 1
```

### Paso 6 — Aplicar la corrección mínima

Modificar exclusivamente CORR-015 para eliminar la dependencia canónica inválida de TASK-013 y añadir las aclaraciones obligatorias de esta especificación.

### Paso 7 — Revisar semántica de TASK-013

Confirmar:

```text
TASK-013 canonicalization required = NO
TASK-013 file creation = NO
TASK-013 modification = NO
```

### Paso 8 — Revisar scope de CORR-015

Confirmar:

```text
CORR-015 CHANGE REQUIRED = 3
CORR-015 product scope changed = NO
02 = NO CHANGE REQUIRED
```

### Paso 9 — Revisar arquitectura y seguridad

Confirmar ADR-0019/E2, seguridad, multitenancy y RLS sin cambios.

### Paso 10 — Ejecutar verificaciones documentales y Git

Ejecutar §22.

### Paso 11 — Revisar íntegramente el diff

El diff completo del único archivo debe ser revisado antes de reportar resultado.

### Paso 12 — Detenerse sin staging

No ejecutar `git add`, commit ni push.

---

## 20. Condiciones `BLOCKER`

La futura ejecución debe terminar en:

```text
CORR-016 EXECUTION = BLOCKER
```

si ocurre cualquiera de las condiciones siguientes:

1. la especificación canónica de CORR-016 no existe, no está aprobada o no coincide materialmente con la ejecución autorizada;
2. la especificación canónica de CORR-015 no existe;
3. CORR-015 presenta una identidad o propósito incompatible con esta corrección;
4. el repositorio real presenta drift material que impide aislar la corrección;
5. existe staging previo incompatible;
6. existe una operación Git en progreso incompatible;
7. corregir la contradicción requiere canonicalizar TASK-013;
8. corregir la contradicción requiere crear la especificación canónica de TASK-013;
9. corregir la contradicción requiere modificar TASK-013;
10. corregir la contradicción requiere reconstruir o inferir TASK-013 desde conversación histórica;
11. corregir la contradicción requiere cambiar ADR-0019;
12. corregir la contradicción requiere cambiar E2;
13. corregir la contradicción requiere modificar ADR-0002;
14. corregir la contradicción requiere modificar ADR-0003;
15. corregir la contradicción requiere modificar un segundo archivo;
16. corregir la contradicción requiere ampliar el scope funcional o documental de CORR-015;
17. corregir la contradicción requiere cambiar los cambios esperados de `03`, `10` o `11`;
18. corregir la contradicción requiere cambiar `02 = NO CHANGE REQUIRED`;
19. corregir la contradicción requiere cambiar requisitos funcionales;
20. corregir la contradicción requiere cambiar seguridad;
21. corregir la contradicción requiere cambiar multitenancy;
22. corregir la contradicción requiere cambiar RLS;
23. corregir la contradicción requiere código;
24. corregir la contradicción requiere SQL;
25. corregir la contradicción requiere migration;
26. corregir la contradicción requiere policy o RLS ejecutable;
27. corregir la contradicción requiere modificar Supabase Cloud;
28. corregir la contradicción requiere determinar o generar TASK-014;
29. la auditoría detecta un `UNEXPECTED — BLOCKER`;
30. el diff contiene más de un archivo;
31. el diff incluye formatting lateral o cambios no relacionados;
32. `git diff --check` resulta FAIL;
33. existe staging al finalizar;
34. cualquier criterio de aceptación de CORR-016 resulta FAIL.

Ante cualquier blocker:

```text
NO AUTOREPAIR
NO SCOPE EXPANSION
NO TASK-013 CREATION
NO TASK-013 CANONICALIZATION
NO TASK-013 MODIFICATION
NO TASK-014
NO STAGING
NO COMMIT
NO PUSH
```

La ejecución debe detenerse y devolver la causa exacta para revisión humana.

---

## 21. Criterios de aceptación

Cada criterio debe evaluarse individualmente durante una futura ejecución.

### Identidad y gobernanza

**AC-016-001** — El identificador es exactamente `CORR-016`.

**AC-016-002** — El título es `Corrección de la referencia no canónica de TASK-013 en CORR-015`.

**AC-016-003** — El tipo permanece `CORRECCIÓN DOCUMENTAL CONTROLADA`.

**AC-016-004** — La especificación de CORR-016 fue aprobada y canonicalizada antes de una ejecución concreta.

**AC-016-005** — Existe autorización humana separada para la ejecución concreta.

### Scope de CORR-016

**AC-016-006** — `CHANGE REQUIRED = 1`.

**AC-016-007** — El único archivo modificable es `docs/tasks/CORR-015-adr-0019-accepted-state-sync.md`.

**AC-016-008** — Ningún documento de producto aparece en el diff de CORR-016.

**AC-016-009** — Ningún ADR aparece en el diff de CORR-016.

**AC-016-010** — TASK-013 no aparece creado ni modificado.

**AC-016-011** — TASK-014 no aparece creado ni modificado.

### Dependencia de TASK-013

**AC-016-012** — CORR-015 deja de tratar `docs/tasks/TASK-013-verification-challenge-foundation.md` como fuente canónica obligatoria de ejecución.

**AC-016-013** — CORR-015 declara `TASK-013 canonical specification required for CORR-015 execution = NO`.

**AC-016-014** — CORR-015 declara que la ausencia de la ruta futura propuesta de TASK-013 es `EXPECTED`.

**AC-016-015** — CORR-015 declara que esa ausencia es `NOT A BLOCKER`.

**AC-016-016** — CORR-015 no requiere canonicalización previa de TASK-013.

**AC-016-017** — CORR-015 no autoriza crear la especificación canónica de TASK-013.

**AC-016-018** — CORR-015 no autoriza canonicalizar TASK-013.

**AC-016-019** — CORR-015 no autoriza modificar TASK-013.

**AC-016-020** — CORR-015 no reconstruye ni infiere TASK-013 desde conversación histórica.

**AC-016-021** — La regla general de `BLOCKER` por fuente obligatoria ausente permanece vigente para las fuentes realmente canónicas y obligatorias.

### Estado histórico de TASK-013

**AC-016-022** — `TASK-013 DETERMINATION = APPROVED` permanece.

**AC-016-023** — `TASK-013 determinada = SÍ` permanece.

**AC-016-024** — `TASK-013 generada = SÍ` permanece.

**AC-016-025** — `TASK-013 SPEC REVIEW = APPROVED AS BLOCKED` permanece.

**AC-016-026** — El resultado histórico `BLOCKER — ARCHITECTURE DECISION REQUIRED` permanece sin reescritura retrospectiva.

**AC-016-027** — `TASK-013 implementación autorizada = NO` permanece.

**AC-016-028** — `TASK-013 implementada = NO` permanece.

### Scope de CORR-015

**AC-016-029** — El objetivo único de CORR-015 no cambia.

**AC-016-030** — `CORR-015 CHANGE REQUIRED = 3` permanece.

**AC-016-031** — `docs/product/03-permissions-rls-strategy.md` permanece `CHANGE REQUIRED` para CORR-015.

**AC-016-032** — `docs/product/10-architecture-decisions-records.md` permanece `CHANGE REQUIRED` para CORR-015.

**AC-016-033** — `docs/product/11-phase-1-scope-entry-gate.md` permanece `CHANGE REQUIRED` para CORR-015.

**AC-016-034** — `docs/product/02-domain-model.md = NO CHANGE REQUIRED` permanece.

**AC-016-035** — El contenido técnico esperado de los cambios de `03`, `10` y `11` no cambia.

**AC-016-036** — `CORR-015 product scope changed = NO` queda demostrado.

### ADR-0019 y seguridad

**AC-016-037** — `ADR-0019 = ACCEPTED` permanece.

**AC-016-038** — E2 permanece sin modificación semántica.

**AC-016-039** — `tenant = MaintenanceCompany` permanece.

**AC-016-040** — `authenticated != authorized` permanece.

**AC-016-041** — `valid Auth session != tenant authorization` permanece.

**AC-016-042** — RLS permanece la frontera primaria de aislamiento remoto para datos tenant-owned.

**AC-016-043** — `service-role / secret key != ordinary request client` permanece.

**AC-016-044** — `SUPER_ADMIN global != tenant member` permanece.

**AC-016-045** — `VerificationChallenge = platform-owned` permanece.

**AC-016-046** — `SessionGrant = platform-owned` permanece.

### No implementación y TASK-014

**AC-016-047** — No se modifica código.

**AC-016-048** — No se escribe SQL.

**AC-016-049** — No se crea ni modifica migration.

**AC-016-050** — No se escribe RLS ejecutable ni policy.

**AC-016-051** — No se modifica Supabase Cloud.

**AC-016-052** — `TASK-014 determinada = NO` permanece.

**AC-016-053** — `TASK-014 generada = NO` permanece.

### Git y calidad documental

**AC-016-054** — Se realiza preflight Git fresco.

**AC-016-055** — La especificación canónica de CORR-015 existe antes de editar.

**AC-016-056** — `git diff --name-only` contiene exactamente un archivo.

**AC-016-057** — El único archivo del diff es `docs/tasks/CORR-015-adr-0019-accepted-state-sync.md`.

**AC-016-058** — `unexpected files = 0`.

**AC-016-059** — Se revisa íntegramente el diff de CORR-015.

**AC-016-060** — `git diff --check = PASS`.

**AC-016-061** — `staged files = none` al finalizar.

**AC-016-062** — No se ejecuta `git add`.

**AC-016-063** — No se realiza commit.

**AC-016-064** — No se realiza push.

### Gate posterior

**AC-016-065** — El cierre de CORR-016 no reanuda automáticamente CORR-015.

**AC-016-066** — Después de CORR-016 se exige retorno al Revisor Central.

**AC-016-067** — Se exige revisión del estado corregido de CORR-015.

**AC-016-068** — Se exige nueva autorización humana separada para reintentar CORR-015.

**AC-016-069** — Se exige nuevo prompt exacto para Codex antes del reintento.

**AC-016-070** — El reintento de CORR-015 comienza desde un preflight fresco.

Un único criterio fallido implica:

```text
CORR-016 EXECUTION = BLOCKER
```

---

## 22. Pruebas documentales y verificaciones de una futura ejecución

La prueba principal de CORR-016 es documental, semántica y negativa.

Debe reportarse como mínimo:

```text
git diff --name-only
git diff --name-status
git diff --stat
git diff --numstat
git diff --check
git status --short
git status --porcelain=v1 --untracked-files=all
git diff --cached --name-only
```

Debe revisarse íntegramente:

```text
git diff --no-ext-diff -- docs/tasks/CORR-015-adr-0019-accepted-state-sync.md
```

Resultado de scope obligatorio:

```text
exactly one file modified
unexpected files = 0
staged files = none
commit = NO
push = NO
```

La auditoría textual post-cambio debe buscar como mínimo:

```text
TASK-013
docs/tasks/TASK-013-verification-challenge-foundation.md
canonical specification required
EXPECTED
NOT A BLOCKER
MUST NOT create
MUST NOT canonicalize
MUST NOT modify
conversation historical
conversación histórica
CHANGE REQUIRED = 3
02-domain-model.md
ADR-0019
E2
authenticated
authorized
RLS
service-role
SUPER_ADMIN
VerificationChallenge
SessionGrant
TASK-014
```

Debe demostrarse semánticamente:

```text
TASK-013 canonicalization required = NO
TASK-013 file creation = NO
TASK-013 modification = NO

CORR-015 product scope changed = NO

ADR-0019 changed = NO
E2 changed = NO
security changed = NO
RLS changed = NO
multitenancy changed = NO

TASK-014 = NO
```

No se requieren tests funcionales de aplicación, porque CORR-016 no modifica código ni comportamiento ejecutable.

Ejecutar tests de aplicación no sustituye la revisión íntegra del diff ni las verificaciones semánticas anteriores.

---

## 23. Cambios físicos esperados en una futura ejecución

Si todas las precondiciones y verificaciones resultan PASS, el diff esperado de CORR-016 queda limitado a:

```text
MODIFY docs/tasks/CORR-015-adr-0019-accepted-state-sync.md
```

Cantidad esperada:

```text
files modified = 1
```

Cualquier archivo adicional:

```text
CORR-016 EXECUTION = BLOCKER
```

La futura ejecución debe terminar con el único cambio `UNSTAGED` para revisión humana.

---

## 24. Definition of Done

La aprobación documental de esta especificación no completa CORR-016.

Deben permanecer separados:

```text
determinación de CORR-016 = APROBADA
especificación de CORR-016 = REALIZADA
SPEC REVIEW = APPROVED
aprobación humana = APPROVED
artefacto aprobado = GENERADO
canonicalización = PENDIENTE
revisión de canonicalización = PENDIENTE
incorporación Git de especificación = PENDIENTE
autorización separada de ejecución = PENDIENTE
ejecución documental = PENDIENTE
revisión humana del diff = PENDIENTE
incorporación Git de ejecución = PENDIENTE
cierre humano final = PENDIENTE
```

### 24.1 Definition of Done de esta aprobación documental

Esta aprobación documental queda correctamente terminada cuando:

- existe `CORR-016-corr-015-task-013-noncanonical-reference-approved.md`;
- su estado es `APPROVED FOR IMPLEMENTATION`;
- `CORR-016 DETERMINATION = APPROVED` queda consumida;
- `CORR-016 SPECIFICATION = PASS`;
- `CORR-016 SPEC REVIEW = APPROVED`;
- `CORR-016 HUMAN APPROVAL = APPROVED`;
- el artefacto aprobado queda generado;
- `CHANGE REQUIRED = 1` y corresponde únicamente a CORR-015 canónica;
- los documentos de producto y ADR permanecen `NO CHANGE REQUIRED`;
- TASK-013 no se crea, canonicaliza ni modifica;
- TASK-014 no se determina ni genera;
- no se implementa CORR-015;
- no se usa Codex;
- no se modifica el repositorio;
- no se modifica Supabase Cloud;
- no se realiza operación Git.

Resultado de esta aprobación documental:

```text
CORR-016 DETERMINATION = APPROVED
CORR-016 SPECIFICATION = PASS
CORR-016 SPEC REVIEW = APPROVED
CORR-016 HUMAN APPROVAL = APPROVED

CORR-016 = APPROVED FOR IMPLEMENTATION

CORR-016 determinada = SÍ
CORR-016 generada = SÍ
CORR-016 especificada = SÍ
CORR-016 aprobada = SÍ
CORR-016 canonicalizada = NO
CORR-016 ejecución autorizada = NO
CORR-016 ejecutada = NO
CORR-016 completada = NO

CHANGE REQUIRED = 1

repositorio modificado = NO
Supabase Cloud modificado = NO
Git modificado = NO
Codex utilizado = NO

TASK-013 canonicalizada por CORR-016 = NO
TASK-013 modificada por CORR-016 = NO

TASK-014 determinada = NO
TASK-014 generada = NO
```

### 24.2 Definition of Done de la futura corrección

CORR-016 sólo podrá considerarse completada después de que:

1. el artefacto aprobado de CORR-016 sea revisado por el Revisor Central;
2. la especificación aprobada sea canonicalizada;
3. la canonicalización sea revisada;
4. la especificación sea incorporada a Git mediante autorizaciones separadas;
5. exista autorización humana separada de ejecución;
6. el preflight Git fresco resulte PASS;
7. CORR-015 canónica sea leída íntegramente;
8. la auditoría confirme que el único archivo que necesita cambio es CORR-015 canónica;
9. se elimine exclusivamente la dependencia canónica inválida de TASK-013;
10. se incorporen las aclaraciones obligatorias de no creación/no canonicalización/no modificación de TASK-013;
11. el scope de CORR-015 permanezca `CHANGE REQUIRED = 3` y `02 = NO CHANGE REQUIRED`;
12. ADR-0019, E2, seguridad, multitenancy y RLS permanezcan intactos;
13. TASK-014 permanezca sin determinar/generar;
14. `git diff --check = PASS`;
15. el full diff de CORR-015 sea revisado íntegramente;
16. no exista staging, commit ni push durante la ejecución documental;
17. el diff sea devuelto al Revisor Central para revisión humana;
18. cualquier incorporación Git de la ejecución ocurra sólo mediante autorizaciones posteriores y separadas;
19. exista cierre humano final de CORR-016.

Permanecen pendientes: revisión del artefacto aprobado, canonicalización, revisión de canonicalización, incorporación Git de la especificación, autorización separada de ejecución, ejecución documental, revisión humana del diff, incorporación Git de la ejecución y cierre humano final.

---

## 25. Gate posterior

El cierre completo de CORR-016 no reanuda CORR-015 automáticamente.

Debe permanecer:

```text
CORR-016 completed
!=
CORR-015 execution automatically resumed
```

La secuencia pendiente debe ocurrir mediante actos separados:

```text
1. artefacto aprobado de CORR-016 generado;
2. revisión del artefacto aprobado por el Revisor Central;
3. canonicalización;
4. revisión de canonicalización;
5. incorporación Git de la especificación mediante autorizaciones separadas;
6. autorización humana separada de ejecución;
7. ejecución documental de CORR-016;
8. revisión humana del diff;
9. incorporación Git de la ejecución mediante autorizaciones separadas;
10. cierre humano final de CORR-016;
11. retorno al Revisor Central;
12. revisión del estado corregido de CORR-015;
13. nueva autorización humana separada para reintentar CORR-015;
14. nuevo prompt exacto para Codex;
15. nuevo preflight fresco de CORR-015.
```

CORR-016 no autoriza la ejecución ni el reintento de CORR-015.

La futura ejecución de CORR-015 deberá comenzar nuevamente desde sus precondiciones y preflight, consumiendo la especificación de CORR-015 ya corregida.

Debe permanecer:

```text
previous CORR-015 execution authorization
!=
authorization to retry CORR-015
```

No debe reutilizarse como autorización implícita la ejecución anterior que terminó en `BLOCKER`.

---

## 26. Resultado de la especificación

La revisión de coherencia de esta preparación determina:

```text
contradicciones materiales bloqueantes detectadas = 0
```

La contradicción puede resolverse dentro de un único archivo y sin modificar producto, arquitectura, seguridad, multitenancy, RLS, ADR-0019, E2, TASK-013 o TASK-014.

Resultado:

```text
CORR-016 DETERMINATION = APPROVED
CORR-016 SPECIFICATION = PASS
CORR-016 SPEC REVIEW = APPROVED
CORR-016 HUMAN APPROVAL = APPROVED

CORR-016 = APPROVED FOR IMPLEMENTATION

CORR-016 determinada = SÍ
CORR-016 generada = SÍ
CORR-016 especificada = SÍ
CORR-016 aprobada = SÍ
CORR-016 canonicalizada = NO
CORR-016 ejecución autorizada = NO
CORR-016 ejecutada = NO
CORR-016 completada = NO

CHANGE REQUIRED = 1
CHANGE REQUIRED:
- docs/tasks/CORR-015-adr-0019-accepted-state-sync.md

NO CHANGE REQUIRED:
- docs/product/03-permissions-rls-strategy.md
- docs/product/10-architecture-decisions-records.md
- docs/product/11-phase-1-scope-entry-gate.md
- docs/product/02-domain-model.md
- docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md
- docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
- docs/architecture/adr/ADR-0003-authorization-client-scope-support.md

CORR-015 EXECUTION = BLOCKED
CORR-015 reanudación autorizada = NO
CORR-015 product scope changed = NO

TASK-013 canonical specification required for CORR-015 execution = NO
TASK-013 canonicalization required for CORR-015 = NO
TASK-013 file creation = NO
TASK-013 creation = NO
TASK-013 canonicalization = NO
TASK-013 modification = NO
TASK-013 implementation authorized = NO

ADR-0019 = ACCEPTED
ADR-0019 changed = NO
E2 changed = NO
security changed = NO
RLS changed = NO
multitenancy changed = NO

TASK-014 determinada = NO
TASK-014 generada = NO

NO IMPLEMENTATION
NO CODE
NO SQL
NO MIGRATION
NO RLS EXECUTABLE
NO SUPABASE CLOUD CHANGE
NO CODEX
NO CANONICALIZATION
NO GIT ADD
NO COMMIT
NO PUSH
```

`CORR-016 SPECIFICATION = PASS` permanece como resultado de especificación, y `CORR-016 SPEC REVIEW = APPROVED` junto con `CORR-016 HUMAN APPROVAL = APPROVED` registran que la revisión y la aprobación humana ya ocurrieron.

`APPROVED FOR IMPLEMENTATION` no significa canonicalización, autorización de ejecución, ejecución ni cierre.

---

## 27. Entrega

**Archivo generado:**

```text
CORR-016-corr-015-task-013-noncanonical-reference-approved.md
```

**Ruta canónica futura propuesta:**

```text
docs/tasks/CORR-016-corr-015-task-013-noncanonical-reference.md
```

**Estado:**

```text
APPROVED FOR IMPLEMENTATION
```

La especificación superó `CORR-016 SPEC REVIEW = APPROVED` y `CORR-016 HUMAN APPROVAL = APPROVED`. El artefacto aprobado fue generado; su revisión, canonicalización e incorporación Git permanecen pendientes y requieren actos separados.

No se implementó CORR-016.

No se ejecutó CORR-015.

No se utilizó Codex.

No se modificó el repositorio.

No se modificó Supabase Cloud.

No se creó, canonicalizó ni modificó TASK-013.

No se determinó ni generó TASK-014.

No se realizó `git add`, commit ni push.
