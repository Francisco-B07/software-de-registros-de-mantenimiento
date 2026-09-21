# CORR-029 — TASK-018 Post-Auth Pending-Profile Destination Decision

## 1. Identificación

**ID:** `CORR-029`

**Título:** `CORR-029 — TASK-018 Post-Auth Pending-Profile Destination Decision`

**Tipo:** `DOCUMENTATION CORRECTION / LOCAL ROUTING DECISION`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Auth`

**Estado de esta especificación:** `APPROVED`

**Archivo de entrega:**

`CORR-029-task-018-post-auth-pending-profile-destination-approved.md`

**Target documental primario previsto:**

`docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md`

**Canonical SHA-256 de TASK-018 consumido del estado autoritativo recibido:**

`dfee6ffcece624472cdac83dfa3444e5fc9b98d9f6661d1f2ec7bee0a135c992`

Esta especificación es exclusivamente documental.

No constituye implementación.

No autoriza Codex.

No modifica el repositorio.

No modifica Supabase Cloud.

No autoriza Hosted Development.

No determina `TASK-019`.

No autoriza `Work Item E`.

### 1.1 Formalización documental de aprobación

Se registra formalmente:

```text
CORR-029 SPEC REVIEW =
APPROVED

CORR-029 HUMAN SPEC APPROVAL =
APPROVED
```

Esta aprobación documental preserva íntegramente la especificación técnica aprobada y no constituye ejecución ni enmienda de TASK-018.

En particular:

```text
CORR-029 approval
!=
TASK-018 amended
!=
TASK-018 WORK ITEM D unblocked
!=
TASK-018 WORK ITEM D implementation authorized
!=
WORK ITEM E authorized
!=
Hosted Development authorized
!=
TASK-019 determined
```

---

## 2. Estado de gobernanza consumido

Se consume como estado autoritativo:

```text
TASK-018 canonical =
docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md

TASK-018 canonical SHA-256 =
dfee6ffcece624472cdac83dfa3444e5fc9b98d9f6661d1f2ec7bee0a135c992

WORK ITEM A =
DONE / APPROVED

WORK ITEM B =
DONE / APPROVED

WORK ITEM C =
DONE / APPROVED

WORK ITEM D =
BLOCKER — APPROVED POST-AUTH SUCCESS DESTINATION UNAVAILABLE

WORK ITEM D BLOCKER REVIEW =
APPROVED

WORK ITEM E =
NOT AUTHORIZED

Hosted Development =
NOT AUTHORIZED

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED
```

La generación de CORR-029 no modifica estos estados.

En particular:

```text
CORR-029 specification generated
!=
CORR-029 approved
!=
TASK-018 amended
!=
WORK ITEM D unblocked
!=
WORK ITEM D implementation authorized
```

---

## 3. Objetivo único

CORR-029 resuelve exclusivamente la decisión documental faltante sobre el destino visible posterior a un resultado exitoso de establecimiento/reconciliación de sesión de `TASK-018 Work Item D`.

Debe fijar:

1. un pathname exacto;
2. la semántica exacta de ese pathname;
3. el contenido máximo permitido de la pantalla mínima;
4. las interpretaciones expresamente prohibidas;
5. la convergencia visible de `SESSION_ESTABLISHED` y `SESSION_ALREADY_ESTABLISHED`;
6. la relación con el futuro flujo de completado de perfil;
7. la corrección documental mínima necesaria sobre TASK-018;
8. el Gate exacto para poder reanudar Work Item D.

CORR-029 no implementa el destino.

---

## 4. Problema que corrige

TASK-018 Work Item D requiere conceptualmente:

```text
success
→
pending-profile navigation
```

pero no existe un pathname aprobado.

La inspección física del repositorio recibida para este Gate confirmó que `app/` contiene únicamente:

```text
app/globals.css
app/layout.tsx
app/page.tsx
```

y que:

```text
app/page.tsx
=
Next.js bootstrap OK
```

No existen actualmente:

- first-admin UI routes;
- verification form;
- Server Action;
- Route Handler;
- post-auth success route;
- pending-profile route;
- profile route;
- dashboard aprobado para este flow.

Por tanto, Work Item D no puede elegir una ruta durante implementación sin crear una decisión de producto/UI-routing por inferencia.

El blocker aprobado es correcto:

```text
TASK-018 WORK ITEM D =
BLOCKER — APPROVED POST-AUTH SUCCESS DESTINATION UNAVAILABLE
```

---

## 5. Fuentes canónicas y autoridad

### 5.1 Producto

Se preservan como fuentes normativas:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/product/04-offline-sync-strategy.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`.

### 5.2 Arquitectura

Se preservan:

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`;
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`;
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`.

### 5.3 Foundations previas relevantes

Se preservan, dentro de su alcance:

- `docs/tasks/TASK-009-identity-tenant-foundation.md`;
- `docs/tasks/TASK-010-audit-event-foundation.md`;
- `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`;
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`;
- `docs/tasks/TASK-013-verification-challenge-foundation.md`;
- `docs/tasks/CORR-018-task-013-closure-state-sync.md`;
- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`;
- `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`;
- `docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md`.

### 5.4 Evidencia física/repositorio consumida

CORR-029 consume como evidencia aprobada la inspección read-only recibida para este Gate:

```text
app/ contains only:
- app/globals.css
- app/layout.tsx
- app/page.tsx

app/page.tsx:
- Next.js bootstrap OK

post-auth success destination:
- absent
```

CORR-029 no reejecuta inspección del repositorio y no sustituye el preflight fresco obligatorio de una futura ejecución autorizada.

### 5.5 Disponibilidad física de TASK-018 durante esta redacción

La identidad canónica, SHA-256, estado de Work Items, blocker aprobado y superficies afectadas de TASK-018 se consumen del contexto autoritativo entregado para CORR-029.

El Revisor Central ha verificado además el shape físico canónico de `AC-018-084..090`.

Debe consumirse como estado conocido:

```text
canonical AC shape =
KNOWN

original semantics =
PRESERVED

routing integration =
MINIMAL EXTENSION
```

Esta generación no modifica ni reconstruye el archivo canónico TASK-018.

Antes de ejecutar una futura corrección documental sobre TASK-018 deberá verificarse desde sus bytes físicos reales que el target continúa siendo exactamente el artefacto canónico autorizado o una revisión posterior expresamente aprobada.

Si el SHA ya no coincide por una modificación aprobada posterior:

```text
CORR-029 EXECUTION =
BLOCKER — CANONICAL TARGET DRIFT
```

hasta reconciliar la nueva fuente.

---

## 6. Producto ya decidido — no reabrir RF-012

La baseline normativa establece:

```text
RF-012 =
el primer COMPANY_ADMIN debe ingresar utilizando correo y código válido
y completar su perfil
```

y `FL-01` fija la secuencia conceptual:

```text
SUPER_ADMIN crea empresa
→ empresa activa
→ correo primer COMPANY_ADMIN
→ código
→ ingreso correo+código
→ completa perfil
→ queda habilitado para administrar empresa
```

CORR-029 no modifica esta secuencia.

La única conclusión válida para el punto inmediatamente posterior al establecimiento de la sesión de TASK-018 es:

```text
post-Auth next functional state =
PROFILE COMPLETION PENDING
```

Por tanto:

```text
Auth session established
!=
RF-012 complete
```

y:

```text
Auth session established
!=
COMPANY_ADMIN tenant authority ready
```

---

## 7. Invariantes que CORR-029 debe preservar

### 7.1 Autenticación no equivale a autorización

Debe permanecer:

```text
authenticated != authorized
```

Una sesión Supabase Auth válida no prueba por sí misma:

- `PlatformUser` persistido;
- perfil persistido;
- `CompanyMembership`;
- membership habilitada;
- tenant efectivo;
- role tenant;
- client scope;
- autoridad `COMPANY_ADMIN`;
- finalización del onboarding;
- acceso a dashboard.

### 7.2 Tenant

Debe permanecer:

```text
tenant = MaintenanceCompany
```

y el navegador no puede seleccionar ni afirmar autoritativamente el tenant efectivo.

### 7.3 RLS

RLS continúa siendo la frontera primaria para datos tenant-owned.

CORR-029 no añade datos tenant-owned, no cambia schema y no cambia RLS.

### 7.4 Frontera E2 / ADR-0019

Debe permanecer:

```text
intentId = locator, not bearer
```

y:

```text
trusted post-verification handoff = server-internal
```

También debe permanecer:

- technical password exclusivamente server-side;
- `SessionGrant` no bearer en browser;
- browser sin credenciales privilegiadas;
- browser sin access/refresh token JSON;
- no provider details;
- no account enumeration;
- no tenant enumeration.

---

## 8. Criterios de evaluación de pathname

Las alternativas se comparan exclusivamente por:

1. coherencia con RF-012;
2. claridad semántica;
3. ausencia de falsa autoridad tenant;
4. compatibilidad con futuro profile form;
5. mínima deuda/migración futura;
6. coherencia con estructura modular;
7. no confusión con dashboard;
8. no confusión con onboarding completo.

No se utiliza preferencia estética.

No se infiere una ruta a partir de frameworks, convenciones genéricas o gusto personal.

---

## 9. Alternativas evaluadas

### 9.1 `/onboarding/profile`

**Coherencia con RF-012:** alta.

La ruta puede representar razonablemente un paso de completado de perfil posterior al ingreso.

**Claridad semántica:** media-alta.

`profile` expresa el objeto inmediato, pero `onboarding` introduce un concepto más amplio que el slice actual.

**Ausencia de falsa autoridad tenant:** compatible si la UI mantiene la semántica negativa exigida.

**Compatibilidad con futuro profile form:** alta.

El futuro formulario podría vivir en el mismo pathname.

**Deuda/migración futura:** media.

Existe riesgo de que `onboarding` sea interpretado posteriormente como un flujo multi-step completo o como la totalidad del alta, cuando CORR-029 sólo resuelve el estado de perfil pendiente.

**Coherencia modular:** compatible con App Router y monolito modular.

**Confusión con dashboard:** baja.

**Confusión con onboarding completo:** mayor que las otras alternativas.

Conclusión:

```text
TECHNICALLY VALID
BUT
SEMANTICALLY BROADER THAN REQUIRED
```

No se selecciona porque el término `onboarding` amplía la semántica más allá del único estado que debe fijar CORR-029.

---

### 9.2 `/profile`

**Coherencia con RF-012:** compatible pero insuficientemente específica.

**Claridad semántica:** baja para este estado.

`/profile` puede significar:

- perfil ya existente;
- pantalla general de cuenta;
- edición posterior de datos personales;
- configuración de un usuario ya plenamente habilitado.

**Ausencia de falsa autoridad tenant:** no la crea por sí sola, pero su genericidad no comunica el estado pending.

**Compatibilidad con futuro profile form:** alta en sentido técnico.

**Deuda/migración futura:** media-alta.

Reservar `/profile` para un estado transitorio puede colisionar con una futura pantalla estable de perfil/configuración del usuario.

**Coherencia modular:** compatible.

**Confusión con dashboard:** baja.

**Confusión con onboarding completo:** baja, pero a costa de perder la semántica de pendiente.

Conclusión:

```text
TECHNICALLY VALID
BUT
SEMANTICALLY AMBIGUOUS
AND
LIKELY TO COLLIDE WITH A FUTURE GENERAL PROFILE SURFACE
```

No se selecciona.

---

### 9.3 `/pending-profile`

**Coherencia con RF-012:** alta.

Expresa directamente que el siguiente estado funcional es completar el perfil.

**Claridad semántica:** alta.

El pathname nombra el estado exacto que TASK-018 necesita representar:

```text
session established
+
profile completion pending
```

**Ausencia de falsa autoridad tenant:** alta.

No contiene conceptos como `admin`, `company`, `tenant` o `dashboard`.

**Compatibilidad con futuro profile form:** alta.

El placeholder de TASK-018 puede ser reemplazado por el futuro formulario de completado de perfil sin cambiar necesariamente el pathname.

**Deuda/migración futura:** baja.

La ruta queda dedicada al estado transitorio de perfil pendiente y no consume la ruta genérica `/profile`.

**Coherencia modular:** compatible con Next.js App Router y con la arquitectura modular existente. El pathname no obliga una estructura física de módulos ni una route group concreta.

**Confusión con dashboard:** mínima.

**Confusión con onboarding completo:** mínima.

Conclusión:

```text
NARROWEST SEMANTIC MATCH
WITH
LOWEST UNAPPROVED IMPLICATIONS
```

---

### 9.4 Alternativas adicionales

La evidencia canónica y física disponible no justifica otro pathname concreto.

En particular, no se introduce por inferencia:

- `/setup/profile`;
- `/first-admin/profile`;
- `/company/profile`;
- `/admin/profile`;
- `/dashboard/profile`;
- cualquier pathname con tenant/company/admin authority implícita.

Por tanto, el conjunto mínimo evaluado permanece limitado a las tres alternativas exigidas.

---

## 10. Decisión propuesta para aprobación humana

CORR-029 propone aprobar:

```text
POST_AUTH_PENDING_PROFILE_PATHNAME =
/pending-profile
```

El pathname exacto es:

```text
/pending-profile
```

No forma parte de la decisión:

- nombre de route group;
- ubicación física exacta bajo `app/`;
- layout;
- componente concreto;
- Server Component vs Client Component;
- redirect status HTTP;
- Server Action vs Route Handler;
- guard de ruta futuro;
- estructura del futuro formulario.

Esas decisiones sólo podrán fijarse cuando una tarea autorizada necesite implementarlas y cuando el canon vigente lo permita.

---

## 11. Semántica exacta del destino

`/pending-profile` significa exclusivamente:

```text
Supabase Auth session established
+
first-admin profile completion pending
```

La pantalla representa el siguiente estado funcional esperado de RF-012 después del establecimiento exitoso de sesión.

No representa un estado de autorización tenant.

No constituye una fuente de verdad de identidad de aplicación.

No constituye persistencia.

No constituye onboarding completo.

---

## 12. Lo que `/pending-profile` NO significa

Llegar o renderizar `/pending-profile` NO significa:

```text
PlatformUser created
```

NO significa:

```text
PlatformUser profile persisted
```

NO significa:

```text
CompanyMembership created
```

NO significa:

```text
CompanyMembership enabled
```

NO significa:

```text
COMPANY_ADMIN authority granted
```

NO significa:

```text
first-admin onboarding completed
```

NO significa:

```text
RF-012 complete
```

NO significa:

```text
RF-004 complete
```

NO significa:

```text
tenant authorization ready
```

NO significa:

```text
dashboard access authorized
```

NO significa que la pantalla sea evidencia autoritativa de sesión o autorización.

El estado visible de la UI no puede utilizarse como control de seguridad.

---

## 13. Contrato exacto de navegación de éxito

Los únicos outcomes relevantes para esta corrección son:

```text
SESSION_ESTABLISHED
SESSION_ALREADY_ESTABLISHED
```

Ambos deben converger exactamente en:

```text
/pending-profile
```

Regla:

```text
SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

Debe preservarse:

```text
visible destination for both outcomes = identical
```

La UI no puede revelar cuál de los dos outcomes internos ocurrió.

CORR-029 no fija el status code de redirect.

CORR-029 sólo fija:

- el pathname visible final;
- la uniformidad visible;
- la ausencia de metadata diferenciadora.

---

## 14. Success uniformity y no enumeración

La UI de `/pending-profile` no puede distinguir ni revelar:

- new Auth user;
- existing reconciled Auth user;
- duplicate provider identity;
- response-loss recovery;
- si el Auth user fue creado durante el intento actual;
- si el Auth user ya existía;
- si hubo reconciliación interna;
- si hubo retry;
- si hubo recovery de una respuesta perdida.

No se permiten variantes de copy, banners, query params o mensajes que expongan estas diferencias.

Debe preservarse:

```text
same logical success class
→
same visible destination
→
same visible minimal shell
```

---

## 15. URL visible permitida

La navegación aprobada debe utilizar el pathname:

```text
/pending-profile
```

No necesita ni debe introducir para este flujo parámetros visibles como:

- `intentId`;
- email;
- `maintenanceCompanyId`;
- tenant;
- role;
- Auth user id;
- `PlatformUser` id;
- `CompanyMembership` id;
- grant id;
- challenge id;
- provider status;
- access token;
- refresh token;
- technical password;
- reconciliation outcome.

Para CORR-029, el destino visible se considera:

```text
/pending-profile
```

sin que query params o fragmentos sean necesarios para transportar autoridad.

Si una implementación futura concluyera que necesita transportar uno de esos valores por browser para completar Work Item D:

```text
TASK-018 WORK ITEM D =
BLOCKER
```

hasta revisión explícita de la frontera de seguridad.

---

## 16. UI mínima permitida en TASK-018

TASK-018 puede materializar únicamente una shell/placeholder mínima.

La pantalla puede comunicar de forma genérica:

- sesión iniciada/establecida;
- configuración de perfil pendiente;
- que el próximo paso funcional será completar el perfil cuando ese flujo exista.

Copy conceptual permitido, no literal ni obligatorio:

```text
Sesión establecida.
La configuración de tu perfil está pendiente.
```

La implementación no debe convertir este ejemplo en requisito textual exacto salvo decisión posterior de UX.

La shell puede incluir:

- heading genérico;
- texto informativo breve;
- estructura visual mínima coherente con el bootstrap existente.

No debe requerir datos tenant para renderizar su significado básico.

---

## 17. UI y capacidades expresamente fuera de TASK-018

`/pending-profile` no debe implementar:

- formulario de perfil;
- persistencia de perfil;
- nombres;
- apellidos;
- teléfono;
- avatar;
- campos adicionales de perfil;
- validaciones de esos campos;
- `PlatformUser` profile mutation;
- `CompanyMembership`;
- alta de membership;
- habilitación de membership;
- autoridad tenant;
- selección de tenant;
- client scope;
- dashboard;
- navegación funcional posterior no aprobada;
- autorización de rutas de aplicación;
- menú tenant;
- sidebar tenant;
- logout nuevo salvo que ya exista explícitamente aprobado en otra fuente;
- SQL;
- migration;
- RLS;
- AuditEvent nuevo;
- Hosted Development;
- offline;
- Work Item E.

---

## 18. Relación con el futuro profile-completion flow

`/pending-profile` se define como superficie estable compatible con el futuro flujo de completado de perfil.

La evolución esperada puede ser:

```text
TASK-018:
session success
→ /pending-profile
→ minimal placeholder

future approved profile-completion work:
session success
→ /pending-profile
→ real profile completion UI
→ profile persisted
→ later authorization/onboarding transition according to its own approved contract
```

CORR-029 sólo aprueba el primer tramo.

No aprueba:

- qué campos tendrá el perfil;
- dónde se persiste;
- cuándo nace `PlatformUser` si aún no existe;
- cuándo nace o se habilita `CompanyMembership`;
- qué evento habilita autoridad tenant;
- qué ruta sigue después de completar perfil;
- qué dashboard existe;
- qué guard protege rutas futuras.

El futuro flujo puede reutilizar `/pending-profile` sin migración de pathname.

Esa compatibilidad es una razón para preferir esta ruta, pero no autoriza anticipar el formulario.

---

## 19. Acceso directo al pathname

La existencia de `/pending-profile` no constituye por sí misma un control de autorización.

CORR-029 no introduce un route guard nuevo porque route authorization está fuera de alcance.

Por tanto:

```text
rendering /pending-profile
!=
proof of valid session
!=
proof of tenant authority
```

Una navegación directa al pathname nunca puede crear:

- sesión;
- `PlatformUser`;
- membership;
- tenant authority;
- grant;
- profile persistence.

La futura política de acceso/redirect para navegación directa deberá definirse únicamente cuando exista una tarea autorizada para route authorization o para el profile-completion flow.

TASK-018 no debe inventarla.

---

## 20. Seguridad

### 20.1 Locator no bearer

Debe preservarse:

```text
intentId = locator, not bearer
```

La navegación hacia `/pending-profile` no convierte `intentId` en authority.

### 20.2 Handoff confiable

Debe preservarse:

```text
trusted post-verification handoff = server-internal
```

La navegación de éxito no puede trasladar al browser secretos o material de autorización interna para “continuar” el flujo.

### 20.3 Technical password

Debe permanecer:

```text
technical password =
server-only
```

No aparece:

- en URL;
- HTML;
- props serializadas;
- JavaScript;
- logs browser;
- localStorage;
- sessionStorage;
- IndexedDB;
- error messages.

### 20.4 Tokens

No se permite devolver ni serializar como payload de navegación:

- access token;
- refresh token;
- provider session JSON.

La integración de sesión debe seguir la boundary SSR ya aprobada.

### 20.5 Provider details

No se muestran detalles capaces de revelar:

- creación vs reconciliación;
- provider identity existente;
- duplicate identity;
- recovery interno;
- grant lifecycle;
- hook result.

### 20.6 Enumeración

Los resultados visibles de éxito no pueden permitir account enumeration ni tenant enumeration.

### 20.7 Autoridad

Debe permanecer:

```text
Auth session != tenant authority
```

y:

```text
current authoritative authorization state
>
browser state
```

---

## 21. Multitenancy y RLS

### 21.1 Impacto de multitenancy

CORR-029 no cambia el modelo de tenancy.

Debe permanecer:

```text
MaintenanceCompany = tenant
```

`/pending-profile` no contiene el tenant en el pathname y no deriva autoridad a partir de un tenant enviado por browser.

### 21.2 Datos tenant-owned

La shell mínima no necesita introducir lectura ni escritura de datos tenant-owned.

### 21.3 RLS

```text
RLS change required = NO
```

CORR-029 no:

- crea tabla;
- añade columna;
- cambia policy;
- crea helper RLS;
- crea RPC;
- crea `SECURITY DEFINER`;
- modifica ownership.

Si Work Item D necesitara un cambio RLS para implementar únicamente el placeholder y la navegación:

```text
WORK ITEM D =
BLOCKER — SCOPE EXPANSION REQUIRED
```

---

## 22. Offline

TASK-018 continúa:

```text
ONLINE-ONLY
```

CORR-029 no introduce:

- Dexie;
- IndexedDB;
- Service Worker queue;
- outbox;
- offline Auth provisioning;
- offline profile completion;
- background continuation;
- offline session establishment.

La ruta `/pending-profile` no convierte el flujo de Auth en una capacidad offline.

---

## 23. ADR requerido

Evaluación:

```text
new ADR required = NO
```

Motivos:

1. la arquitectura App Router ya está aprobada;
2. la arquitectura de monolito modular ya está aprobada;
3. no se cambia una frontera transversal;
4. no se modifica Auth E2;
5. no se modifica multitenancy;
6. no se modifica RLS;
7. no se modifica el modelo de dominio;
8. no se introduce un nuevo patrón de seguridad;
9. el pathname es una decisión local y reversible;
10. el placeholder es un detalle acotado de navegación/UI.

La decisión cumple la clasificación de decisión técnica local que no requiere ADR.

Si durante revisión se pretendiera utilizar CORR-029 para definir un onboarding framework transversal, un sistema general de route guards o una state machine global de onboarding, esa ampliación quedaría fuera de esta corrección y requeriría nueva determinación.

---

## 24. Documentos afectados

### 24.1 Target primario

Debe modificarse exclusivamente, para cerrar este blocker:

```text
docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md
```

La corrección debe ser mínima y localizada.

### 24.2 `docs/product/01-product-definition.md`

Evaluación:

```text
UPDATE REQUIRED = NO
```

Justificación:

- RF-012 ya exige ingreso con correo+código y completado de perfil;
- FL-01 ya separa ingreso, completado de perfil y posterior habilitación administrativa;
- CORR-029 no cambia esa secuencia;
- CORR-029 sólo elige una representación de routing para el estado ya aprobado.

Modificar producto para registrar `/pending-profile` elevaría innecesariamente un pathname local a requisito normativo de producto.

### 24.3 `docs/product/02-domain-model.md`

```text
UPDATE REQUIRED = NO
```

No se crea una entidad de dominio nueva.

`pending-profile` es estado de navegación/UI del flujo, no una nueva entidad persistente.

### 24.4 `docs/product/03-permissions-rls-strategy.md`

```text
UPDATE REQUIRED = NO
```

No cambia autorización ni RLS.

### 24.5 ADR

```text
ADR UPDATE REQUIRED = NO
NEW ADR REQUIRED = NO
```

---

## 25. Superficies exactas de TASK-018 que deben corregirse/complementarse

La futura ejecución documental de CORR-029 debe modificar sólo las superficies de TASK-018 que hoy dependen de un destino no concretado.

### 25.1 Work Item D

Work Item D debe fijar expresamente:

```text
POST_AUTH_SUCCESS_DESTINATION =
/pending-profile
```

y:

```text
SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

Debe fijar además que la route destino implementada por Work Item D es únicamente una shell mínima.

### 25.2 Sección de flujo/navegación de Work Item D

Toda formulación genérica equivalente a:

```text
success / pending-profile navigation
```

debe complementarse para indicar el pathname exacto:

```text
/pending-profile
```

No deben alterarse las ramas de error ni otros outcomes salvo que sea estrictamente necesario para evitar una contradicción directa.

### 25.3 Sección UI de Work Item D

Debe añadirse la frontera:

```text
minimal pending-profile shell only
```

con las prohibiciones de §§16–17 de CORR-029.

### 25.4 AC-018-084..090

El bloque canónico `AC-018-084..090` debe preservar íntegramente su shape y sus semánticas ya aprobadas.

La integración de routing de CORR-029 se limita exclusivamente a extender `AC-018-085` para fijar que:

```text
SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

con el mismo resultado visible y sin diferenciación visible.

Debe permanecer:

```text
AC-018-084 =
UNCHANGED

AC-018-085 =
ORIGINAL SEMANTICS PRESERVED
+
MINIMAL ROUTING EXTENSION

AC-018-086..090 =
UNCHANGED
```

No se renumera ningún AC.

No se crea un rango AC nuevo.

Las restantes obligaciones de pathname, semántica de `/pending-profile`, shell mínima, seguridad y ausencia de authority transport permanecen normativas en Work Item D, navegación, UI, tests y DoD sin remapear este rango.

### 25.5 Testing de Work Item D

La sección de pruebas de Work Item D debe incluir:

- pathname exacto;
- uniformidad entre ambos outcomes;
- ausencia de metadata diferenciadora;
- shell mínima;
- no exposición de secretos/tokens;
- ausencia de profile form y tenant authority.

### 25.6 Definition of Done de Work Item D

El DoD debe exigir que:

- `/pending-profile` exista;
- sea destino uniforme para ambos success outcomes;
- no implemente capacidades posteriores;
- las pruebas requeridas pasen.

### 25.7 Gate / stop condition de Work Item D

El blocker:

```text
APPROVED POST-AUTH SUCCESS DESTINATION UNAVAILABLE
```

sólo puede cerrarse después de que CORR-029 sea:

1. revisada;
2. aprobada humanamente;
3. canonicalizada;
4. incorporada al repositorio mediante Gate separado;
5. ejecutada documentalmente sobre TASK-018;
6. revisada la corrección resultante.

Hasta entonces Work Item D permanece bloqueado.

---

## 26. Integración mínima con AC-018-084..090

El shape físico canónico de `AC-018-084..090` es conocido y fue revisado por el Revisor Central.

CORR-029 no remapea este rango.

La regla obligatoria es:

```text
canonical AC shape =
KNOWN

original semantics =
PRESERVED

routing integration =
MINIMAL EXTENSION
```

### AC-018-084 — semántica original preservada

Debe permanecer íntegramente la obligación canónica:

```text
UI post-verification ofrece pending/loading
sin depender de double-submit prevention para seguridad
```

Resultado:

```text
AC-018-084 original semantics preserved =
YES
```

No recibe extensión de routing.

### AC-018-085 — semántica original preservada + extensión mínima de routing

Debe permanecer íntegramente la obligación canónica:

```text
Success visible no diferencia
"Auth user creado"
de
"Auth user reconciliado"
```

CORR-029 añade únicamente:

```text
SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

y:

```text
visible destination for both outcomes =
identical

visible differentiation =
NO
```

Esta extensión es coherente con la semántica original de no diferenciación y no la sustituye.

Resultado:

```text
AC-018-085 original semantics preserved =
YES

AC-018-085 routing extension =
/pending-profile
```

### AC-018-086 — semántica original preservada

Debe permanecer íntegramente la obligación canónica:

```text
Error visible no enumera cuentas,
tenants,
memberships
ni provider details sensibles
```

No recibe extensión de routing.

### AC-018-087 — semántica original preservada

Debe permanecer íntegramente:

```text
TASK-018 =
ONLINE-ONLY
```

No recibe extensión de routing.

### AC-018-088 — semántica original preservada

Debe permanecer íntegramente:

```text
queued/offline Auth provisioning =
NO
```

No recibe extensión de routing.

### AC-018-089 — semántica original preservada

Debe permanecer íntegramente la obligación canónica de que Dexie/IndexedDB no almacene:

- grant;
- technical password;
- autoridad de TASK-018.

No recibe extensión de routing.

### AC-018-090 — semántica original preservada

Debe permanecer íntegramente la obligación canónica:

```text
falta de conectividad
→ bounded retry UX

falta de conectividad
!= optimistic identity creation
```

No recibe extensión de routing.

### Regla de edición

La futura corrección documental de TASK-018 debe:

1. preservar `AC-018-084` sin cambios semánticos;
2. preservar la semántica original completa de `AC-018-085`;
3. añadir a `AC-018-085` únicamente la convergencia visible de ambos outcomes hacia `/pending-profile`;
4. preservar `AC-018-086..090` sin cambios semánticos;
5. no renumerar AC;
6. no crear un rango AC nuevo;
7. no mover AC pertenecientes a Work Item E.

Las demás obligaciones nuevas de CORR-029 permanecen fuera de este remapeo inexistente y deben fijarse en las superficies ya identificadas de Work Item D:

- `POST_AUTH_SUCCESS_DESTINATION = /pending-profile`;
- semántica exacta de `/pending-profile`;
- minimal pending-profile shell only;
- profile form fuera de alcance;
- tenant authority no implícita;
- ausencia de URL/query/browser authority transport;
- pruebas correspondientes;
- Definition of Done correspondiente.

---

## 27. Pruebas requeridas cuando Work Item D sea reanudado

Estas pruebas pertenecen a la futura implementación autorizada de Work Item D, no a CORR-029.

### 27.1 Routing

Debe demostrarse:

```text
SESSION_ESTABLISHED
→ /pending-profile
```

y:

```text
SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

### 27.2 Uniformidad

Con ambos outcomes, debe verificarse:

- mismo pathname;
- misma shell visible;
- ausencia de copy diferenciador;
- ausencia de provider/reconciliation detail.

### 27.3 URL hygiene

Debe verificarse que la URL visible no contiene:

- `intentId`;
- email;
- tenant;
- role;
- ids internos;
- grant;
- challenge;
- access token;
- refresh token;
- technical password.

### 27.4 UI boundary

Debe demostrarse que la route no contiene:

- profile inputs;
- submit de profile;
- persistence;
- dashboard;
- tenant management;
- membership management.

### 27.5 Seguridad

Las regression tests existentes de Auth/session no deben degradarse.

En particular debe preservarse que:

- technical password no llega al browser;
- grant no se convierte en bearer browser-side;
- session establishment no equivale a tenant authorization;
- no se expone token JSON.

### 27.6 Multitenancy

No debe aparecer ninguna nueva lectura/escritura cross-tenant ni RLS change.

### 27.7 Offline

No deben introducirse IndexedDB, Dexie, Service Worker ni continuation offline.

---

## 28. Fuera de alcance

CORR-029 no autoriza ni diseña:

- implementación de Work Item D;
- profile form;
- persistencia de perfil;
- `PlatformUser` persistence;
- creación de `CompanyMembership`;
- modificación de `CompanyMembership`;
- habilitación de membership;
- `AuditEvent`;
- dashboard;
- route authorization;
- general onboarding framework;
- client scope;
- `SupportAccessGrant`;
- RLS;
- SQL;
- migrations;
- Storage;
- Realtime;
- offline;
- Hosted Development;
- Work Item E;
- TASK-019;
- nueva arquitectura;
- nuevo ADR.

---

## 29. Criterios de aceptación de CORR-029

**AC-029-001.** El documento identifica `CORR-029` y su objetivo único.

**AC-029-002.** El estado es `READY FOR REVIEW`.

**AC-029-003.** Se preserva el blocker aprobado de Work Item D.

**AC-029-004.** Se preserva Work Item E como `NOT AUTHORIZED`.

**AC-029-005.** Se preserva Hosted Development como `NOT AUTHORIZED`.

**AC-029-006.** Se preserva TASK-019 como `NOT DETERMINED / NOT AUTHORIZED`.

**AC-029-007.** Se preserva RF-012 sin reabrirlo.

**AC-029-008.** Se preserva FL-01 sin cambiar su secuencia.

**AC-029-009.** Se evaluaron `/onboarding/profile`, `/profile` y `/pending-profile`.

**AC-029-010.** La comparación utiliza únicamente los criterios autorizados.

**AC-029-011.** No se introduce una cuarta ruta sin fuente canónica.

**AC-029-012.** La propuesta concreta es `/pending-profile`.

**AC-029-013.** El pathname exacto queda inequívocamente fijado.

**AC-029-014.** El destino significa únicamente sesión Auth establecida + perfil pendiente.

**AC-029-015.** Se enumeran las interpretaciones de autoridad/persistencia expresamente prohibidas.

**AC-029-016.** `SESSION_ESTABLISHED` converge a `/pending-profile`.

**AC-029-017.** `SESSION_ALREADY_ESTABLISHED` converge a `/pending-profile`.

**AC-029-018.** La UI visible no distingue los dos outcomes.

**AC-029-019.** La UI no distingue new Auth user, reconciled user, duplicate provider identity ni response-loss recovery.

**AC-029-020.** La shell mínima permitida queda delimitada.

**AC-029-021.** El profile form queda fuera de alcance.

**AC-029-022.** La future profile form puede reutilizar `/pending-profile` sin que CORR-029 la implemente.

**AC-029-023.** Se preserva `intentId = locator, not bearer`.

**AC-029-024.** Se preserva el handoff server-internal.

**AC-029-025.** No se permiten technical password ni tokens browser-visible.

**AC-029-026.** No se introduce tenant authority.

**AC-029-027.** RLS change requerido = `NO`.

**AC-029-028.** Offline permanece `ONLINE-ONLY`.

**AC-029-029.** `docs/product/01-product-definition.md` no requiere cambio.

**AC-029-030.** Nuevo ADR requerido = `NO`.

**AC-029-031.** El único target documental primario previsto es TASK-018.

**AC-029-032.** Se identifican Work Item D, flujo/navegación, UI, `AC-018-084..090`, tests, DoD y Gate como superficies afectadas, preservando íntegramente la semántica original del rango y limitando la integración de routing a una extensión mínima de `AC-018-085`.

**AC-029-033.** La futura ejecución exige verificación física del target canónico antes de escribir.

**AC-029-034.** No se modifica el repositorio durante esta especificación.

**AC-029-035.** No se modifica Supabase Cloud.

**AC-029-036.** No se usa Codex.

**AC-029-037.** No se determina TASK-019.

---

## 30. Definition of Done de CORR-029

CORR-029 estará documentalmente lista para aprobación cuando:

1. exista el artefacto `CORR-029-task-018-post-auth-pending-profile-destination-corrected.md`;
2. el estado sea `READY FOR REVIEW`;
3. el problema y blocker estén descritos sin reabrir TASK-018 completa;
4. RF-012 y FL-01 estén preservados;
5. las tres rutas obligatorias estén evaluadas;
6. exista una única propuesta concreta;
7. la propuesta sea `/pending-profile`;
8. la semántica positiva esté definida;
9. la semántica negativa esté definida;
10. ambos success outcomes converjan al mismo destino visible;
11. la shell mínima esté delimitada;
12. profile completion real permanezca futura;
13. la frontera de seguridad E2 permanezca intacta;
14. no exista RLS change;
15. no exista decisión offline nueva;
16. no se requiera ADR;
17. el único target de corrección sea TASK-018;
18. estén identificadas las superficies de TASK-018 afectadas y se preserve el shape canónico de `AC-018-084..090`, con extensión de routing únicamente en `AC-018-085`;
19. los criterios de aceptación estén definidos;
20. el Gate de reanudación de Work Item D esté definido;
21. Work Item D siga bloqueado al terminar esta generación;
22. Work Item E siga no autorizado;
23. Hosted siga no autorizado;
24. TASK-019 siga no determinada/no autorizada.

---

## 31. Gate para reanudar TASK-018 Work Item D

### 31.1 Estado después de generar CORR-029

Debe permanecer:

```text
CORR-029 SPECIFICATION =
READY FOR REVIEW

TASK-018 WORK ITEM D =
REMAINS BLOCKED

WORK ITEM E =
NOT AUTHORIZED

Hosted Development =
NOT AUTHORIZED

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED
```

### 31.2 Condiciones mínimas para retirar el blocker de destino

El blocker:

```text
APPROVED POST-AUTH SUCCESS DESTINATION UNAVAILABLE
```

podrá considerarse resuelto únicamente después de completar un ciclo documental separado que demuestre:

1. `CORR-029 SPEC REVIEW = APPROVED`;
2. aprobación humana explícita;
3. artefacto aprobado/canonicalizado conforme al proceso vigente;
4. incorporación de CORR-029 al repositorio mediante Gate separado;
5. verificación física de TASK-018 target;
6. ejecución documental autorizada de la corrección sobre TASK-018;
7. TASK-018 actualizada con `/pending-profile`;
8. revisión de la corrección;
9. ausencia de drift en seguridad, scope y AC;
10. autorización humana separada para reanudar Work Item D.

La aprobación de CORR-029 por sí sola no ejecuta Work Item D.

### 31.3 Condiciones que mantienen Work Item D bloqueado

Work Item D continúa bloqueado si:

- CORR-029 no está aprobada;
- el target TASK-018 no coincide con el canon esperado;
- una futura corrección documental no preserva el shape canónico conocido de `AC-018-084..090`, altera la semántica original de `AC-018-084` o `AC-018-086..090`, o extiende un AC distinto de `AC-018-085`;
- existe una decisión posterior que cambia RF-012/FL-01;
- se exige transportar autoridad/secreto por browser;
- se requiere RLS/schema para el placeholder;
- se intenta implementar profile completion real;
- se intenta determinar TASK-019;
- se requiere ampliar a route authorization general.

---

## 32. Resultado de contradicciones

Con las fuentes y el estado autoritativo consumidos:

```text
material product contradiction detected = NO
architecture contradiction detected = NO
security contradiction detected = NO
multitenancy contradiction detected = NO
new ADR required = NO
product baseline update required = NO
```

El problema es local:

```text
missing concrete post-auth pathname
```

y puede resolverse mediante una corrección documental acotada de TASK-018.

---

## 33. Decisión propuesta resumida

```text
PROPOSED POST-AUTH DESTINATION =
/pending-profile

SEMANTICS =
Supabase Auth session established
+
first-admin profile completion pending

SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile

profile form =
NOT IN TASK-018

tenant authority =
NOT IMPLIED

dashboard access =
NOT AUTHORIZED

RLS change =
NO

offline =
ONLINE-ONLY

new ADR =
NO

product definition update =
NO
```

---

## 34. Estado final de esta aprobación documental

```text
CORR-029 SPEC REVIEW =
APPROVED

CORR-029 HUMAN SPEC APPROVAL =
APPROVED

CORR-029 DOCUMENT APPROVAL =
APPROVED ARTIFACT GENERATED — PENDING CENTRAL REVIEW

TASK-018 amended =
NO

TASK-018 WORK ITEM D =
REMAINS BLOCKED

TASK-018 WORK ITEM D implementation authorized =
NO

WORK ITEM E =
NOT AUTHORIZED

Hosted Development =
NOT AUTHORIZED

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED
```

La aprobación documental no modifica la decisión técnica aprobada:

```text
POST_AUTH_PENDING_PROFILE_PATHNAME =
/pending-profile
```

y no modifica el shape preservado de `AC-018-084..090`.

STOP.

RETURN TO REVISOR CENTRAL.
