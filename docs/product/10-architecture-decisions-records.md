# 10 — Registro maestro de decisiones arquitectónicas y candidatos a ADR

> **Ruta normativa/objetivo:** `docs/product/10-architecture-decisions-records.md`  
> **Estado:** **APROBADO — registro maestro de decisiones arquitectónicas, catálogo de futuros ADR y Gate arquitectónico de Fase 0**  
> **Fase:** Fase 0 — registro maestro de arquitectura  
> **Estado de Fase 0:** **COMPLETADA**  
> **Naturaleza:** registro maestro de decisiones, índice de futuros ADR, mapa de dependencias y Gate arquitectónico; **NO constituye implementación ni genera ADRs individuales**

---

# 1. Propósito

Este documento consolida las decisiones con impacto arquitectónico detectadas durante la Fase 0 del SaaS B2B multiempresa de mantenimiento.

Sus funciones son:

- mantener un registro maestro de decisiones aprobadas, resueltas, abiertas, propuestas y diferidas;
- inventariar todos los candidatos a ADR detectados en `02..09`;
- eliminar duplicidades conceptuales entre candidatos;
- determinar qué temas justifican realmente un ADR;
- proponer identificadores definitivos para los futuros ADR;
- establecer el alcance de cada futuro ADR;
- mantener trazabilidad entre ADR, documentos fuente y decisiones `DO-*` / `*-OPEN-*`;
- identificar dependencias y bloqueos;
- establecer deadlines arquitectónicos por fase;
- identificar qué ADR pueden redactarse inmediatamente;
- definir el Gate arquitectónico necesario para cerrar Fase 0.

Este documento **NO**:

- implementa arquitectura;
- selecciona esquemas físicos;
- diseña tablas;
- diseña RLS ejecutable;
- define schemas Dexie;
- implementa Service Worker;
- selecciona SDK, endpoint o API concreta;
- genera ningún ADR individual;
- aprueba ningún ADR;
- resuelve ningún `OPEN`;
- modifica estados de decisiones existentes;
- autoriza implementación.

---

# 2. Qué es y qué no es un ADR

## 2.1 Requisito de producto

Un requisito de producto define una capacidad, restricción o comportamiento que el sistema debe cumplir.

Ejemplos:

- una versión publicada de formulario es inmutable;
- una corrección de mantenimiento crea una nueva revisión;
- el período de gracia aprobado es de 20 días;
- el PDF es el documento oficial;
- sólo `COMPANY_ADMIN` utiliza IA en el MVP.

Un requisito no es automáticamente un ADR.

## 2.2 Decisión funcional

Una decisión funcional resuelve cómo debe comportarse el producto desde la perspectiva del dominio o del usuario.

Ejemplos:

- cuántas fotografías satisfacen Evidence required;
- qué ocurre cuando un campo condicionado deja de mostrarse;
- si un informe permite exclusión manual;
- cuándo comienza la gracia comercial.

Puede condicionar posteriormente una decisión arquitectónica, pero no necesita por sí sola un ADR.

## 2.3 Decisión técnica

Una decisión técnica selecciona una estrategia para cumplir requisitos ya aprobados.

Puede ser local y reversible o transversal y costosa.

Las decisiones técnicas menores no necesitan ADR.

## 2.4 ADR

Un Architecture Decision Record documenta una decisión arquitectónica suficientemente determinada cuya elección:

- tiene impacto transversal;
- afecta múltiples módulos;
- condiciona seguridad, datos, offline, integraciones o mantenibilidad;
- implica alternativas relevantes;
- es costosa de revertir;
- necesita conservar contexto, consecuencias y motivación histórica.

Un ADR registra una decisión arquitectónica. No sustituye una decisión de producto.

## 2.5 Riesgo

Un riesgo describe una situación que podría producir daño, inconsistencia, pérdida, exposición o deuda técnica.

El tratamiento recomendado de un riesgo **NO constituye automáticamente una decisión aprobada**.

## 2.6 Candidato a ADR

Un candidato indica que un tema podría justificar un ADR cuando exista suficiente definición.

Puede terminar:

- consolidado dentro de otro ADR;
- descartado por resultar trivial;
- diferido;
- bloqueado por una decisión abierta;
- convertido posteriormente en ADR.

## 2.7 Regla fundamental

Un `OPEN` no se convierte en decisión por aparecer dentro de un futuro ADR.

Cuando el contenido arquitectónico depende materialmente de una decisión abierta:

> el futuro ADR permanece `BLOCKED BY OPEN DECISIONS`.

No todo `OPEN` necesita un ADR individual.

---

# 3. Fuentes normativas

## 3.1 Documentos revisados

Este registro consolida:

1. `docs/product/00-master-product-brief.md`;
2. `docs/product/01-product-definition.md`;
3. `docs/product/02-domain-model.md`;
4. `docs/product/03-permissions-rls-strategy.md`;
5. `docs/product/04-offline-sync-strategy.md`;
6. `docs/product/05-form-engine-spec.md`;
7. `docs/product/06-maintenance-evidence-spec.md`;
8. `docs/product/07-reporting-engine-spec.md`;
9. `docs/product/08-ai-credits-spec.md`;
10. `docs/product/09-subscription-payments-spec.md`;
11. decisiones explícitamente aprobadas posteriormente dentro del Project que no hayan sido sustituidas.

## 3.2 Orden de autoridad

Para resolver una aparente discrepancia debe aplicarse:

1. decisión explícita aprobada posteriormente que modifique una decisión previa y no haya sido sustituida;
2. `01-product-definition.md` como baseline normativa de producto;
3. documentos derivados `02..09`, cada uno dentro de su bounded context y sin capacidad para contradecir fuentes superiores;
4. `00-master-product-brief.md` como fuente consolidada anterior.

Un documento derivado puede profundizar una regla, pero no ampliarla ni sustituirla por inferencia.

## 3.3 Regla temporal

Una referencia antigua a una propuesta no prevalece sobre un estado posterior aprobado.

Este registro utiliza siempre el estado normativo más reciente disponible.

## 3.4 Referencias provisionales de ADR ya existentes

`01-product-definition.md` contiene referencias provisionales a:

- `ADR-0006 propuesto` para el ledger IA;
- `ADR-0007 propuesto` para procesamiento de pagos.

Para evitar romper trazabilidad documental, este catálogo reserva:

- `ADR-0006` para el ledger de créditos IA;
- `ADR-0007` para `PaymentEvent` / procesamiento de pagos.

Esto sólo preserva numeración y trazabilidad. **No significa que dichos ADR existan ni estén aprobados.**

---

# 4. Reglas arquitectónicas ya cerradas

Las siguientes reglas están suficientemente aprobadas como restricciones de arquitectura y no se reabren en este documento.

## 4.1 Arquitectura de aplicación

- el producto utiliza Next.js, TypeScript estricto y Supabase;
- debe mantenerse una arquitectura modular dentro del mismo proyecto Next.js;
- no deben introducirse microservicios sin una necesidad técnica demostrada y una decisión posterior aprobada.

## 4.2 Multitenancy

- cada `MaintenanceCompany` constituye un tenant;
- `SUPER_ADMIN` es una identidad global y no pertenece a tenants;
- cada `COMPANY_ADMIN` y `TECHNICIAN` pertenece exactamente a un tenant;
- todo dato tenant-owned debe poseer un tenant inequívocamente derivable;
- `maintenance_company_id` no puede tratarse como autoridad por haber sido enviado desde frontend;
- el tenant efectivo debe resolverse desde identidad, ownership y relaciones autoritativas.

## 4.3 Persistencia y RLS

- Supabase PostgreSQL es la fuente de verdad remota;
- RLS es obligatorio;
- RLS constituye la frontera primaria de aislamiento remoto;
- frontend, middleware y filtros visuales no son controles suficientes;
- `service-role` no puede convertirse en el mecanismo ordinario de acceso tenant;
- una relación cross-tenant manipulada debe ser rechazada.

## 4.4 Autorización

- existen roles fijos;
- `UserClientAccess` determina el alcance de cliente cuando corresponde;
- un `TECHNICIAN` autorizado a un cliente accede a toda la jerarquía de ubicaciones y todos sus equipos;
- `COMPANY_ADMIN` no posee ejecución inicial de mantenimiento;
- `TECHNICIAN` conserva ejecución inicial dentro de sus clientes autorizados;
- `SupportAccessGrant` es explícito, limitado, revocable y auditable;
- un grant no convierte a `SUPER_ADMIN` en un `COMPANY_ADMIN`.

## 4.5 Ubicaciones

- las ubicaciones forman una jerarquía recursiva;
- no existen tablas rígidas por nivel;
- conceptualmente se utiliza una relación equivalente a `parent_location_id`.

## 4.6 Form Engine

- `FormTemplate` pertenece a un tenant;
- un template está activo o archivado;
- `FormVersion` es draft o published;
- una versión published es inmutable;
- editar una versión publicada crea un nuevo draft;
- publicar crea una nueva versión;
- las versiones históricas se conservan;
- los fields de versiones distintas son independientes;
- un mantenimiento conserva para siempre la versión exacta utilizada;
- una publicación posterior no migra silenciosamente mantenimientos existentes.

## 4.7 MaintenanceRevision

- un mantenimiento finalizado mantiene histórico inmutable;
- una corrección crea una nueva `MaintenanceRevision`;
- no se sobrescribe una revisión anterior;
- una resolución de conflicto de mantenimiento genera una nueva revisión.

## 4.8 Evidence

- `Evidence` es distinta de un field `image`;
- pertenece a una `Response`;
- Evidence finalizada no se elimina;
- un visual replacement no elimina la Evidence original;
- identidad y revisión histórica de origen deben preservarse.

La semántica de continuidad efectiva entre revisiones continúa abierta.

## 4.9 Offline-first

- PWA orientada principalmente a Android;
- Service Worker para application shell/assets;
- Dexie/IndexedDB para información operativa local;
- persistencia local-first;
- outbox durable;
- idempotencia;
- finalización funcional local independiente de sincronización;
- fotografías/archivos pendientes permanecen locales hasta confirmación remota válida;
- no existe Last Write Wins silencioso;
- los conflictos preservan ambas versiones;
- la autorización offline aprobada tiene un máximo de 7 días desde la última validación online;
- vencido el lease no se inician nuevas operaciones;
- una revocación conocida prevalece al recuperar conectividad;
- el trabajo ya capturado no se elimina por revocación o vencimiento.

## 4.10 Reporting

- `Report`, `ReportVersion` y `ReportSnapshot` son conceptos separados;
- cada versión finalizada posee un snapshot inmutable;
- una corrección posterior de mantenimiento no modifica un informe finalizado;
- una regeneración crea una nueva versión y un nuevo snapshot;
- el número oficial pertenece al `Report` y se conserva al regenerar;
- PDF es el documento oficial/canónico generado por la plataforma;
- DOCX es editable;
- PDF y DOCX derivan de un único `ReportDocumentModel`.

## 4.11 IA

- IA se utiliza exclusivamente como asistencia editorial de Reporting;
- las llamadas son server-side;
- no se envían fotografías;
- IA no modifica hechos técnicos;
- IA requiere revisión humana;
- Reporting debe funcionar sin IA;
- debe existir minimización de datos enviados al proveedor.

## 4.12 Créditos IA

- créditos IA pertenecen al tenant;
- suscripción y créditos son conceptos separados;
- el ledger de créditos es inmutable;
- un balance mutable aislado no puede ser la única historia;
- retries no pueden duplicar consumo;
- fallos deben poder liberarse o compensarse conforme a la futura política aprobada.

## 4.13 Subscription & Payments

- existe un único plan pago con modalidad mensual/anual;
- el primer año posee las mismas capacidades a precio de suscripción $0;
- existe una gracia aprobada de 20 días para vencimientos a los que aplique;
- suspensión comercial no elimina datos;
- pago válido de reactivación reconocido restaura acceso;
- Mercado Pago es el proveedor previsto;
- un redirect frontend no constituye confirmación autoritativa;
- eventos externos deben verificarse;
- procesamiento debe ser idempotente;
- deben soportarse duplicados, eventos fuera de orden y reconciliación;
- el estado comercial local no es una copia directa del estado externo del proveedor.

---

# 5. Registro completo de decisiones

## 5.1 Decisiones `DO-*`

| ID | Nombre | Categoría | Fuente | Estado actual | Fase límite | Requiere ADR | Dependencias |
|---|---|---|---|---|---|---|---|
| `DO-073` | Alcance de notificaciones push | Producto | `01` | `DIFERIDA` | Antes de Fase 9 | Condicional | Ninguna actual |
| `DO-074` | Métricas del dashboard | Producto | `01` | `DIFERIDA` | Antes de Fase 10 | No por sí sola | Ninguna actual |
| `DO-075` | Límite de autorización offline | Producto/seguridad | `01`, `04` | `RESUELTA/APROBADA` | Cerrada; consumida antes de Fase 5 | No separado; alimenta `ADR-0004` | `DO-T03` para mecanismo técnico |
| `DO-076` | Gracia al finalizar el primer año a $0 | Comercial | `01`, `09` | `PROPUESTA PENDIENTE DE APROBACIÓN` | Antes de Fase 8 | No individual; alimenta `ADR-0014` | `PAY-OPEN-001`, `003`, `008` |
| `DO-077` | Subconjunto DOCX portable | Reporting | `01`, `07` | `PENDIENTE DE APROBACIÓN` | Antes de Fase 6 | No individual | Condiciona implementación de `ADR-0012` |
| `DO-078` | Cancelación/renovación comercial | Comercial | `01`, `09` | `PROPUESTA PENDIENTE DE APROBACIÓN` | Antes de Fase 8 | No individual; alimenta `ADR-0014` | `PAY-OPEN-001`, `003`, `004` |
| `DO-T01` | Protocolo del ledger IA | Arquitectura | `08` | `PROPUESTA PENDIENTE DE APROBACIÓN` | Antes de Fase 7 | Sí: `ADR-0006` | `DM-OPEN-007`, `AI-OPEN-001..004` |
| `DO-T02` | State machine de Mercado Pago | Arquitectura | `09` | `PROPUESTA PENDIENTE DE APROBACIÓN` | Antes de Fase 8 | Sí: `ADR-0007` | `PAY-OPEN-006` cuando afecte estado comercial |
| `DO-T03` | Invalidación efectiva de sesiones | Seguridad | `03`, `04` | `PARCIALMENTE ABIERTO` | Antes de Fase 2; coordinación offline antes de Fase 5 | Sí: `ADR-0003`, `ADR-0004` | `DO-075` ya resuelta |
| `DO-T04` | Protección local | Offline/seguridad | `04` | `PROPUESTA PENDIENTE DE APROBACIÓN` | Antes de Fase 5 | Sí: `ADR-0004` | `DO-T03`, `OFF-OPEN-001/002`, `DO-T07` sólo si se decide cifrado adicional |
| `DO-T05` | Escala y rendimiento objetivo | Arquitectura operativa | `01` | `DIFERIDO` | Antes de pruebas de performance/Fase 11/piloto | Sí: `ADR-0016` | Volúmenes y objetivos de negocio todavía no definidos |
| `DO-T06` | Backup, RPO/RTO y restauración | Operaciones | `01` | `DIFERIDO` | Antes de piloto/producción | Sí: `ADR-0017` | Objetivos operativos e infraestructura |
| `DO-T07` | Privacidad/legal aplicable | Legal/seguridad | `01` | `DIFERIDO` | Antes del piloto | Condicional: `ADR-0018` | Validación legal/contractual aplicable |

## 5.2 Decisiones `DM-OPEN-*`

| ID | Nombre | Categoría | Fuente | Estado actual | Fase límite | Requiere ADR | Dependencias |
|---|---|---|---|---|---|---|---|
| `DM-OPEN-001` | Obligatoriedad de `EquipmentType` | Dominio | `02` | `ABIERTA` | Fase 3 | No individual | Afecta aplicabilidad de formularios |
| `DM-OPEN-002` | Cardinalidad de formularios aplicables | Dominio/Form | `02`, `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 4 | No individual; alimenta `ADR-0008` | `DM-OPEN-001` puede afectar casos sin tipo |
| `DM-OPEN-003` | Equipo sin formulario aplicable | Dominio/Form | `02`, `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 4 y antes de Fase 5 | No individual; alimenta `ADR-0008` | `DM-OPEN-002` |
| `DM-OPEN-004` | Cantidad de drafts simultáneos | Dominio/Form | `02`, `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 4 | No individual; alimenta `ADR-0008` | Ciclo de vida de `FormVersion` |
| `DM-OPEN-005` | Unicidad de Report por cliente/período | Reporting | `02`, `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011` | Definición de reporting period |
| `DM-OPEN-006` | Template usado en regeneración | Reporting | `02`, `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011` | `ReportTemplate`/snapshot |
| `DM-OPEN-007` | Créditos IA insuficientes | IA/Créditos | `02`, `08` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 7 | No individual; bloquea `ADR-0006` | `DO-T01`, `AI-OPEN-001` |
| `DM-OPEN-008` | Criterio temporal de inclusión mensual | Reporting | `02`, `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011` | `RPT-OPEN-001` |

## 5.3 Decisiones `FORM-OPEN-*`

| ID | Nombre | Categoría | Fuente | Estado actual | Fase límite | Requiere ADR | Dependencias |
|---|---|---|---|---|---|---|---|
| `FORM-OPEN-001` | Respuesta al ocultarse un campo | Funcional/Form | `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 4; antes de captura Fase 5 | No individual; alimenta `ADR-0008` | Condiciones/validación |
| `FORM-OPEN-002` | Modelo operativo de tabla/matriz | Funcional/Form | `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 4 | No individual; alimenta `ADR-0008` | `FORM-OPEN-006` |
| `FORM-OPEN-003` | Cardinalidad de field `image` | Funcional/Form | `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 4; antes de captura Fase 5 | No individual; alimenta `ADR-0008` | Independiente de Evidence |
| `FORM-OPEN-004` | Inicio offline con versión published desactualizada | Form/Offline | `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 5 | No individual; alimenta `ADR-0004` | `DO-075`, pinning de FormVersion |
| `FORM-OPEN-005` | Tipos permitidos como fuente de igualdad | Funcional/Form | `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 4 | No individual; alimenta `ADR-0008` | Motor de condiciones |
| `FORM-OPEN-006` | Nesting y semántica de compuestos | Funcional/Form | `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 4 | No individual; alimenta `ADR-0008` | `FORM-OPEN-002` |
| `FORM-OPEN-007` | Semántica de required para checkbox | Funcional/Form | `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 4; antes de captura Fase 5 | No individual; alimenta `ADR-0008` | Validación de respuestas |
| `FORM-OPEN-008` | Multiplicidad de condiciones por destino | Funcional/Form | `05` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 4 | No individual; alimenta `ADR-0008` | Motor de condiciones |

## 5.4 Decisiones `EVID-OPEN-*`

| ID | Nombre | Categoría | Fuente | Estado actual | Fase límite | Requiere ADR | Dependencias |
|---|---|---|---|---|---|---|---|
| `EVID-OPEN-001` | Cardinalidad de categoría required | Evidence | `06` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 5 | No individual; alimenta `ADR-0010` | `EVID-OPEN-002` |
| `EVID-OPEN-002` | Multiplicidad por categoría | Evidence | `06` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 5 | No individual; alimenta `ADR-0010` | `EVID-OPEN-001` |
| `EVID-OPEN-003` | Eliminación durante captura no finalizada | Evidence/Offline | `06` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 5 | No individual | Lifecycle local/remoto |
| `EVID-OPEN-004` | Cadena de replacements y vigencia visual | Evidence | `06` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 5 | No individual; bloquea `ADR-0010` | Histórico de revisiones |
| `EVID-OPEN-005` | Categoría en visual replacement | Evidence | `06` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 5 | No individual; bloquea `ADR-0010` | `EVID-OPEN-004` |
| `EVID-OPEN-006` | Continuidad de Evidence entre `MaintenanceRevision` | Evidence/Maintenance | `06` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 5 | No individual; bloquea `ADR-0010` | `EVID-OPEN-004/005`, modelo de revisión |

## 5.5 Decisiones `RPT-OPEN-*`

| ID | Nombre | Categoría | Fuente | Estado actual | Fase límite | Requiere ADR | Dependencias |
|---|---|---|---|---|---|---|---|
| `RPT-OPEN-001` | Zona temporal del reporting period | Reporting | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011` | `DM-OPEN-008` |
| `RPT-OPEN-002` | Momento de selección de `MaintenanceRevision` | Reporting | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011` | Modelo de revisión |
| `RPT-OPEN-003` | Staleness/cambios de fuentes durante draft | Reporting | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011` | `RPT-OPEN-002` |
| `RPT-OPEN-004` | Inclusión/exclusión manual | Reporting | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual | `DM-OPEN-008` |
| `RPT-OPEN-005` | Re-emisión técnica desde el mismo snapshot | Reporting | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011/0012` | Snapshot y renderer histórico |
| `RPT-OPEN-006` | Atomicidad funcional de finalización | Reporting | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; bloquea `ADR-0011` | Número, snapshot y documentos |
| `RPT-OPEN-007` | Huecos en numeración oficial | Reporting | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011` | `RPT-OPEN-006` |
| `RPT-OPEN-008` | Selección de Evidence | Reporting | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6, después de Evidence | No individual; bloquea `ADR-0011` | `EVID-OPEN-004/005/006` |
| `RPT-OPEN-009` | Reporting online y mantenimientos no sincronizados | Reporting/Offline | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011` | Offline/sync |
| `RPT-OPEN-010` | Mantenimiento con conflicto pendiente | Reporting/Sync | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011` | Modelo de conflictos |
| `RPT-OPEN-011` | Regeneración sin cambios semánticos | Reporting | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual; alimenta `ADR-0011` | Snapshot/versionado |
| `RPT-OPEN-012` | Descarte/cancelación de report draft | Reporting | `07` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 6 | No individual | Lifecycle Report |

## 5.6 Decisiones `AI-OPEN-*`

| ID | Nombre | Categoría | Fuente | Estado actual | Fase límite | Requiere ADR | Dependencias |
|---|---|---|---|---|---|---|---|
| `AI-OPEN-001` | Política de costo y visibilidad previa | IA/Créditos | `08` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 7 | No individual; bloquea `ADR-0006` | `DM-OPEN-007`, `DO-T01` |
| `AI-OPEN-002` | Respuesta parcial o inválida | IA/Créditos | `08` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 7 | No individual; bloquea `ADR-0006` | Settlement |
| `AI-OPEN-003` | Cancelación de operación IA en curso | IA | `08` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 7 | No individual; bloquea `ADR-0006` | Lifecycle de operación |
| `AI-OPEN-004` | Operación en curso al deshabilitar IA | IA | `08` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 7 | No individual; bloquea `ADR-0006` | Lifecycle de operación |
| `AI-OPEN-005` | Retención de input/output/metadata | IA/Privacidad | `08` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 7 operacional; validación legal antes de piloto | No individual; alimenta `ADR-0018` | `DO-T07` |
| `AI-OPEN-006` | Paquetes, expiración y origen comercial de créditos | IA/Comercial | `08` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 8 para catálogo comercial | No individual | Subscription & Payments |
| `AI-OPEN-007` | Grants y ajustes administrativos excepcionales | IA/Créditos | `08` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 7 si se requiere; si no, antes de piloto | No individual; condiciona alcance de `ADR-0006` | Autoridad global/auditoría |
| `AI-OPEN-008` | Detalle de historial visible al admin | IA/UX | `08` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 7 | No individual | Ledger/wallet |

## 5.7 Decisiones `PAY-OPEN-*`

| ID | Nombre | Categoría | Fuente | Estado actual | Fase límite | Requiere ADR | Dependencias |
|---|---|---|---|---|---|---|---|
| `PAY-OPEN-001` | Ancla promocional, aniversario y timezone comercial | Subscription | `09` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 8 | No individual; bloquea `ADR-0014` | `DO-076`, `DO-078` |
| `PAY-OPEN-002` | Versionado y política de cambio de precio | Pricing | `09` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 8 | Alimenta `ADR-0015` | Modalidad mensual/anual |
| `PAY-OPEN-003` | Inicio/deadline/reinicio de gracia | Subscription | `09` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 8 | No individual; bloquea `ADR-0014` | `DO-076` |
| `PAY-OPEN-004` | Deuda de varios períodos y reactivación | Subscription | `09` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 8 | No individual; bloquea `ADR-0014` | `DO-078` |
| `PAY-OPEN-005` | Compra de créditos con tenant suspendido | Payments/IA | `09` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 8 | No individual; alimenta `ADR-0014/0007` | `AI-OPEN-006` |
| `PAY-OPEN-006` | Chargebacks y disputes | Payments | `09` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 8 | No individual; condiciona `ADR-0007/0014` | Estado comercial |
| `PAY-OPEN-007` | Capacidades excepcionales de `SUPER_ADMIN` | Payments/Security | `09` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 8 si se necesitan; de lo contrario ausencia de permiso | No individual; alimenta `ADR-0014` | Modelo de autorización |
| `PAY-OPEN-008` | Representación del año promocional respecto de `Subscription` | Subscription | `09` | `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN` | Fase 8 | No individual; bloquea `ADR-0014` | `PAY-OPEN-001` |

## 5.8 Decisiones `OFF-OPEN-*`

| ID | Nombre | Categoría | Fuente | Estado actual | Fase límite | Requiere ADR | Dependencias |
|---|---|---|---|---|---|---|---|
| `OFF-OPEN-001` | Destino de trabajo pendiente tras revocación | Offline/Seguridad | `04` | `ABIERTO — pendiente de aprobación` | Fase 5 | No individual; bloquea `ADR-0004` | `DO-T03`, `DO-075` |
| `OFF-OPEN-002` | Conservación/purga de datos sincronizados revocados | Offline/Seguridad | `04` | `ABIERTO — pendiente de aprobación` | Fase 5 | No individual; bloquea `ADR-0004` | `DO-T04`, `DO-T07` cuando corresponda |

---

# 6. Inventario de ADR candidates existentes

Se revisaron **85 entradas candidatas** en `02..09`.

La existencia de 85 candidatos no implica que deban existir 85 ADR.

## 6.1 `02-domain-model.md` — 13 candidatos

| Candidato original | Consolidación propuesta |
|---|---|
| `ADR-CAND-01` — Identidad, membership y acceso por cliente | `ADR-0003` |
| `ADR-CAND-02` — Acceso excepcional de `SUPER_ADMIN` | `ADR-0003` |
| `ADR-CAND-03` — Versionado inmutable de formularios | `ADR-0008` |
| `ADR-CAND-04` — Modelo de revisiones de mantenimiento | `ADR-0009` |
| `ADR-CAND-05` — Evidencias y reemplazo visual | `ADR-0010` |
| `ADR-CAND-06` — Aislamiento de persistencia local por identidad | `ADR-0004` |
| `ADR-CAND-07` — Outbox e idempotencia | `ADR-0005` |
| `ADR-CAND-08` — Conflictos de sincronización | `ADR-0005` |
| `ADR-CAND-09` — Autorización offline y revocación | `ADR-0004`, con dependencia de `ADR-0003` |
| `ADR-CAND-10` — Versionado y snapshots de informes | `ADR-0011` |
| `ADR-CAND-11` — Modelo intermedio PDF/DOCX | `ADR-0012` |
| `ADR-CAND-12` — Ledger IA | `ADR-0006` |
| `ADR-CAND-13` — Procesamiento de pagos | `ADR-0007` |

## 6.2 `03-permissions-rls-strategy.md` — 7 candidatos

| Candidato original | Consolidación propuesta |
|---|---|
| `ADR-CAND-SEC-01` — RLS como frontera primaria | `ADR-0002` |
| `ADR-CAND-SEC-02` — Identity + membership + client access | `ADR-0003` |
| `ADR-CAND-SEC-03` — `SupportAccessGrant` | `ADR-0003` |
| `ADR-CAND-SEC-04` — Autorización online vs offline | `ADR-0004`, referenciando `ADR-0003` |
| `ADR-CAND-SEC-05` — Uso restringido de `service-role` | `ADR-0002` |
| `ADR-CAND-SEC-06` — Invalidación efectiva de sesiones | `ADR-0003` |
| `ADR-CAND-SEC-07` — Integridad cross-tenant | `ADR-0002` |

## 6.3 `04-offline-sync-strategy.md` — 11 candidatos sin ID propio

| Candidato original | Consolidación propuesta |
|---|---|
| Local-first + outbox durable | `ADR-0004` |
| Partición local por identidad | `ADR-0004` |
| Estrategia de identidad de recursos/operaciones | `ADR-0005` |
| Sincronización idempotente | `ADR-0005` |
| Optimistic concurrency + modelo de conflicto | `ADR-0005` |
| Separación business state / sync state | `ADR-0004` |
| Protección local `DO-T04` | `ADR-0004` |
| Service Worker vs IndexedDB | `ADR-0004` |
| Orden push/revalidación/pull | `ADR-0005` |
| Estrategia de archivos pendientes | `ADR-0005`, con reglas Evidence en `ADR-0010` |
| Evolución/migración de réplica | `ADR-0004` |

## 6.4 `05-form-engine-spec.md` — 8 candidatos

| Candidato original | Consolidación propuesta |
|---|---|
| `FORM-ADR-CAND-001` — `FormTemplate` / `FormVersion` | `ADR-0008` |
| `FORM-ADR-CAND-002` — Published immutable | `ADR-0008` |
| `FORM-ADR-CAND-003` — Fields independientes por versión | `ADR-0008` |
| `FORM-ADR-CAND-004` — Estructuras compuestas | `ADR-0008` |
| `FORM-ADR-CAND-005` — Evaluación de condiciones | `ADR-0008` |
| `FORM-ADR-CAND-006` — Selección de applicable form | `ADR-0008` |
| `FORM-ADR-CAND-007` — Pinning de `FormVersion` | `ADR-0008` |
| `FORM-ADR-CAND-008` — Identidad de instancias de captura | `ADR-0008` |

## 6.5 `06-maintenance-evidence-spec.md` — 8 candidatos

| Candidato original | Consolidación propuesta |
|---|---|
| `EVID-ADR-CAND-001` — Lifecycle local/remoto | `ADR-0005` |
| `EVID-ADR-CAND-002` — Identidad estable/idempotencia | `ADR-0005` |
| `EVID-ADR-CAND-003` — Estrategia de upload | `ADR-0005` |
| `EVID-ADR-CAND-004` — Visual replacement histórico | `ADR-0010` |
| `EVID-ADR-CAND-005` — Storage authorization boundary | `ADR-0002` |
| `EVID-ADR-CAND-006` — Cleanup después de confirmación | `ADR-0004` |
| `EVID-ADR-CAND-007` — `BEFORE`/`AFTER` | `ADR-0010` |
| `EVID-ADR-CAND-008` — Continuidad efectiva entre revisiones | `ADR-0010` |

## 6.6 `07-reporting-engine-spec.md` — 12 candidatos

| Candidato original | Consolidación propuesta |
|---|---|
| `RPT-ADR-CAND-001` — `Report` / `ReportVersion` / `ReportSnapshot` | `ADR-0011` |
| `RPT-ADR-CAND-002` — Atomicidad conceptual de finalización | `ADR-0011` |
| `RPT-ADR-CAND-003` — Numeración oficial | `ADR-0011` |
| `RPT-ADR-CAND-004` — Snapshot strategy | `ADR-0011` |
| `RPT-ADR-CAND-005` — `ReportDocumentModel` | `ADR-0012` |
| `RPT-ADR-CAND-006` — Pipeline PDF/DOCX | `ADR-0012` |
| `RPT-ADR-CAND-007` — Persistencia de documentos | `ADR-0011`, con autorización de `ADR-0002` |
| `RPT-ADR-CAND-008` — Template snapshot/versioning | `ADR-0011` |
| `RPT-ADR-CAND-009` — Selección de `MaintenanceRevision` | `ADR-0011` |
| `RPT-ADR-CAND-010` — Integración de Evidence | `ADR-0011` + `ADR-0010` |
| `RPT-ADR-CAND-011` — Integración IA server-side | `ADR-0013` |
| `RPT-ADR-CAND-012` — Retries/idempotencia de generación | `ADR-0011` |

## 6.7 `08-ai-credits-spec.md` — 12 candidatos

| Candidato original | Consolidación propuesta |
|---|---|
| `AI-ADR-CAND-001` — Lifecycle de `AIUsageOperation` | `ADR-0006` |
| `AI-ADR-CAND-002` — Ledger inmutable | `ADR-0006` |
| `AI-ADR-CAND-003` — Reserva/consumo/liberación/compensación | `ADR-0006` |
| `AI-ADR-CAND-004` — Cálculo/lectura de balance | `ADR-0006` |
| `AI-ADR-CAND-005` — Idempotencia IA | `ADR-0006` |
| `AI-ADR-CAND-006` — Concurrencia de créditos | `ADR-0006` |
| `AI-ADR-CAND-007` — Provider abstraction | `ADR-0013` |
| `AI-ADR-CAND-008` — Data minimization boundary | `ADR-0013` |
| `AI-ADR-CAND-009` — Prompt/output retention | `ADR-0018`, con implicaciones en `ADR-0013` |
| `AI-ADR-CAND-010` — Reconciliación IA/ledger | `ADR-0006` |
| `AI-ADR-CAND-011` — Integración con `PaymentEvent` | `ADR-0006` + `ADR-0007` |
| `AI-ADR-CAND-012` — Configuración de costos | `ADR-0006` |

## 6.8 `09-subscription-payments-spec.md` — 14 candidatos sin ID propio

| Candidato original | Consolidación propuesta |
|---|---|
| Lifecycle de `Subscription` y entitlement | `ADR-0014` |
| Representación del promotional entitlement | `ADR-0014` |
| Adapter de Mercado Pago | `ADR-0007` |
| Normalización de `PaymentEvent` | `ADR-0007` |
| Verificación/idempotencia de webhooks | `ADR-0007` |
| Eventos fuera de orden | `ADR-0007` |
| Reconciliación | `ADR-0007` |
| Billing periods y aniversarios | `ADR-0014` |
| Grace period | `ADR-0014` |
| Pricing/versioning | `ADR-0015` |
| Cancelación/renovación | `ADR-0014` |
| Separación Subscription vs AI Credits | `ADR-0014` |
| Frontera de autorización comercial/RLS | `ADR-0014`, subordinado a `ADR-0002/0003` |
| Acciones excepcionales globales | `ADR-0014`, subordinado a `ADR-0003` |

## 6.9 Duplicados conceptuales principales detectados

Se detectaron especialmente estas familias duplicadas:

- identidad/membership/client access;
- soporte excepcional;
- tenant ownership/RLS/Storage authorization;
- autorización offline/revocación;
- partición local por identidad;
- outbox/idempotencia;
- sincronización/conflictos;
- FormVersion/published immutable/pinning;
- MaintenanceRevision;
- Evidence histórico/replacement;
- Report/version/snapshot;
- modelo intermedio PDF/DOCX;
- integración IA server-side/provider;
- ledger/settlement/idempotencia/concurrencia IA;
- Subscription/entitlement;
- PaymentEvent/webhook/reconciliation.

No se detecta pérdida de un candidato relevante después de la consolidación.

---

# 7. Catálogo definitivo propuesto de ADR

Se proponen **18 ADR definitivos**.

Los estados de esta tabla reflejan el estado documental actual de cada ADR. No modifican el estado de ningún `DO` ni `OPEN`.

| ID | Título | Problema arquitectónico | Fuentes/candidatos consolidados | Open dependencies | Estado del ADR | Aprobar antes de |
|---|---|---|---|---|---|---|
| `ADR-0001` | Arquitectura modular del SaaS en Next.js | Mantener un único sistema modular y evitar distribución prematura | `00`, `01` | Ninguna | `ACCEPTED` | Cierre Fase 0 / Fase 1 |
| `ADR-0002` | Multi-tenancy, tenant ownership y aislamiento | Establecer frontera de tenant, RLS, ownership, integridad cross-tenant y `service-role` | `ADR-CAND-SEC-01/05/07`, Evidence Storage boundary | Ninguna | `ACCEPTED` | Fase 2 |
| `ADR-0003` | Autorización, client scope y soporte excepcional | Resolver actor, membership, `UserClientAccess`, grants, revocación y sesión | `ADR-CAND-01/02`, `ADR-CAND-SEC-02/03/06` | `DO-T03` | `BLOCKED BY OPEN DECISIONS` | Fase 2 |
| `ADR-0004` | Offline local-first y aislamiento de réplica | Delimitar PWA, Service Worker, IndexedDB, réplica por identidad, logout y autorización offline | candidatos Offline + `ADR-CAND-06/09` | `DO-T03`, `DO-T04`, `OFF-OPEN-001`, `OFF-OPEN-002`, `FORM-OPEN-004` | `BLOCKED BY OPEN DECISIONS` | Fase 5 |
| `ADR-0005` | Protocolo de sincronización, idempotencia y conflictos | Fijar identidad de operaciones, retries, concurrencia optimista, conflicto explícito y convergencia | `ADR-CAND-07/08`, candidatos Offline sync, `EVID-ADR-CAND-001..003` | Ninguna decisión funcional abierta necesaria para el núcleo | `ACCEPTED` | Fase 5 |
| `ADR-0006` | Ledger de créditos IA y settlement de `AIUsageOperation` | Preservar ledger inmutable, reserva/consumo/liberación/compensación, idempotencia y concurrencia | `ADR-CAND-12`, `AI-ADR-CAND-001..006/010..012` | `DO-T01`, `DM-OPEN-007`, `AI-OPEN-001..004`; `AI-OPEN-007` si se incluyen ajustes | `BLOCKED BY OPEN DECISIONS` | Fase 7 |
| `ADR-0007` | `PaymentEvent`, adapter de Mercado Pago e idempotencia comercial | Aislar proveedor, verificar eventos, deduplicar, tolerar orden arbitrario y reconciliar | `ADR-CAND-13` + candidatos Payments 3..7 | `DO-T02`; `PAY-OPEN-006` para effects de disputes | `BLOCKED BY OPEN DECISIONS` | Fase 8 |
| `ADR-0008` | Form Engine: versionado, estructura y aplicabilidad | Documentar lifecycle, inmutabilidad, pinning, condiciones y estructuras compuestas | `ADR-CAND-03`, `FORM-ADR-CAND-001..008` | `DM-OPEN-001..004`, `FORM-OPEN-001..003`, `FORM-OPEN-005..008` | `BLOCKED BY OPEN DECISIONS` | Fase 4 |
| `ADR-0009` | Modelo de `MaintenanceRevision` e histórico de mantenimiento | Separar identidad lógica, revisión vigente, correcciones e histórico | `ADR-CAND-04` | Ninguna | `ACCEPTED` | Fase 5 |
| `ADR-0010` | Evidence histórica, replacement y continuidad entre revisiones | Preservar identidad/origen y definir effective Evidence set | `ADR-CAND-05`, `EVID-ADR-CAND-004/007/008` | `EVID-OPEN-001..006`; especialmente `004..006` | `BLOCKED BY OPEN DECISIONS` | Fase 5 |
| `ADR-0011` | Reporting: versionado, snapshots y finalización | Establecer Report/Version/Snapshot, numeración, regeneración, fuentes y staleness | `ADR-CAND-10`, `RPT-ADR-CAND-001..004/007..010/012` | `DM-OPEN-005/006/008`, `RPT-OPEN-001..012`, `EVID-OPEN-004..006` para Evidence | `BLOCKED BY OPEN DECISIONS` | Fase 6 |
| `ADR-0012` | `ReportDocumentModel` y renderizadores PDF/DOCX | Mantener una única semántica documental con salidas PDF y DOCX | `ADR-CAND-11`, `RPT-ADR-CAND-005/006` | Ninguna para decidir la arquitectura; `DO-077` bloquea implementación/aceptación DOCX, no el ADR de modelo común | `ACCEPTED` | Fase 6 |
| `ADR-0013` | IA server-side, provider boundary y minimización de datos | Desacoplar dominio del proveedor y limitar datos/exposición | `RPT-ADR-CAND-011`, `AI-ADR-CAND-007/008` | Ninguna para la frontera base; retención queda fuera y depende de `AI-OPEN-005`/`DO-T07` | `ACCEPTED` | Fase 7 |
| `ADR-0014` | Subscription lifecycle y commercial entitlement | Modelar promotional/paid/grace/inactive/reactivation y modalidades | candidatos Payments 1/2/8/9/11/12/13/14 | `DO-076`, `DO-078`, `PAY-OPEN-001/003/004/005/006/007/008` | `BLOCKED BY OPEN DECISIONS` | Fase 8 |
| `ADR-0015` | Pricing comercial versionado | Preservar precios aplicados e histórico ante cambios | candidato Payments pricing/versioning | `PAY-OPEN-002` | `BLOCKED BY OPEN DECISIONS` | Fase 8 |
| `ADR-0016` | Observabilidad, capacidad y performance | Definir objetivos medibles y estrategia transversal sin inventar volúmenes | `DO-T05`, riesgos de escala | `DO-T05` | `DEFERRED` | Antes de performance/piloto |
| `ADR-0017` | Backup, restore, RPO y RTO | Definir estrategia operativa de recuperación según objetivos de negocio | `DO-T06` | `DO-T06` | `DEFERRED` | Piloto/producción |
| `ADR-0018` | Controles técnicos derivados de privacidad/legal | Traducir requisitos legales aprobados a retención, acceso y minimización técnica | `DO-T07`, `AI-ADR-CAND-009`, riesgos de Evidence | `DO-T07`, `AI-OPEN-005` cuando corresponda | `DEFERRED` | Antes del piloto |

---

# 8. ADR de multi-tenancy y tenant isolation

`ADR-0002` fue creado, revisado y aprobado posteriormente con estado `ACCEPTED`.

Debe documentar conceptualmente:

- `MaintenanceCompany` como frontera tenant;
- ownership de recursos;
- asociación conceptual mediante `maintenance_company_id`;
- resolución autoritativa del tenant;
- RLS como frontera primaria;
- validación de ownership encadenado;
- integridad cross-tenant;
- prohibición de confiar en `tenant_id` o equivalentes enviados por frontend;
- comportamiento de recursos tenant-wide y client-scoped;
- Storage autorizado desde dominio, no desde URL/path;
- uso restringido de `service-role`.

No debe contener políticas SQL.

## Estado

`ACCEPTED`.

`ADR-0002` fue creado, revisado y aprobado sin resolver ningún `OPEN`; la baseline ya determinaba las invariantes necesarias para esta decisión arquitectónica.

---

# 9. ADR de autorización y soporte excepcional

Se propone `ADR-0003`.

Debe contemplar:

- identidad autenticada;
- `PlatformUser`;
- `CompanyMembership`;
- roles fijos;
- `UserClientAccess`;
- alcance por cliente;
- ausencia de permisos por ubicación/equipo/mantenimiento;
- `SUPER_ADMIN`;
- `SupportAccessGrant`;
- scopes client-scoped y tenant-wide;
- auditoría;
- revocación efectiva de autorización mediante estado autoritativo vigente;
- separación entre autenticación residual y autorización vigente;
- tratamiento provider-side de sesiones y credenciales renovables conforme a la semántica aprobada de DO-T03, exclusivamente mediante mecanismos públicos, soportados y contractualmente adecuados cuando corresponda;
- comportamiento fail-closed ante ausencia o fallo de la terminación provider-side;
- relación entre autorización online y el posterior contexto offline.

No debe inferir capacidades de escritura de soporte.

## Bloqueo

`DO-T03` permanece `PARCIALMENTE ABIERTO`.

Por tanto:

**Estado del futuro ADR: `BLOCKED BY OPEN DECISIONS`.**

Debe aprobarse antes de implementar identidad/autorización de Fase 2.

---

# 10. ADR de offline local-first

Se propone `ADR-0004`.

Debe consolidar:

- PWA;
- Service Worker;
- Dexie/IndexedDB;
- `LocalReplica`;
- partición por identidad;
- persistencia local-first;
- outbox durable;
- separación business state / sync state;
- finalización local;
- lease offline máximo de 7 días ya aprobado;
- logout;
- revocación;
- apertura/cierre de réplica;
- evolución segura de réplica;
- preservación de trabajo pendiente;
- límites entre datos locales y autorización remota.

No debe diseñar schema IndexedDB.

## Dependencias

- `DO-075`: resuelta y consumida como restricción;
- `DO-T03`: abierta parcialmente;
- `DO-T04`: propuesta pendiente;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`.

Las decisiones Evidence pueden condicionar subflujos de archivos, pero no deben utilizarse para resolver las anteriores.

## Estado

`BLOCKED BY OPEN DECISIONS`.

---

# 11. ADR de sincronización y conflictos

La separación respecto del ADR offline fue documentada en `ADR-0005`, posteriormente creado, revisado y aprobado con estado `ACCEPTED`.

La separación está justificada porque:

- `ADR-0004` define dónde y bajo qué identidad existe el estado local;
- `ADR-0005` define cómo una intención local converge con el estado remoto.

`ADR-0005` debe considerar:

- identidad estable de operación;
- idempotency key lógica;
- retries;
- acknowledgements;
- dependencias entre operaciones;
- revalidación previa cuando corresponda;
- optimistic concurrency;
- detección de divergencia;
- preservación de ambas versiones;
- conflicto explícito;
- visualización/resolución posterior;
- generación de revisión cuando el conflicto de mantenimiento se resuelve;
- prohibición de silent Last Write Wins;
- reconciliación suficiente después de mutaciones confirmadas;
- coordinación conceptual de binario + metadata para Evidence.

No debe fijar un algoritmo físico, cantidad de retries ni protocolo HTTP concreto.

## Estado

`ACCEPTED`.

`ADR-0005` fue creado, revisado y aprobado. Los `OFF-OPEN` continúan gobernando qué hacer con autorización revocada y conservación local y no fueron resueltos por ese ADR.

---

# 12. ADR de versionado del Form Engine

Se propone `ADR-0008`.

Debe considerar conjuntamente:

- `FormTemplate`;
- `FormVersion`;
- draft/published;
- published immutable;
- nuevas versiones;
- fields independientes entre versiones;
- pinning de versión al mantenimiento;
- applicable form;
- conditions;
- estructuras compuestas;
- identidad de instancias de repeatables/matrices;
- interacción con histórico y offline.

## Decisiones que deben resolverse antes del ADR completo

- `DM-OPEN-001`;
- `DM-OPEN-002`;
- `DM-OPEN-003`;
- `DM-OPEN-004`;
- `FORM-OPEN-001`;
- `FORM-OPEN-002`;
- `FORM-OPEN-003`;
- `FORM-OPEN-005`;
- `FORM-OPEN-006`;
- `FORM-OPEN-007`;
- `FORM-OPEN-008`.

`FORM-OPEN-004` pertenece principalmente al ADR offline y no debe retrasar el ADR del modelo estructural si su frontera queda explícitamente separada.

## Estado

`BLOCKED BY OPEN DECISIONS`.

Debe aprobarse antes de Fase 4.

---

# 13. ADR de `MaintenanceRevision` y Evidence

La revisión concluye que **conviene utilizar dos ADR separados**.

## 13.1 `ADR-0009` — MaintenanceRevision

Debe capturar:

- `MaintenanceRecord` como identidad lógica;
- revisiones históricas;
- revisión vigente;
- finalización;
- correcciones;
- no sobrescritura;
- resolución de conflictos mediante nueva revisión;
- relación de respuestas con la revisión correspondiente.

### Estado

`ACCEPTED`.

`ADR-0009` fue creado, revisado y aprobado; la regla de revisiones permanece cerrada sin resolver la continuidad de Evidence ni Reporting.

## 13.2 `ADR-0010` — Evidence histórica

Debe capturar:

- relación `Response` ↔ `Evidence`;
- identidad histórica;
- `BEFORE` / `AFTER`;
- replacement;
- lineage;
- revisión de origen;
- effective Evidence set;
- continuidad entre revisiones.

### Estado

`BLOCKED BY OPEN DECISIONS`.

Depende de `EVID-OPEN-001..006`, especialmente:

- `EVID-OPEN-004`;
- `EVID-OPEN-005`;
- `EVID-OPEN-006`.

No deben fusionarse ambos ADR porque la revisión de mantenimiento ya posee una semántica cerrada, mientras que la continuidad de Evidence todavía contiene decisiones funcionales abiertas.

---

# 14. ADR de Reporting snapshots/versionado

Se propone `ADR-0011`.

Debe considerar:

- `Report`;
- `ReportVersion`;
- `ReportSnapshot`;
- report draft;
- primera finalización;
- regeneración;
- número oficial;
- version ordinal;
- inmutabilidad histórica;
- snapshot autosuficiente para interpretación;
- selección de `MaintenanceRevision`;
- staleness;
- selección de Evidence;
- retry vs re-emisión vs nueva versión;
- documentos asociados sin convertirlos en fuente histórica.

## Dependencias

Como mínimo:

- `DM-OPEN-005`;
- `DM-OPEN-006`;
- `DM-OPEN-008`;
- `RPT-OPEN-001..012`;
- `EVID-OPEN-004..006` para la semántica de Evidence.

## Estado

`BLOCKED BY OPEN DECISIONS`.

Debe estar aprobado antes de Fase 6.

---

# 15. ADR del modelo intermedio PDF/DOCX

`ADR-0012` fue creado, revisado y aprobado posteriormente con estado `ACCEPTED`.

Debe registrar la decisión ya aprobada de:

- construir un `ReportDocumentModel` neutral respecto del formato;
- derivar PDF y DOCX del mismo modelo semántico;
- mantener PDF como documento canónico/oficial;
- mantener DOCX como salida editable;
- evitar dos pipelines funcionales independientes.

## Relación con `DO-077`

`DO-077` determina **qué subconjunto DOCX portable debe soportar el producto y cómo verificarlo**.

No determina si debe existir un único `ReportDocumentModel`: esa decisión ya está aprobada.

Por tanto:

- `DO-077` **sí bloquea la implementación y aceptación del renderer DOCX**;
- `DO-077` **no necesita bloquear la redacción del ADR que documenta el modelo intermedio común**.

## Estado

`ACCEPTED`.

`ADR-0012` fue creado, revisado y aprobado sin anticipar qué layouts forman parte del subconjunto portable. `DO-077` continúa pendiente y condiciona la implementación concreta del renderer DOCX.

---

# 16. ADR de IA server-side/provider abstraction

`ADR-0013` fue creado, revisado y aprobado posteriormente con estado `ACCEPTED`.

Debe considerar:

- ejecución exclusivamente server-side;
- `AIUsageOperation` como contexto de dominio;
- frontera de proveedor;
- OpenAI como proveedor inicial sin acoplar el dominio a modelo/API concretos;
- autorización previa;
- tenant isolation;
- minimización de contexto;
- prohibición de imágenes/OCR;
- trazabilidad mínima de proveedor/modelo;
- revisión humana;
- factual vs editorial;
- ausencia de secretos en cliente;
- independencia de Reporting respecto de IA.

## Retención

`AI-OPEN-005` y `DO-T07` gobiernan retención de prompt/output.

Esa política no debe integrarse silenciosamente en este ADR.

El ADR puede establecer la obligación de **minimizar** y delegar la retención concreta a `ADR-0018`.

## Estado

`ACCEPTED`.

`ADR-0013` fue creado, revisado y aprobado sin resolver ledger/settlement, retención ni decisiones `AI-OPEN-*`.

---

# 17. ADR de ledger de créditos IA

Se propone `ADR-0006`, preservando la referencia provisional ya existente en `01`.

Debe considerar:

- `AIUsageOperation`;
- ledger inmutable;
- wallet derivada;
- available vs reserved vs consumed;
- reserva;
- consumo;
- release;
- compensation;
- identidad idempotente;
- retry;
- respuesta perdida;
- concurrencia;
- prevención de sobreconsumo;
- reserva huérfana;
- reconciliación;
- preservación del costo aplicado;
- integración posterior con compras confirmadas sin acoplar el ledger a Mercado Pago.

## Dependencias obligatorias

- `DO-T01`;
- `DM-OPEN-007`;
- `AI-OPEN-001`;
- `AI-OPEN-002`;
- `AI-OPEN-003`;
- `AI-OPEN-004`.

`AI-OPEN-007` debe resolverse antes de incluir una capacidad de grants/ajustes manuales.

`AI-OPEN-006` puede resolverse en Fase 8 sin bloquear la arquitectura base del ledger de operaciones de Fase 7, siempre que los paquetes comerciales permanezcan fuera del ADR.

## Estado

`BLOCKED BY OPEN DECISIONS`.

---

# 18. ADR de Subscription lifecycle

Se propone `ADR-0014`.

Debe considerar:

- promotional entitlement;
- paid entitlement;
- monthly;
- annual;
- due;
- grace;
- inactive/suspended;
- reactivation;
- cancelación/renovación una vez resuelta;
- relación con pagos;
- local commercial state;
- independencia frente a créditos IA;
- suspensión no destructiva;
- relación con autorización online/offline.

## Dependencias

- `DO-076`;
- `DO-078`;
- `PAY-OPEN-001`;
- `PAY-OPEN-003`;
- `PAY-OPEN-004`;
- `PAY-OPEN-005`;
- `PAY-OPEN-006`;
- `PAY-OPEN-007`;
- `PAY-OPEN-008`.

`PAY-OPEN-002` se separa en `ADR-0015`.

## Estado

`BLOCKED BY OPEN DECISIONS`.

Debe aprobarse antes de Fase 8.

---

# 19. ADR de `PaymentEvent` / Mercado Pago adapter

Se propone `ADR-0007`, preservando la referencia provisional ya existente en `01`.

Debe considerar:

- external provider boundary;
- adapter de Mercado Pago;
- `PaymentEvent` normalizado;
- autenticidad/verificación;
- correlación con entidad local;
- deduplicación;
- idempotencia;
- eventos fuera de orden;
- callback frontend no autoritativo;
- evento perdido;
- reconciliación;
- estado externo vs estado comercial interno;
- efectos comerciales idempotentes;
- integración futura con compra de créditos.

No debe seleccionar:

- SDK;
- endpoint;
- recurso de Mercado Pago;
- payload físico;
- queue/job concreta.

## Dependencias

- `DO-T02`;
- `PAY-OPEN-006` cuando se documente la traducción de disputes/chargebacks a estado comercial.

## Estado

`BLOCKED BY OPEN DECISIONS`.

---

# 20. ADR de pricing/versioning comercial

Se propone mantenerlo **separado** como `ADR-0015`.

## Justificación

Pricing posee problemas propios:

- vigencia temporal;
- precio mensual/anual;
- histórico del precio aplicado;
- cambio futuro;
- obligaciones ya generadas;
- reproducibilidad comercial;
- reconciliación.

Integrarlo completamente en Subscription lifecycle haría que `ADR-0014` mezclara:

- lifecycle;
- entitlement;
- pagos;
- temporalidad;
- pricing histórico.

La separación mantiene ambos ADR acotados.

## Dependencia

`PAY-OPEN-002`.

## Estado

`BLOCKED BY OPEN DECISIONS`.

Debe aprobarse antes de Fase 8.

---

# 21. ADR de observabilidad/performance

Se propone `ADR-0016`.

Debe relacionarse con:

- `DO-T05`;
- riesgos de escala;
- observabilidad transversal;
- medición de latencia/errores;
- operaciones críticas;
- sync;
- Reporting;
- IA;
- pagos;
- capacidad de detectar regresiones.

No debe seleccionar herramientas ni inventar:

- usuarios concurrentes;
- tamaños;
- latencias objetivo;
- throughput;
- límites.

## Estado

`DEFERRED`.

La decisión necesita primero objetivos de escala reales.

---

# 22. ADR de backup/restore

Se propone `ADR-0017`.

Debe abordar posteriormente:

- alcance de backup;
- datos estructurados;
- artefactos/Storage;
- restore;
- pruebas de restauración;
- RPO;
- RTO;
- responsabilidades operativas.

No debe seleccionar proveedor ni números.

## Estado

`DEFERRED`.

Depende de `DO-T06`.

Debe aprobarse antes de piloto/producción.

---

# 23. Privacidad/legal

`DO-T07` permanece `DIFERIDO`.

Se propone reservar `ADR-0018` para **controles técnicos derivados de requisitos legales aprobados**, no para definir la política legal.

Puede resultar necesario documentar posteriormente:

- retención;
- minimización;
- Evidence;
- datos industriales;
- proveedor IA;
- logs;
- prompts/output;
- eliminación técnica;
- recuperación;
- acceso excepcional.

El ADR sólo podrá redactarse cuando exista una definición legal/contractual suficiente.

## Estado

`DEFERRED`.

No se inventa ninguna obligación jurídica.

---

# 24. Notificaciones

`DO-073` permanece `DIFERIDA`.

Con la información actual **no se propone un ADR definitivo adicional** para notificaciones.

Primero debe definirse:

- qué eventos generan push;
- qué comportamiento funcional se espera.

Después de resolver `DO-073` deberá revaluarse si existen decisiones arquitectónicas no triviales sobre:

- entrega;
- deduplicación;
- retry;
- permisos del dispositivo;
- relación online/offline.

Si la solución resultante es directa y local al módulo, bastará una especificación funcional/técnica de Fase 9.

No se resuelve push en este documento.

---

# 25. Dashboard/analytics

`DO-074` permanece `DIFERIDA`.

Con la baseline actual, Dashboard se entiende principalmente como una proyección/read model de datos de otros módulos.

No existe todavía una razón suficiente para crear un ADR específico.

Primero deben definirse:

- métricas;
- filtros;
- necesidades de actualización;
- volumen esperado.

Si posteriormente esas decisiones obligan a introducir:

- agregaciones materializadas complejas;
- un almacén analítico separado;
- procesamiento asíncrono relevante;
- otra frontera arquitectónica no trivial;

deberá revaluarse un ADR.

No se inventan métricas.

---

# 26. Dependencias entre ADR

El DAG conceptual recomendado es:

`ADR-0001` Arquitectura modular  
→ `ADR-0002` Tenant isolation  
→ `ADR-0003` Autorización y soporte

Desde esa base:

`ADR-0003`  
→ `ADR-0004` Offline local-first  
→ `ADR-0005` Sync/conflictos

Para dominio operativo:

`ADR-0002` + `ADR-0003`  
→ `ADR-0008` Form Engine  
→ `ADR-0009` MaintenanceRevision  
→ `ADR-0010` Evidence

Para Reporting:

`ADR-0008` + `ADR-0009` + `ADR-0010`  
→ `ADR-0011` Reporting snapshots/versionado  
→ `ADR-0012` ReportDocumentModel

Para IA:

`ADR-0011`  
→ `ADR-0013` IA provider boundary  
→ `ADR-0006` Ledger/settlement

Para comercio:

`ADR-0002` + `ADR-0003`  
→ `ADR-0015` Pricing versioning  
→ `ADR-0014` Subscription lifecycle  
→ `ADR-0007` PaymentEvent/provider adapter

Integración de compra de créditos:

`ADR-0006` + `ADR-0007`  
→ acreditación conciliada de compras, sin fusionar los bounded contexts.

Transversalmente:

- `ADR-0016` observabilidad/performance;
- `ADR-0017` backup/restore;
- `ADR-0018` privacidad/legal;

aplican sobre múltiples ramas una vez que sus decisiones diferidas estén disponibles.

---

# 27. Mapeo contra fases

| Hito | ADR que deben estar aprobados o situación requerida |
|---|---|
| **Antes de Fase 1** | `ADR-0001`; además debe haberse cerrado el Gate documental de Fase 0 |
| **Antes de Fase 2** | `ADR-0002`, `ADR-0003` |
| **Antes de Fase 4** | `ADR-0008` |
| **Antes de Fase 5** | `ADR-0004`, `ADR-0005`, `ADR-0009`, `ADR-0010` |
| **Antes de Fase 6** | `ADR-0011`, `ADR-0012`; `DO-077` aprobado para implementación DOCX |
| **Antes de Fase 7** | `ADR-0013`, `ADR-0006` |
| **Antes de Fase 8** | `ADR-0014`, `ADR-0007`, `ADR-0015`; decisiones comerciales IA necesarias para compras |
| **Antes de Fase 9** | Resolver `DO-073`; revaluar si push requiere ADR. Ningún ADR adicional es obligatorio hoy |
| **Antes de Fase 10** | Resolver `DO-074`; revaluar si analytics requiere ADR. Ningún ADR adicional es obligatorio hoy |
| **Antes de pruebas de performance/Fase 11/piloto** | Resolver `DO-T05` y aprobar `ADR-0016` |
| **Antes de piloto/producción** | Resolver `DO-T06`, `DO-T07`; aprobar `ADR-0017` y, si los requisitos legales generan decisiones técnicas relevantes, `ADR-0018` |

---

# 28. ADRs inicialmente `READY TO DRAFT` — estado actual

Los seis ADR que este registro identificó como suficientemente decididos para el Gate de Fase 0 fueron creados, revisados y aprobados:

1. `ADR-0001` — Arquitectura modular del SaaS en Next.js = `ACCEPTED`;
2. `ADR-0002` — Multi-tenancy, tenant ownership y aislamiento = `ACCEPTED`;
3. `ADR-0005` — Sincronización, idempotencia y conflictos = `ACCEPTED`;
4. `ADR-0009` — Modelo de `MaintenanceRevision` = `ACCEPTED`;
5. `ADR-0012` — `ReportDocumentModel` y renderizadores = `ACCEPTED`;
6. `ADR-0013` — IA server-side/provider boundary = `ACCEPTED`.

No queda ningún ADR `READY TO DRAFT` obligatorio pendiente para el Gate de Fase 0.

La aceptación de estos ADR no resuelve decisiones `DO-*` o `*-OPEN-*` ni autoriza implementación por sí misma.

---

# 29. ADRs bloqueados

## `ADR-0003`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueador:

- `DO-T03`.

## `ADR-0004`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueadores:

- `DO-T03`;
- `DO-T04`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`.

## `ADR-0006`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueadores:

- `DO-T01`;
- `DM-OPEN-007`;
- `AI-OPEN-001`;
- `AI-OPEN-002`;
- `AI-OPEN-003`;
- `AI-OPEN-004`.

`AI-OPEN-007` bloquea únicamente si el ADR pretende incluir ajustes/grants administrativos.

## `ADR-0007`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueadores:

- `DO-T02`;
- `PAY-OPEN-006` para la semántica comercial de disputes/chargebacks.

## `ADR-0008`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueadores:

- `DM-OPEN-001`;
- `DM-OPEN-002`;
- `DM-OPEN-003`;
- `DM-OPEN-004`;
- `FORM-OPEN-001`;
- `FORM-OPEN-002`;
- `FORM-OPEN-003`;
- `FORM-OPEN-005`;
- `FORM-OPEN-006`;
- `FORM-OPEN-007`;
- `FORM-OPEN-008`.

## `ADR-0010`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueadores:

- `EVID-OPEN-001..006`.

Los más determinantes para el modelo histórico son `EVID-OPEN-004..006`.

## `ADR-0011`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueadores:

- `DM-OPEN-005`;
- `DM-OPEN-006`;
- `DM-OPEN-008`;
- `RPT-OPEN-001..012`;
- `EVID-OPEN-004..006` para selección histórica de Evidence.

## `ADR-0014`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueadores:

- `DO-076`;
- `DO-078`;
- `PAY-OPEN-001`;
- `PAY-OPEN-003`;
- `PAY-OPEN-004`;
- `PAY-OPEN-005`;
- `PAY-OPEN-006`;
- `PAY-OPEN-007`;
- `PAY-OPEN-008`.

## `ADR-0015`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueador:

- `PAY-OPEN-002`.

---

# 30. ADRs diferidos

## `ADR-0016` — Observabilidad/performance

`DEFERRED`

Depende de:

- `DO-T05`.

## `ADR-0017` — Backup/restore

`DEFERRED`

Depende de:

- `DO-T06`.

## `ADR-0018` — Controles técnicos de privacidad/legal

`DEFERRED`

Depende de:

- `DO-T07`;
- requisitos derivados que correspondan, incluyendo `AI-OPEN-005`.

`DO-073` y `DO-074` permanecen diferidas, pero **no originan actualmente un ADR definitivo**.

---

# 31. Orden recomendado de creación

El orden de redacción recomendado no necesita coincidir estrictamente con el número de ADR, porque `ADR-0006` y `ADR-0007` conservan numeración provisional preexistente por trazabilidad.

Secuencia recomendada:

1. `ADR-0001` — arquitectura modular;
2. `ADR-0002` — tenant isolation;
3. `ADR-0005` — sincronización/conflictos;
4. `ADR-0009` — MaintenanceRevision;
5. `ADR-0012` — ReportDocumentModel;
6. `ADR-0013` — IA provider boundary;
7. resolver `DO-T03` y redactar `ADR-0003`;
8. resolver decisiones de Form y redactar `ADR-0008`;
9. resolver Offline/Evidence y redactar `ADR-0004` y `ADR-0010`;
10. resolver Reporting y redactar `ADR-0011`;
11. resolver `DO-T01`/IA opens y redactar `ADR-0006`;
12. resolver Subscription/Pricing y redactar `ADR-0015` y `ADR-0014`;
13. resolver `DO-T02` y redactar `ADR-0007`;
14. tratar `ADR-0016`, `ADR-0017` y `ADR-0018` conforme a sus deadlines diferidos.

Esta secuencia no autoriza la creación automática de ninguno.

---

# 32. Convención futura de ADR

Cada ADR futuro debería contener como mínimo:

- **ID**
- **Título**
- **Status**
- **Context**
- **Decision**
- **Alternatives**
- **Consequences**
- **Security implications**
- **Data implications**
- **Offline implications**, cuando aplique
- **Testing implications**
- **Dependencies**
- **References**

Además:

- debe citar los documentos normativos que lo restringen;
- debe listar explícitamente decisiones abiertas relevantes;
- no debe presentar una propuesta como decisión aceptada;
- debe indicar qué ADR sustituye si posteriormente supersede otro.

No se define aquí una plantilla de implementación.

---

# 33. Estados futuros de ADR

Los documentos ADR utilizarán conceptualmente:

## `PROPOSED`

Existe una propuesta arquitectónica concreta pendiente de aprobación.

## `ACCEPTED`

La decisión arquitectónica fue aprobada formalmente.

## `SUPERSEDED`

La decisión fue reemplazada por otro ADR posterior.

Debe indicarse el ADR sustituto.

## `DEPRECATED`

La decisión ya no debe utilizarse y no existe necesariamente una sustitución directa.

Estos estados pertenecen exclusivamente a documentos ADR.

No sustituyen ni alteran estados como:

- `ABIERTA`;
- `PROPUESTA PENDIENTE DE APROBACIÓN`;
- `PARCIALMENTE ABIERTO`;
- `DIFERIDO`;
- `RESUELTA/APROBADA`.

---

# 34. Ubicación futura

Los futuros ADR deberán vivir conceptualmente en:

`docs/architecture/adr/`

Convención de nombre:

`ADR-0001-<slug>.md`

Ejemplos de forma, sin crear archivos:

- `ADR-0001-<slug>.md`;
- `ADR-0002-<slug>.md`.

Este documento **NO crea esos archivos**.

---

# 35. Riesgos del registro

## `ADR-RSK-001` — Duplicar decisiones

**Riesgo:** dos ADR documentan la misma frontera con reglas parcialmente distintas.

**Tratamiento:** catálogo maestro, ownership de alcance y referencias cruzadas.

## `ADR-RSK-002` — ADR contradice producto

**Riesgo:** una elección técnica modifica una regla normativa.

**Tratamiento:** citar baseline y exigir revisión contra documentos producto antes de aceptar.

## `ADR-RSK-003` — Redactar ADR antes de resolver OPEN

**Riesgo:** una propuesta funcional termina convertida en arquitectura asumida.

**Tratamiento:** estado `BLOCKED BY OPEN DECISIONS` y lista explícita de bloqueadores.

## `ADR-RSK-004` — Pérdida de trazabilidad

**Riesgo:** candidatos originales dejan de poder relacionarse con la decisión final.

**Tratamiento:** conservar mapping candidate → ADR definitivo.

## `ADR-RSK-005` — Mezclar decisión técnica con regla comercial

**Riesgo:** un ADR termina inventando pricing, cancelación, créditos o comportamiento de producto.

**Tratamiento:** separar `DO/PAY/AI-OPEN` de ADR y bloquear redacción cuando corresponda.

## `ADR-RSK-006` — Implementar con ADR bloqueado

**Riesgo:** Codex o un desarrollador selecciona silenciosamente una opción todavía abierta.

**Tratamiento:** Gate por fase y prohibición de implementar capacidad dependiente.

## `ADR-RSK-007` — ADR stale después de cambio de producto

**Riesgo:** la baseline cambia y el ADR continúa expresando una decisión incompatible.

**Tratamiento:** revisión de ADR impactados ante cualquier cambio normativo; supersede cuando corresponda.

## `ADR-RSK-008` — Convertir recomendación en aprobación

**Riesgo:** una recomendación de documento derivado se interpreta como regla cerrada.

**Tratamiento:** conservar literalmente estados y distinguir `PROPOSED` de `ACCEPTED`.

## `ADR-RSK-009` — Exceso de ADR triviales

**Riesgo:** el registro se vuelve inmanejable y cada detalle menor exige gobernanza formal.

**Tratamiento:** ADR sólo para decisiones transversales, costosas de revertir o con tradeoffs relevantes.

## `ADR-RSK-010` — ADR monolítico demasiado amplio

**Riesgo:** autorización, offline, sync, datos y comercio quedan mezclados en una única decisión imposible de revisar.

**Tratamiento:** límites explícitos entre ADR y dependencias mediante referencias.

---

# 36. Gate de cierre de Fase 0

## 36.1 Regla general

El Gate documental y arquitectónico de Fase 0 se considera **superado** cuando se verifican conjuntamente:

- aprobación documental de `00..10`;
- aprobación de los seis ADR requeridos por este Gate;
- ausencia de decisiones con deadline anterior a Fase 1;
- preservación de decisiones abiertas y ADR bloqueados/diferidos para sus fases correspondientes;
- ausencia de contradicciones materiales que impidan iniciar Fase 1.

La revisión final explícita confirma actualmente esas condiciones.

## 36.2 Documentos

Los documentos `00..10` están aprobados documentalmente:

- `00-master-product-brief.md`;
- `01-product-definition.md`;
- `02-domain-model.md`;
- `03-permissions-rls-strategy.md`;
- `04-offline-sync-strategy.md`;
- `05-form-engine-spec.md`;
- `06-maintenance-evidence-spec.md`;
- `07-reporting-engine-spec.md`;
- `08-ai-credits-spec.md`;
- `09-subscription-payments-spec.md`;
- `10-architecture-decisions-records.md`.

**Estado de `docs/product/10-architecture-decisions-records.md`: APROBADO — registro maestro de decisiones arquitectónicas, catálogo de futuros ADR y Gate arquitectónico de Fase 0.**

## 36.3 ADR requeridos por el Gate

Los seis ADR que originalmente estaban `READY TO DRAFT` y que el registro exigía crear, revisar y aprobar antes de declarar completa Fase 0 se encuentran actualmente:

- `ADR-0001 = ACCEPTED`;
- `ADR-0002 = ACCEPTED`;
- `ADR-0005 = ACCEPTED`;
- `ADR-0009 = ACCEPTED`;
- `ADR-0012 = ACCEPTED`;
- `ADR-0013 = ACCEPTED`.

No queda ningún ADR `READY TO DRAFT` obligatorio pendiente para el Gate de Fase 0.

## 36.4 ADR bloqueados por decisiones con deadline posterior

No es necesario resolver anticipadamente para cerrar Fase 0:

- `ADR-0003`;
- `ADR-0004`;
- `ADR-0006`;
- `ADR-0007`;
- `ADR-0008`;
- `ADR-0010`;
- `ADR-0011`;
- `ADR-0014`;
- `ADR-0015`;

siempre que:

- permanezcan explícitamente bloqueados;
- sus decisiones dependientes conserven el estado correcto;
- exista un deadline previo a la fase que los necesita;
- no se implemente la capacidad dependiente antes de resolverlos.

Esas condiciones permanecen satisfechas en este cierre.

## 36.5 Decisiones diferidas legítimamente

No impiden por sí mismas cerrar Fase 0:

- `DO-073`;
- `DO-074`;
- `DO-T05`;
- `DO-T06`;
- `DO-T07`.

Deben mantenerse con sus deadlines actuales.

Los ADR diferidos `ADR-0016`, `ADR-0017` y `ADR-0018` permanecen igualmente diferidos conforme a sus deadlines posteriores.

## 36.6 Decisiones que bloquean comenzar Fase 1

**No existe actualmente una decisión `DO` o `OPEN` cuyo deadline sea anterior a Fase 1.**

En particular:

- `DM-OPEN-*` no bloquean Fase 1;
- `FORM-OPEN-*` no bloquean Fase 1;
- `EVID-OPEN-*` no bloquean Fase 1;
- `RPT-OPEN-*` no bloquean Fase 1;
- `AI-OPEN-*` no bloquean Fase 1;
- `PAY-OPEN-*` no bloquean Fase 1;
- `OFF-OPEN-*` no bloquean Fase 1;
- `DO-T03/T04` poseen deadlines posteriores;
- `DO-075` ya está resuelta.

## 36.7 Resultado final del Gate

Los tres bloqueos de proceso identificados anteriormente han sido satisfechos:

1. los seis ADR inicialmente `READY TO DRAFT` fueron creados, revisados y aprobados;
2. se efectuó la revisión final explícita del Gate de Fase 0;
3. ningún ADR requerido para iniciar Fase 1 permanece ausente.

Además:

- blockers documentales de Fase 0: ninguno;
- decisiones abiertas de fases posteriores: preservadas;
- ADR bloqueados: preservados;
- ADR diferidos: preservados;
- contradicciones materiales que impidan Fase 1: ninguna conocida.

**Estado de Fase 0: COMPLETADA.**

El inicio de Fase 1 queda **permitido documentalmente únicamente después de incorporar formalmente este cierre al repositorio**.

Esta declaración supera el Gate documental y no constituye por sí misma una autorización de implementación.

## 36.8 Lo que el Gate no exige

El Gate no obliga a:

- resolver `DO-073` antes de Fase 9;
- resolver `DO-074` antes de Fase 10;
- inventar cifras para `DO-T05`;
- inventar RPO/RTO para `DO-T06`;
- inventar obligaciones jurídicas para `DO-T07`;
- resolver decisiones de Fase 5, 6, 7 u 8 antes de su deadline únicamente para “vaciar” el registro.

---

# 37. Resultado de revisión

## 37.1 Contradicciones bloqueantes

**No se detectan contradicciones bloqueantes conocidas** entre `00..10` y los seis ADR aceptados requeridos por el Gate que impidan iniciar Fase 1 documentalmente.

Se conserva la interpretación restrictiva de permisos:

- `TECHNICIAN` conserva ejecución inicial autorizada;
- `COMPANY_ADMIN` no posee ejecución inicial;
- soporte no amplía permisos por inferencia.

## 37.2 Consistencia de IDs provisionales

Se detectaron referencias provisionales antiguas a:

- `ADR-0006` para ledger IA;
- `ADR-0007` para procesamiento de pagos.

El catálogo definitivo propuesto mantiene exactamente esas asociaciones.

Por tanto, no se genera una colisión documental nueva.

## 37.3 Duplicados de candidatos

Se revisaron:

**85 candidatos de ADR existentes en `02..09`.**

Se detectaron múltiples equivalencias conceptuales, principalmente en:

- autorización;
- RLS;
- offline;
- idempotencia;
- conflictos;
- versionado;
- Evidence;
- snapshots;
- IA;
- ledger;
- Subscription;
- PaymentEvent.

Todos quedan trazados al catálogo consolidado.

## 37.4 Cantidad propuesta

**ADRs definitivos propuestos: 18.**

Distribución actual:

- `ACCEPTED`: **6**;
- `BLOCKED BY OPEN DECISIONS`: **9**;
- `DEFERRED`: **3**.

## 37.5 Decisiones que bloquean Fase 1

**Ninguna.**

El bloqueo documental/gobernanza de Fase 0 ha sido satisfecho mediante la aprobación de los seis ADR requeridos y esta revisión final explícita del Gate. El inicio de Fase 1 queda permitido documentalmente después de incorporar formalmente este cierre al repositorio.

## 37.6 Decisiones que pueden permanecer abiertas

Pueden permanecer abiertas respetando sus deadlines:

- `DM-OPEN-001..008`;
- `FORM-OPEN-001..008`;
- `EVID-OPEN-001..006`;
- `RPT-OPEN-001..012`;
- `AI-OPEN-001..008`;
- `PAY-OPEN-001..008`;
- `OFF-OPEN-001..002`;
- `DO-076`;
- `DO-077`;
- `DO-078`;
- `DO-T01`;
- `DO-T02`;
- `DO-T03`;
- `DO-T04`.

Pueden permanecer diferidas:

- `DO-073`;
- `DO-074`;
- `DO-T05`;
- `DO-T06`;
- `DO-T07`.

`DO-075` permanece cerrada.

---

# 38. Estado documental

**Estado de `docs/product/10-architecture-decisions-records.md`:**

`APROBADO — registro maestro de decisiones arquitectónicas, catálogo de futuros ADR y Gate arquitectónico de Fase 0`

**Estado de Fase 0:**

`COMPLETADA`

La aprobación original de este documento, por sí sola:

- aprobó únicamente el registro maestro;
- aprobó su clasificación;
- aprobó el catálogo propuesto de futuros ADR;
- aprobó el mapa de dependencias;
- aprobó el Gate arquitectónico;
- no generó ADRs;
- no resolvió `OPEN`;
- no resolvió `DO` pendientes;
- no autorizó código, SQL, migrations, RLS ejecutable ni implementación;
- no inició Fase 1;
- no cerró automáticamente Fase 0.

Posteriormente fueron creados, revisados y aprobados de forma independiente los seis ADR requeridos por el Gate:

- `ADR-0001 = ACCEPTED`;
- `ADR-0002 = ACCEPTED`;
- `ADR-0005 = ACCEPTED`;
- `ADR-0009 = ACCEPTED`;
- `ADR-0012 = ACCEPTED`;
- `ADR-0013 = ACCEPTED`.

Los ADR bloqueados y diferidos restantes siguen necesitando:

1. resolución previa de sus dependencias cuando corresponda;
2. creación explícita;
3. revisión;
4. aprobación independiente antes de la fase que los requiera.

Las decisiones `DO-*` y `*-OPEN-*` conservan sus estados vigentes y sus deadlines.

**Estado final del documento:** `APROBADO — registro maestro de decisiones arquitectónicas, catálogo de futuros ADR y Gate arquitectónico de Fase 0`.

**Estado final de Fase 0:** `COMPLETADA`.

**Implementación autorizada por este cierre:** no.
