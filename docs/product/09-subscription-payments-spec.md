# 09 — Especificación conceptual y funcional del subsistema de suscripción y pagos

> **Ruta normativa/objetivo:** `docs/product/09-subscription-payments-spec.md`  
> **Estado:** **APROBADO — especificación conceptual y funcional del subsistema de suscripción y pagos del MVP**  
> **Fase:** Fase 0 — documento derivado  
> **Estado de Fase 0:** **EN CURSO**  
> **Baseline normativa:** `docs/product/01-product-definition.md`  
> **Modelo de dominio aprobado:** `docs/product/02-domain-model.md`  
> **Estrategia de permisos/RLS aprobada:** `docs/product/03-permissions-rls-strategy.md`  
> **Estrategia offline/sync aprobada:** `docs/product/04-offline-sync-strategy.md`  
> **Form Engine aprobado:** `docs/product/05-form-engine-spec.md`  
> **Maintenance Evidence aprobado:** `docs/product/06-maintenance-evidence-spec.md`  
> **Reporting Engine aprobado:** `docs/product/07-reporting-engine-spec.md`  
> **IA y créditos aprobado:** `docs/product/08-ai-credits-spec.md`  
> **Naturaleza:** contrato conceptual y funcional de Subscription & Payments; **NO constituye implementación, modelo físico, SQL, RLS ejecutable, integración concreta de Mercado Pago, checkout, webhook ejecutable, API, job, queue, UI React ni autorización para Codex**

---

# 1. Propósito y alcance

Este documento define la especificación conceptual y funcional del bounded context **Subscription & Payments** del MVP.

Su objetivo es fijar, antes de cualquier implementación de Fase 8, las reglas que determinan:

- el ciclo de vida comercial de `MaintenanceCompany`;
- el derecho comercial de acceso al SaaS o subscription entitlement;
- el primer año promocional a precio de suscripción $0;
- la transición posterior hacia una obligación de pago;
- la modalidad mensual o anual del único plan del MVP;
- billing period, vencimiento y renovación;
- pagos, intentos y confirmaciones;
- período de gracia de 20 días;
- suspensión comercial e inactividad online;
- reactivación;
- cancelación y cambios de modalidad, sujetos a `DO-078`;
- `PaymentEvent` y eventos provenientes del proveedor externo;
- verificación, idempotencia, deduplicación y tratamiento de eventos fuera de orden;
- conciliación entre estado local y proveedor;
- permisos y ownership tenant;
- auditoría y trazabilidad comercial;
- fronteras con Reporting, Offline y AI Credits;
- decisiones abiertas que deben resolverse antes de Fase 8.

Este documento debe convertirse posteriormente en contrato para el diseño físico, la integración con Mercado Pago, la autorización, las pruebas y los ADR que correspondan.

## 1.1 Autoridad

Se aplica el siguiente orden de autoridad:

1. `docs/product/01-product-definition.md`;
2. `docs/product/02-domain-model.md`;
3. `docs/product/03-permissions-rls-strategy.md`;
4. `docs/product/04-offline-sync-strategy.md`;
5. `docs/product/05-form-engine-spec.md`;
6. `docs/product/06-maintenance-evidence-spec.md`;
7. `docs/product/07-reporting-engine-spec.md`;
8. `docs/product/08-ai-credits-spec.md`;
9. `docs/product/00-master-product-brief.md`;
10. decisiones explícitamente aprobadas posteriormente dentro del Project que no hayan sido sustituidas.

Ante una contradicción real, prevalece la fuente de mayor autoridad y este documento debe corregirse.

## 1.2 Revisión previa de coherencia

No se detectan contradicciones bloqueantes conocidas entre `01..08` que impidan definir este subsistema.

Se preservan como reglas cerradas:

- `MaintenanceCompany` es el tenant;
- existe un único plan pago en el MVP;
- ese plan puede contratarse mensual o anualmente;
- una empresa nueva dispone durante un año de las mismas capacidades SaaS a precio de suscripción $0;
- finalizado ese período debe existir una suscripción paga para continuar utilizando la plataforma;
- tras el vencimiento de un pago sujeto a la regla general existen 20 días de gracia;
- agotada la gracia sin regularización, el acceso online queda inactivo;
- la suspensión comercial no elimina ni altera información del tenant;
- un pago válido de reactivación reconocido restablece el acceso;
- Mercado Pago es el proveedor previsto para el MVP;
- mercado inicial Argentina, moneda ARS e idioma español;
- suscripción y créditos IA son conceptos comerciales independientes;
- los webhooks deben verificarse antes de producir efectos internos;
- el procesamiento de eventos de pago debe ser idempotente;
- `COMPANY_ADMIN` administra la suscripción de su tenant;
- `TECHNICIAN` no administra suscripción ni pagos;
- `SUPER_ADMIN` no posee acceso tenant ordinario por su rol global;
- RLS sigue siendo la frontera primaria de aislamiento remoto para datos tenant;
- estado comercial no se confía al navegador ni a claims obsoletos;
- `DO-075` permanece RESUELTA/APROBADA;
- `AI-OPEN-006` continúa abierta y este documento no define paquetes, expiración, bonus ni grants de IA.

Las cuestiones sin baseline suficiente se registran como decisiones abiertas; no se cierran por inferencia.

## 1.3 Fuera del alcance

Este documento **NO define ni autoriza**:

- SQL;
- tablas físicas;
- columnas;
- claves físicas;
- índices;
- migrations;
- enums físicos;
- triggers;
- RPC;
- transacciones físicas;
- locks;
- funciones PostgreSQL;
- políticas RLS ejecutables;
- SDK concreto de Mercado Pago;
- checkout físico;
- `preapproval` o recurso concreto de proveedor;
- endpoints;
- Server Actions;
- handlers de webhook;
- payloads físicos;
- credenciales;
- secretos;
- jobs;
- queues;
- cron;
- workers de reconciliación;
- React;
- componentes UI definitivos;
- implementación fiscal AFIP/ARCA;
- reglas tributarias;
- precios reales;
- descuentos;
- implementación mediante Codex;
- ADRs.

---

# 2. Terminología

## 2.1 `Subscription`

Concepto comercial tenant-owned que representa la relación de suscripción del SaaS y su capacidad de producir un entitlement de acceso conforme a la política vigente.

No debe confundirse con un pago individual ni con el estado externo de Mercado Pago.

La representación conceptual exacta del período promocional respecto de `Subscription` se mantiene abierta en `PAY-OPEN-008`.

## 2.2 Subscription entitlement

Derecho comercial efectivo del tenant a utilizar las capacidades SaaS aprobadas en un momento determinado.

Puede derivar conceptualmente de:

- período promocional vigente;
- período pago vigente;
- período de gracia todavía vigente.

No deriva de poseer créditos IA.

## 2.3 Promotional year

Período inicial de una empresa nueva durante el cual dispone de las mismas capacidades SaaS del plan pago a precio de suscripción $0.

No es un free tier permanente y no incluye créditos IA.

## 2.4 Paid period

Intervalo comercial cubierto por una obligación de pago confirmada conforme a la modalidad mensual o anual y a la política de renovación aprobada.

## 2.5 Monthly billing

Modalidad comercial del único plan en la que el período de facturación es mensual conforme al calendario y timezone que finalmente se aprueben.

## 2.6 Annual billing

Modalidad comercial del mismo plan en la que el período comercial es anual.

No constituye un tier diferente.

## 2.7 Billing cycle

Secuencia ordenada de períodos comerciales, vencimientos, pagos y renovaciones que mantienen o modifican el entitlement.

## 2.8 Renewal date

Momento en el que, conforme a la política aprobada, debe producirse la renovación o comenzar la siguiente obligación comercial.

Su cálculo exacto depende de `PAY-OPEN-001` y `DO-078`.

## 2.9 Due date

Momento en que una obligación de pago pasa a considerarse vencida si no existe confirmación válida suficiente.

No debe derivarse de `updated_at` técnico ni del orden de recepción de eventos.

## 2.10 Grace period

Período aprobado de **20 días** durante el cual un vencimiento aplicable no provoca bloqueo inmediato del acceso online.

El instante exacto de inicio y las reglas de reinicio permanecen en `PAY-OPEN-003`.

## 2.11 Active

Situación comercial en la que el tenant posee entitlement vigente para acceso online normal.

Puede corresponder conceptualmente a período promocional activo o período pago activo.

## 2.12 Past due

Situación en la que existe una obligación vencida o fallida que todavía no ha sido regularizada.

Past due no implica por sí mismo suspensión inmediata porque la baseline establece 20 días de gracia para vencimientos sujetos a esa regla.

## 2.13 Grace

Situación comercial temporal en la que existe deuda o fallo aplicable, pero el período de gracia todavía no finalizó y el acceso permanece activo.

## 2.14 Inactive / suspended

Situación comercial en la que el entitlement online no permite a los usuarios del tenant continuar utilizando la plataforma.

Suspensión no significa eliminación del tenant ni de sus datos.

## 2.15 Cancelled

Situación derivada de una cancelación voluntaria conforme a la futura política de `DO-078`.

No se presume todavía si la cancelación es inmediata o efectiva al final del período.

## 2.16 Expired

Término conceptual para indicar que un período comercial o promocional alcanzó su fin natural sin que el término, por sí solo, determine la política siguiente.

No se fija como estado físico.

## 2.17 Reactivation

Restablecimiento del entitlement de un tenant comercialmente inactivo después de que el sistema reconoce una condición válida de regularización.

La baseline exige reactivación inmediata al reconocer un pago válido de reactivación; el tratamiento de deuda múltiple permanece abierto.

## 2.18 Payment

Hecho o registro comercial que representa una obligación monetaria y/o su liquidación asociada al tenant, con suficiente identidad para distinguir intentos, confirmaciones, fallos, reversos y conciliación.

No se define una entidad física.

## 2.19 Payment attempt

Intento concreto de satisfacer una obligación de pago.

Un nuevo intento puede producir nuevos eventos, pero no debe duplicar el efecto comercial de una confirmación ya aplicada.

## 2.20 Confirmed payment

Pago respecto del cual existe confirmación autoritativa suficiente para producir el efecto comercial permitido.

Un redirect del navegador no constituye esa confirmación.

## 2.21 Failed payment

Intento de pago que no llegó a confirmarse como válido y que, cuando corresponde a una obligación vencida, participa en la política de gracia.

## 2.22 Pending payment

Pago cuyo estado todavía no permite considerarlo confirmado ni definitivamente fallido.

Pending no debe producir entitlement equivalente a confirmed por inferencia.

## 2.23 Refund

Reversión o devolución monetaria relacionada con un pago.

No equivale a:

- cancelación de suscripción;
- compensación técnica de IA;
- liberación de créditos reservados;
- edición de un pago histórico.

La política de refunds permanece abierta bajo `DO-078`.

## 2.24 Chargeback / dispute

Situación externa en la que una transacción confirmada previamente es impugnada, revertida o queda bajo disputa conforme al proveedor o al sistema financiero.

Su efecto comercial interno no está aprobado y se trata en `PAY-OPEN-006`.

## 2.25 `PaymentEvent`

Evento externo o interno normalizado relacionado con pagos o suscripciones que debe poder verificarse, deduplicarse, correlacionarse y procesarse idempotentemente antes de producir efectos.

Durante la recepción puede pertenecer conceptualmente a la plataforma; antes de producir efectos tenant debe quedar asociado inequívocamente al tenant y a la causa comercial correcta.

## 2.26 Reconciliation

Proceso conceptual de comparar evidencia autoritativa disponible para detectar y corregir divergencias entre:

- estado comercial local;
- estado de suscripción del proveedor;
- pagos conocidos;
- eventos recibidos;
- efectos internos aplicados.

No se diseña un job concreto.

## 2.27 External provider state

Estado que Mercado Pago u otro recurso externo expresa según su propio modelo.

No es el dominio SaaS y no debe usarse directamente como única verdad de acceso.

## 2.28 Local commercial state

Interpretación interna y auditable del derecho comercial del tenant, derivada mediante reglas de dominio y evidencia externa validada.

Es la referencia para autorización comercial del SaaS.

## 2.29 Distinciones obligatorias

### Subscription vs Payment

`Subscription` expresa la relación comercial y entitlement a lo largo del tiempo.

`Payment` expresa una obligación o transacción monetaria concreta.

Un pago no es la suscripción completa.

### Payment vs PaymentEvent

`Payment` representa el hecho comercial monetario.

`PaymentEvent` representa una notificación o cambio observable que puede referirse a ese hecho y que debe procesarse de forma segura.

### External provider state vs local commercial state

El proveedor puede informar su propio estado.

La plataforma debe traducirlo a significado interno conforme a reglas aprobadas; nunca debe usar una etiqueta externa como bypass directo de dominio.

### Cancelación vs falta de pago

Cancelación es una acción voluntaria o política de no renovación.

Falta de pago es incumplimiento de una obligación monetaria.

No deben producir el mismo histórico ni inferirse mutuamente.

### Suspensión vs eliminación del tenant

Suspensión limita acceso comercial.

Eliminación destruye o remueve datos/tenant.

La baseline sólo aprueba suspensión no destructiva por falta de pago; no autoriza hard delete.

### Crédito IA vs suscripción

Créditos IA habilitan capacidad de operaciones IA cuando las demás condiciones están satisfechas.

La suscripción habilita acceso general al SaaS.

Ninguno sustituye al otro.

---

# 3. Ownership

Todo recurso comercial tenant-owned debe pertenecer inequívocamente a una `MaintenanceCompany`.

Conceptualmente deben poder resolverse correctamente:

- `Subscription`;
- entitlement;
- paid period;
- obligación de pago;
- Payment;
- Payment attempt;
- PaymentEvent una vez correlacionado;
- cancelación;
- reactivación;
- historial de pricing aplicado;
- conciliación tenant-specific;
- auditoría asociada.

La cadena de ownership no puede depender de un `tenant_id` afirmado por el navegador.

Un identificador externo de proveedor tampoco prueba ownership por sí mismo.

Antes de aplicar un efecto debe comprobarse que:

- el recurso local pertenece al tenant esperado;
- la referencia externa corresponde al mismo contexto comercial;
- la obligación satisfecha es la correcta;
- no existe una asociación cruzada con otro tenant.

No se diseñan claves físicas.

---

# 4. Actores y permisos

## 4.1 `COMPANY_ADMIN`

La baseline establece que `COMPANY_ADMIN` **administra la suscripción** de su empresa.

Ese permiso permite conceptualmente realizar las acciones necesarias para gestionar la relación comercial ordinaria dentro de su propio tenant, sujeto a las políticas aún abiertas.

### Capacidades compatibles con la baseline

`COMPANY_ADMIN` puede:

- consultar el estado comercial de su tenant;
- consultar si se encuentra en año promocional, período pago, gracia o suspensión;
- consultar la próxima fecha comercial cuando exista una regla aprobada para calcularla;
- consultar pagos e historial comercial de su tenant con el nivel necesario para administrar la suscripción;
- iniciar el flujo de contratación del único plan cuando corresponda;
- elegir modalidad mensual o anual al comenzar una contratación paga;
- iniciar una reactivación cuando el tenant esté inactivo y exista un flujo aprobado;
- iniciar una compra de créditos IA separada conforme a `08`, sin que eso sustituya la suscripción.

### Capacidades sujetas a decisiones todavía abiertas

No se consideran cerradas hasta resolver las políticas correspondientes:

- cancelar renovación o cancelar inmediatamente;
- cambiar mensual ↔ anual;
- solicitar o recibir prorrateo;
- solicitar o recibir refund;
- definir el efecto de cancelación sobre el período vigente;
- cambiar un método de pago futuro mediante un flujo del proveedor;
- decidir cómo regularizar deuda de varios períodos.

Un flujo futuro para actualizar método de pago puede ser iniciado por `COMPANY_ADMIN` si se aprueba como parte de administración ordinaria, pero este documento no le concede acceso a credenciales sensibles ni almacenamiento de PAN/CVV.

`COMPANY_ADMIN` no puede:

- modificar pagos históricos arbitrariamente;
- fabricar una confirmación;
- cambiar manualmente su tenant;
- otorgarse entitlement sin causa autorizada;
- editar eventos externos;
- eludir el proveedor o una regla de reconciliación;
- alterar pricing histórico aplicado;
- modificar créditos IA como sustituto de regularización de suscripción.

## 4.2 `TECHNICIAN`

`TECHNICIAN` no administra:

- suscripción;
- pagos;
- checkout;
- método de pago;
- renovación;
- cancelación;
- facturación comercial;
- historial de pagos por inferencia.

La suspensión del tenant afecta su acceso porque el entitlement es tenant-wide, no porque el técnico posea una capacidad comercial.

Cuando el tenant pasa a inactivo:

- `TECHNICIAN` pierde acceso online junto con los demás usuarios del tenant;
- su autorización offline previa sólo puede continuar bajo `DO-075`;
- no recibe una pantalla o permiso de administración comercial por estar bloqueado;
- el trabajo ya capturado no se elimina.

## 4.3 `SUPER_ADMIN`

`SUPER_ADMIN` es global y no pertenece a tenants.

La baseline permite que un `SupportAccessGrant` incluya el scope tenant-wide `suscripción/pagos`. Ese scope puede permitir acceso excepcional de soporte a la información comercial expresamente concedida, sin convertir a `SUPER_ADMIN` en administrador ordinario de la suscripción.

Puede existir necesidad operacional de:

- consultar un estado comercial para diagnóstico;
- revisar un evento o conciliación;
- investigar un pago confirmado no aplicado;
- ayudar a resolver una incidencia.

La baseline **NO** concede por inferencia a `SUPER_ADMIN`:

- activar manualmente un tenant;
- extender períodos;
- perdonar deuda;
- modificar pagos;
- emitir refunds;
- cambiar modalidad;
- crear una suscripción en nombre del tenant;
- fabricar una conciliación;
- alterar pricing;
- otorgar créditos IA.

La eventual capacidad excepcional de regularización global se mantiene en `PAY-OPEN-007`.

---

# 5. `Subscription` como bounded context

El bounded context Subscription & Payments es responsable de:

- ciclo comercial del tenant;
- entitlement;
- período promocional;
- modalidad mensual/anual;
- períodos pagados;
- obligaciones y pagos;
- gracia;
- suspensión;
- reactivación;
- cancelación/renovación cuando se aprueben;
- integración conceptual con el proveedor;
- `PaymentEvent`;
- conciliación.

No es responsable de:

- ejecución de mantenimientos;
- formularios;
- Evidence;
- Reporting;
- ledger de créditos IA;
- política de costos IA.

Conceptualmente existe una única relación comercial de suscripción por tenant para el único plan del MVP. Sin embargo, la baseline no determina completamente si esa relación debe representarse como una `Subscription` ya existente desde el alta o como un entitlement promocional separado que luego origina una `Subscription` paga.

Esa representación se mantiene abierta en `PAY-OPEN-008`.

La decisión física de tablas queda fuera del documento cualquiera sea la alternativa elegida.

---

# 6. Un único plan del MVP

El MVP ofrece **un único plan pago**.

Reglas cerradas:

- no existen tiers;
- no existen paquetes de funcionalidades SaaS diferenciados;
- no existe free tier permanente;
- no existe plan “básico/premium/enterprise”;
- las capacidades del plan son las definidas por la baseline del producto;
- las dos modalidades comerciales son mensual y anual;
- cambiar de mensual a anual no cambia las capacidades funcionales del SaaS.

La modalidad anual no implica por inferencia un descuento.

---

# 7. Año promocional a $0

Toda empresa nueva obtiene durante su primer año:

- las mismas capacidades SaaS del plan pago;
- entitlement comercial válido;
- precio de suscripción $0.

El período promocional:

- no es una suscripción pagada;
- no es un free tier permanente;
- no otorga créditos IA;
- no genera paquete inicial de créditos;
- no exige por baseline tarjeta o método de pago al alta;
- debe poseer inicio y fin deterministas una vez resueltas las decisiones temporales.

Durante ese año, el sistema debe poder conocer conceptualmente:

- tenant;
- inicio promocional;
- fin promocional esperado;
- entitlement vigente;
- ausencia de obligación de suscripción paga durante el período;
- si existe o no una configuración comercial futura preparada para el momento posterior, sin hacerla obligatoria antes de aprobación.

La transición posterior se trata formalmente en `DO-076`.

---

# 8. Inicio del año promocional

La baseline combina dos hechos:

- una empresa recién creada queda activa inmediatamente;
- toda empresa nueva recibe un año a $0.

Sin embargo, no especifica de forma inequívoca qué timestamp constituye el **ancla contractual** del año promocional.

Alternativas:

1. creación del tenant;
2. activación inicial del tenant;
3. verificación/completado del primer `COMPANY_ADMIN`;
4. primera operación de negocio.

### Evaluación

**Creación/activación del tenant** es objetiva, server-side y auditable. Además evita que el comienzo pueda postergarse indefinidamente por no completar onboarding.

**Primer admin verificado** refleja mejor el momento de uso efectivo, pero depende de un flujo de usuario y puede crear períodos promocionales muy largos si el alta queda incompleta.

**Primera operación** es todavía menos determinista y puede ser manipulable o difícil de explicar.

### Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** utilizar como ancla el momento autoritativo en que el tenant queda creado/activo por la plataforma, preservado históricamente y no editable por el tenant.

No se aprueba aquí. Se formaliza en `PAY-OPEN-001`.

---

# 9. Fin del período promocional

El fin promocional debe ser determinista, auditable y calculado con reglas comerciales explícitas.

Debe definirse:

- timezone comercial;
- si “un año” significa aniversario de calendario;
- instante exacto de cierre;
- qué ocurre si el ancla original es 29 de febrero;
- cómo se tratan fechas de fin de mes;
- cómo se expresa el primer instante sujeto a obligación paga.

No debe calcularse mediante:

- 365 días fijos por conveniencia;
- `updated_at`;
- fecha del primer pago posterior;
- timestamp de webhook;
- reloj del navegador.

### Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** usar un aniversario calendario en una timezone comercial única para el mercado argentino, con una regla explícita para 29 de febrero y fin de mes. El período promocional termina en el límite calendario correspondiente y la obligación posterior comienza en un instante no ambiguo inmediatamente siguiente.

El detalle exacto se mantiene en `PAY-OPEN-001`.

---

# 10. `DO-076` — transición al finalizar el primer año a $0

## 10.1 Pregunta

¿Qué ocurre cuando termina el año promocional y todavía no existe una suscripción paga confirmada?

La baseline exige que después del primer año el tenant requiera una suscripción paga, pero mantiene abierta la aplicación de los 20 días de gracia a esa primera obligación.

## 10.2 Alternativa 1 — obligación desde el fin promocional + 20 días de gracia

Al finalizar el año promocional nace la primera obligación paga. Si no existe pago confirmado en el vencimiento, comienza la gracia de 20 días.

**Ventajas:**

- reutiliza la misma semántica general de vencimiento;
- evita suspensión abrupta;
- permite notificaciones progresivas;
- no exige método de pago antes de terminar la promoción;
- es coherente con la propuesta ya registrada en `DO-076`.

**Riesgos:**

- debe quedar claro que el período promocional terminó aunque el acceso continúe temporalmente por gracia;
- requiere reglas exactas de due date y timezone.

## 10.3 Alternativa 2 — comenzar directamente una gracia comercial de 20 días

El día posterior al fin promocional se considera una etapa de gracia antes de exigir confirmación de pago.

**Ventaja:** UX similar a la alternativa 1.

**Riesgo:** puede difuminar la diferencia entre “la obligación ya venció” y “la obligación todavía no era exigible”. Esa ambigüedad complica histórico, notificaciones y conciliación.

## 10.4 Alternativa 3 — exigir contratación previa antes de terminar el año

El tenant debe configurar la suscripción paga antes del aniversario para evitar interrupción.

**Ventajas:**

- aumenta previsibilidad de renovación;
- reduce períodos sin medio de pago.

**Riesgos:**

- la baseline no exige tarjeta al alta ni contratación previa;
- podría convertir una preparación opcional en obligación no aprobada;
- genera fricción antes del final promocional.

## 10.5 Alternativa 4 — suspensión inmediata sin suscripción paga

El acceso se corta al finalizar el período promocional si no existe pago.

**Ventaja:** regla rígida y simple.

**Riesgos:**

- peor UX;
- alta posibilidad de pérdida de continuidad operativa;
- se aparta de la propuesta ya registrada en la baseline para `DO-076`;
- trata la primera obligación de forma más severa que otros vencimientos.

## 10.6 Notificaciones

Cualquiera sea la decisión debe permitir eventos de negocio para comunicar:

- proximidad del fin promocional;
- fecha de primera obligación paga;
- inicio de gracia si corresponde;
- proximidad del fin de gracia;
- suspensión.

El canal concreto permanece subordinado a `DO-073`.

## 10.7 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** adoptar la Alternativa 1.

Interpretación propuesta:

- el año $0 finaliza en su fecha comercial aprobada;
- en ese instante comienza la obligación paga;
- no se exige método de pago previamente por defecto;
- si la obligación no está confirmada al vencimiento, comienza una única gracia de 20 días;
- durante la gracia se conserva acceso normal y se informa riesgo de suspensión;
- agotada la gracia sin regularización, el tenant pasa a inactivo;
- un pago válido reconocido posteriormente reactiva conforme a la política aprobada.

**Estado de `DO-076`: PROPUESTA PENDIENTE DE APROBACIÓN.**

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

Esta recomendación no se considera aprobación de `DO-076` ni de los detalles temporales de `PAY-OPEN-001/003`.

---

# 11. Plan mensual

La modalidad mensual representa el único plan del MVP con billing period mensual.

Conceptualmente debe permitir:

- identificar el comienzo del período;
- calcular su fecha de renovación/vencimiento conforme a regla aprobada;
- asociar la obligación monetaria del período;
- reconocer un pago confirmado;
- detectar pending/failure;
- aplicar la gracia cuando corresponda;
- renovar o suspender conforme a políticas vigentes.

Un período mensual confirmado no debe extenderse dos veces por la misma confirmación.

La regla de día de mes para renovaciones iniciadas en fechas 29, 30 o 31 debe quedar definida con la política temporal de `PAY-OPEN-001`.

No se diseña un recurso de proveedor.

---

# 12. Plan anual

La modalidad anual representa el mismo plan funcional con un paid period anual.

Conceptualmente debe permitir:

- identificar comienzo y fin del período anual;
- calcular renovación calendario;
- reconocer el pago aplicable;
- aplicar fallo/gracia/suspensión de forma coherente;
- conservar el precio efectivamente aplicado a ese período.

La modalidad anual se considera conceptualmente pago anticipado del período comercial cubierto, sin que ello implique por inferencia un derecho a devolución proporcional.

Casos de aniversario 29 de febrero y fin de mes dependen de `PAY-OPEN-001`.

---

# 13. Elección mensual/anual

`COMPANY_ADMIN` puede elegir modalidad cuando inicia la contratación paga porque la baseline aprueba ambas modalidades y le asigna administración de la suscripción.

También puede necesitar elegir modalidad durante una reactivación si no existe un período pago vigente.

El cambio de una modalidad ya activa hacia otra depende de `DO-078` y no se resuelve por inferencia.

No se permite interpretar la elección mensual/anual como creación de distintos tiers.

---

# 14. Precio

El documento no fija valores monetarios.

El dominio debe poder representar conceptualmente:

- precio mensual en ARS;
- precio anual en ARS;
- versión o vigencia comercial del precio;
- precio exacto aplicado a cada obligación/período histórico;
- fecha o condición de efectividad de un precio futuro;
- modalidad a la que corresponde.

No debe reconstruirse un pago histórico consultando únicamente el precio global actual.

No se presupone descuento anual.

La política de cambios futuros se mantiene en `PAY-OPEN-002`.

---

# 15. Cambio de precio

La baseline no define:

- cómo se publican precios nuevos;
- si afectan sólo nuevos tenants;
- si afectan renovaciones existentes;
- cuánto aviso previo existe;
- si hay grandfathering;
- si el cambio se aplica al instante o en próxima renovación.

Principios que sí deben preservarse:

- un cambio futuro no reescribe períodos históricos;
- un pago pasado conserva el precio aplicado;
- no se cobra retroactivamente una diferencia por modificar configuración global;
- la UI y conciliación deben poder explicar el precio de cada período.

**PROPUESTA PENDIENTE DE APROBACIÓN:** usar precios globales versionados con fecha de vigencia; cada obligación fija el precio aplicable en el momento aprobado; cambios afectan obligaciones futuras y requieren política de aviso antes de implementarse.

Se formaliza en `PAY-OPEN-002`.

---

# 16. Entitlement comercial

El entitlement es la frontera entre el ciclo comercial y el acceso SaaS.

Conceptualmente deben distinguirse al menos estas situaciones, sin fijar un enum físico:

- promotional active;
- paid active;
- past due con grace vigente;
- inactive/suspended.

Situaciones como cancelled o expired pueden influir en el cálculo, pero su semántica final depende de `DO-078`.

Reglas:

- promotional active permite las capacidades aprobadas;
- paid active permite las capacidades aprobadas;
- grace vigente no reduce funcionalidades por inferencia;
- inactive bloquea acceso online tenant;
- entitlement no depende de saldo de créditos IA;
- entitlement no se deriva de callback frontend;
- entitlement se resuelve mediante estado local autoritativo sustentado en hechos comerciales válidos.

---

# 17. Pago exitoso

Un pago confirmado y válido puede:

- iniciar un paid period;
- renovar un período;
- regularizar un vencimiento;
- reactivar un tenant suspendido;
- confirmar una compra de créditos separada.

El efecto depende del propósito del pago y no debe aplicarse genéricamente.

Antes de producir efectos debe comprobarse:

- autenticidad/evidencia suficiente;
- identidad del pago;
- tenant correcto;
- obligación correcta;
- modalidad/período correcto cuando corresponda;
- que el mismo efecto no haya sido aplicado anteriormente.

Un redirect/callback del navegador nunca es prueba suficiente.

---

# 18. Pago pendiente

Pending no equivale a confirmed.

Un pago pendiente:

- no debe activar por sí solo un nuevo paid period;
- no debe extender período por sí solo;
- no debe acreditar créditos IA por sí solo;
- puede requerir nueva consulta/reconciliación;
- no debe degradarse o mejorarse sólo por el orden de llegada de notificaciones.

Si un pago queda pending durante una obligación vencida, la existencia del pending no debe reiniciar indefinidamente la gracia. La regla exacta se mantiene en `PAY-OPEN-003`.

---

# 19. Pago rechazado/fallido

Un pago fallido no elimina datos ni tenant.

Cuando corresponde a una obligación vencida su tratamiento debe ser coherente con la gracia de 20 días.

Un fallo puede generar:

- evento comercial de pago fallido;
- visibilidad para `COMPANY_ADMIN`;
- notificación conforme a la futura política de canales;
- continuidad de acceso mientras la gracia siga vigente;
- posterior suspensión si la deuda no se regulariza.

Un retry posterior es un intento nuevo o continuación técnica según el caso, no una excusa para duplicar efectos ni prolongar la gracia de forma indefinida.

---

# 20. Período de gracia de 20 días

La baseline aprobada establece literalmente:

- duración: **20 días**;
- no existe bloqueo inmediato tras un vencimiento aplicable;
- agotada la gracia sin regularización, el acceso online queda inactivo;
- la suspensión no elimina datos.

El documento debe además distinguir reglas todavía no cerradas:

- instante exacto desde el que se cuentan los 20 días;
- si se cuentan como duración exacta desde due date o por límites de días comerciales;
- si un retry reinicia o no el período;
- qué ocurre con un pending prolongado;
- qué ocurre ante una segunda obligación mientras existe deuda previa;
- cómo se documenta el deadline.

### Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** la gracia pertenece a la obligación impaga original y tiene un único `grace_started_at` conceptual derivado del vencimiento; retries, eventos duplicados y estados pending no reinician el reloj. Un pago confirmado antes del deadline regulariza; un pago confirmado después se trata como reactivación conforme a su política.

Se formaliza en `PAY-OPEN-003`.

---

# 21. Inicio de la gracia

Deben diferenciarse tres causas:

## 21.1 Renovación paga vencida

La baseline sí establece que tras vencer un pago existe gracia de 20 días.

La recomendación de `PAY-OPEN-003` es anclar el inicio al vencimiento autoritativo de esa obligación.

## 21.2 Fin del año promocional

Depende de `DO-076`.

Si se aprueba la propuesta de este documento, la primera obligación posterior al año $0 se comportará como un vencimiento sujeto a la misma gracia.

## 21.3 Pago fallido inicial de una nueva contratación/reactivación

La baseline no define si todo intento inicial fallido debe conceder gracia aun cuando el tenant ya estaba inactivo y no existía entitlement previo.

No debe inferirse que una persona pueda crear 20 días adicionales de acceso iniciando un checkout fallido sobre un tenant ya suspendido.

El tratamiento de reactivación/deuda se mantiene en `PAY-OPEN-004`.

---

# 22. Fin de la gracia

El fin de gracia debe ser determinista y auditable.

Debe derivarse de:

- inicio aprobado de la gracia;
- duración exacta de 20 días;
- timezone comercial aprobada;
- regla temporal aprobada.

No debe depender de:

- último retry;
- último webhook;
- `updated_at`;
- último login;
- hora del navegador.

Cuando el deadline se alcanza sin regularización válida, el estado comercial debe poder pasar a inactivo mediante un mecanismo técnico futuro consistente e idempotente.

Este documento no diseña cron, job ni scheduler.

---

# 23. Acceso durante gracia

Mientras la gracia esté vigente:

- el acceso online continúa;
- no se introduce reducción parcial de módulos;
- no se bloquea Reporting por inferencia;
- no se bloquea IA por inferencia siempre que sus propias condiciones de créditos/habilitación se satisfagan;
- debe existir un indicador visible de próxima suspensión conforme a `RF-169`;
- pueden existir eventos de notificación comercial.

La baseline no aprueba un “modo limitado” durante gracia.

---

# 24. Suspensión comercial

Cuando termina una gracia aplicable sin regularización:

- el entitlement online pasa a inactivo;
- todos los usuarios del tenant pierden acceso online;
- no se eliminan clientes, ubicaciones, equipos, formularios, mantenimientos, evidencias ni informes;
- no se elimina el historial comercial;
- la wallet IA permanece;
- el ledger IA permanece;
- los créditos no pasan a cero;
- los documentos históricos permanecen;
- no se inicia nueva IA de usuario;
- comprar créditos IA no reactiva por sí solo la suscripción.

Suspensión comercial no autoriza hard delete ni mutación de históricos.

---

# 25. Efecto sobre offline

Este documento consume `DO-075` sin modificarlo.

Reglas cerradas:

- un dispositivo puede poseer una autorización comercial offline previamente validada;
- esa autorización puede mantenerse como máximo 7 días desde la última validación online;
- una suspensión conocida por el servidor se aplica al reconectar/revalidar;
- superar 7 días exige conectividad y revalidación antes de iniciar nuevas operaciones;
- trabajo ya capturado no se elimina por suspensión ni por vencimiento de la lease;
- este documento no redefine `OFF-OPEN-001` ni `OFF-OPEN-002`.

Un tenant suspendido no obtiene una nueva lease offline válida por poseer datos locales o créditos IA.

---

# 26. Reactivación

La baseline exige que, cuando el sistema reconoce un pago válido de reactivación, el acceso se restablezca inmediatamente.

Conceptualmente una reactivación válida debe:

- asociarse al tenant correcto;
- identificar la obligación o nuevo período que justifica la reactivación;
- no depender de redirect frontend;
- ser idempotente;
- actualizar el entitlement una sola vez;
- conservar todos los datos existentes;
- devolver acceso a usuarios habilitados conforme a sus permisos ordinarios;
- conservar wallet y ledger IA existentes;
- permitir nuevas operaciones IA sólo si además IA está habilitada y existen créditos suficientes conforme a `08`.

No está definida la deuda necesaria para reactivar si transcurrieron varios períodos. Esa cuestión se mantiene en `PAY-OPEN-004`.

---

# 27. Cancelación voluntaria

La baseline no define la semántica de cancelación.

Alternativas:

- cancelación inmediata con fin anticipado de entitlement;
- cancelación efectiva al final del período ya pagado;
- cancelación de renovación automática manteniendo el período vigente;
- cancelación con refund/prorrateo, si se aprobara.

No se adopta una de estas alternativas fuera del tratamiento formal de `DO-078`.

---

# 28. Cancelación vs suspensión

**Cancelación** es una decisión voluntaria relacionada con no continuar la relación comercial o su renovación.

**Suspensión** es una consecuencia de falta de regularización comercial después de la gracia aprobada.

Deben diferenciarse en histórico y auditoría.

Una cancelación no implica necesariamente deuda.

Una suspensión no implica que el tenant haya solicitado cancelar.

Ninguna elimina datos.

---

# 29. `DO-078` — renovación, cancelación y prorrateo

## 29.1 Renovación

### Alternativa A — renovación automática

Mensual y anual renuevan automáticamente mientras la relación permanezca vigente y el proveedor pueda procesar la obligación.

**Ventajas:** continuidad y menor fricción.

**Riesgos:** exige una semántica clara de cancelación, fallos y notificaciones.

### Alternativa B — renovación manual

Cada período requiere acción explícita del administrador.

**Ventaja:** consentimiento evidente en cada ciclo.

**Riesgos:** alto riesgo operativo de suspensión accidental y más fricción para un SaaS recurrente.

## 29.2 Cancelación

### Inmediata

Termina entitlement al confirmar cancelación.

**Riesgos:** requiere decidir refund/prorrateo y puede quitar acceso ya pagado.

### Fin de período

Cancela la renovación futura y mantiene entitlement hasta el final del período ya pagado.

**Ventajas:** simple, predecible y evita prorrateo por defecto.

## 29.3 Cambio mensual → anual

Alternativas:

- inmediato con ajuste/prorrateo;
- efectivo en próxima renovación;
- cancelar y crear un nuevo período.

## 29.4 Cambio anual → mensual

Alternativas equivalentes, con mayor riesgo de refund si se intenta cambio inmediato durante un período anual ya pagado.

## 29.5 Prorrateo

Alternativas:

1. no prorratear;
2. crédito proporcional interno;
3. ajuste monetario inmediato;
4. reglas diferentes según dirección del cambio.

## 29.6 Refund

Alternativas:

- ninguno automático por cancelación ordinaria;
- refund proporcional;
- refund sólo excepcional por soporte/legal/proveedor;
- reglas específicas según incidentes.

No se inventan obligaciones legales.

## 29.7 Reactivación después de cancelación

Debe diferenciarse:

- reanudar renovación antes de que termine el período todavía activo;
- contratar nuevamente después de que el período haya terminado;
- reactivar después de suspensión por falta de pago.

No todos son el mismo flujo.

## 29.8 Recomendación para MVP

**PROPUESTA PENDIENTE DE APROBACIÓN:**

- renovación automática para mensual y anual;
- cancelación ordinaria como “no renovar”, efectiva al final del período pagado;
- mantener entitlement hasta ese fin de período;
- cambios mensual ↔ anual efectivos en la siguiente renovación, sin ajuste monetario intra-período;
- no prorrateo automático en MVP;
- no refund automático por cancelación ordinaria;
- refunds sólo mediante política excepcional que deba aprobarse y cumpla obligaciones legales/proveedor aplicables;
- permitir revertir una cancelación programada antes del fin del período si técnicamente/comercialmente sigue siendo posible;
- reactivación posterior al fin se trata como nueva activación paga, sujeta a `PAY-OPEN-004` cuando exista deuda.

Esta propuesta busca reducir estados intermedios, evitar cálculos prorrateados y preservar un histórico auditable.

**Estado de `DO-078`: PROPUESTA PENDIENTE DE APROBACIÓN.**

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

No se aprueba prorrateo, refund ni renovación automática por la mera existencia de esta recomendación.

---

# 30. Pago anticipado

La modalidad anual puede conceptualizarse como pago anticipado del período anual cubierto.

Esto permite comprender que el tenant ya ha pagado por un intervalo futuro determinado.

No se deduce de ello:

- derecho automático a refund proporcional;
- derecho automático a crédito si cancela;
- prorrateo;
- descuento.

Esas políticas dependen de `DO-078`.

---

# 31. Método de pago

El método de pago se trata conceptualmente como información gestionada o tokenizada por el proveedor siempre que la integración concreta lo permita.

Principios:

- la plataforma no debe almacenar PAN/CVV por inferencia;
- no debe exponer secretos del proveedor al navegador;
- `COMPANY_ADMIN` puede iniciar una futura actualización de método de pago sólo mediante un flujo autorizado;
- el sistema puede conservar referencias no sensibles necesarias para correlación/UX si el diseño futuro lo requiere;
- conocer una referencia de método de pago no concede autorización para usarla en otro tenant.

No se diseña token, vault ni PCI implementation.

---

# 32. Proveedor Mercado Pago

Mercado Pago es el proveedor de pagos previsto para el MVP.

Debe integrarse mediante una frontera conceptual de adapter que traduzca entre:

- capacidades/estados externos;
- conceptos internos de Subscription & Payments.

El dominio no debe depender directamente de nombres específicos de estados externos.

Esto permite que:

- las reglas de entitlement permanezcan internas;
- un cambio de API/SDK no reescriba el dominio;
- los eventos puedan normalizarse;
- la conciliación compare significados sin acoplar autorización a etiquetas externas.

No se selecciona SDK, API, checkout ni recurso específico.

---

# 33. Local commercial state vs external provider state

La plataforma debe mantener una traducción explícita entre evidencia externa y estado comercial local.

Regla fundamental:

> El estado externo es una entrada autoritativa relevante, pero no es por sí solo el estado de negocio del SaaS.

Ejemplos conceptuales:

- un proveedor puede informar un pago como aprobado; la plataforma todavía debe resolver tenant, obligación e idempotencia antes de activar;
- un evento antiguo puede informar pending después de que ya existe confirmación más fuerte; no debe degradar localmente el entitlement;
- un recurso externo puede quedar cancelado mientras el tenant conserva un período ya pagado hasta su fin, si `DO-078` aprueba esa semántica.

El estado comercial local debe ser explicable por hechos, no por copiar un string de proveedor.

---

# 34. `PaymentEvent`

`PaymentEvent` representa una observación procesable relacionada con el proveedor o con una transición de pagos.

Debe permitir conceptualmente conservar suficiente información para:

- identificar su origen;
- verificar autenticidad;
- deduplicar;
- correlacionar con recurso externo;
- resolver tenant;
- resolver Subscription/Payment/compra de créditos correcta;
- conocer orden causal o temporal cuando el proveedor lo permita;
- registrar resultado de procesamiento;
- reconciliar después;
- auditar efectos.

No debe producir efectos tenant si el ownership permanece ambiguo.

No se diseña tabla, payload ni enum.

---

# 35. `DO-T02` — state machine conceptual de procesamiento de pagos

## 35.1 Objetivo

Definir una máquina conceptual robusta frente a webhooks duplicados, retries, eventos fuera de orden, pérdida de eventos y divergencias.

## 35.2 Flujo conceptual propuesto

**Evento externo recibido → verificación de autenticidad → deduplicación → resolución de entidad/tenant → confirmación autoritativa cuando corresponda → evaluación contra estado ya aplicado → aplicación idempotente del efecto permitido → actualización de estado comercial local → auditoría → reconciliación posterior cuando sea necesaria.**

Este flujo describe responsabilidades, no endpoints ni implementación.

## 35.3 Verificación

Antes de producir un efecto:

- validar que el evento proviene de una fuente aceptable conforme al mecanismo oficial futuro;
- validar integridad/autenticidad según las garantías del proveedor;
- no confiar en campos críticos sólo porque existan en el payload;
- cuando sea necesario, consultar el recurso autoritativo del proveedor en lugar de tratar el webhook como verdad autosuficiente.

## 35.4 Deduplicación

La misma notificación puede llegar varias veces.

El procesamiento debe reconocer identidad estable suficiente para que repetirla no produzca:

- segundo paid period;
- segunda reactivación;
- segundo crédito IA;
- segundo pago interno;
- segundo refund;
- side effects duplicados.

## 35.5 Resolución de entidad

Un evento verificado todavía debe resolverse hacia:

- propósito comercial;
- tenant;
- Payment;
- Subscription o compra de créditos correspondiente.

Si no puede resolverse de manera inequívoca, no debe aplicarse a un tenant arbitrario.

## 35.6 Confirmación autoritativa

Según el tipo de evento y las garantías futuras del proveedor, puede ser necesario leer el recurso externo autoritativo antes de aplicar el efecto.

La arquitectura debe permitir ese paso sin depender del payload recibido como única verdad.

## 35.7 Aplicación idempotente

Un efecto comercial se aplica una sola vez por causa lógica.

Reprocesar el mismo evento o volver a consultar el mismo pago debe converger al mismo resultado.

## 35.8 Fuera de orden

La aplicación no debe decidir por “último webhook recibido”.

Debe comparar:

- evidencia autoritativa;
- estado previamente confirmado;
- temporalidad/versión del proveedor cuando exista;
- transición de dominio permitida.

Un pending antiguo no debe degradar un approved ya confirmado.

## 35.9 Evento perdido

El sistema no puede asumir entrega exactamente una vez.

Debe existir reconciliación capaz de descubrir:

- pagos confirmados sin evento aplicado;
- cancelaciones externas no conocidas;
- divergencia de suscripción;
- eventos locales sin contraparte esperada.

## 35.10 Callback frontend

El callback/redirect puede:

- mostrar “estamos verificando”;
- disparar una consulta del estado local;
- mejorar la experiencia.

No puede:

- activar tenant;
- extender período;
- acreditar créditos;
- marcar pago como confirmed por sí solo.

## 35.11 Reintentos

Debe distinguirse:

- retry del proveedor del mismo cobro;
- webhook reenviado;
- polling/reconciliación del mismo recurso;
- nuevo intento de pago del usuario.

Sólo una causa comercial nueva puede producir un nuevo efecto.

## 35.12 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** adoptar el flujo conceptual descrito y exigir que el futuro ADR de Fase 8 documente:

- identidad idempotente;
- autoridad de verificación;
- criterio de orden/precedencia;
- transiciones permitidas;
- reconciliación;
- observabilidad de eventos no resueltos.

**Estado de `DO-T02`: PROPUESTA PENDIENTE DE APROBACIÓN.**

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

No se marca RESUELTA/APROBADA.

---

# 36. Webhooks

Principios obligatorios:

- verificar autenticidad antes de efectos;
- no confiar ciegamente en el payload;
- procesar idempotentemente;
- tolerar duplicados;
- tolerar out-of-order;
- tolerar retries;
- correlacionar tenant y propósito;
- no bloquear innecesariamente la recepción mientras se realiza trabajo que pueda diferirse, sin fijar una queue concreta;
- registrar fallos suficientes para reconciliación;
- nunca utilizar webhook como bypass de autorización tenant.

La respuesta HTTP, arquitectura de colas y handler quedan fuera de alcance.

---

# 37. Callback/redirect del frontend

El redirect del navegador **NO constituye prueba de pago**.

Su función puede limitarse a UX:

- informar que el pago está siendo verificado;
- mostrar estado local ya confirmado;
- permitir volver a la pantalla comercial.

No debe aceptar parámetros de URL como autoridad para:

- tenant;
- monto;
- payment status;
- subscription status;
- créditos.

---

# 38. Eventos duplicados

Un evento duplicado debe converger sin duplicar efectos.

No debe crear por segunda vez:

- paid period;
- renovación;
- reactivación;
- Payment;
- crédito IA;
- refund;
- auditoría semánticamente falsa de una nueva operación.

Puede registrarse técnicamente que se recibió un duplicado, pero eso no es un nuevo hecho comercial.

---

# 39. Eventos fuera de orden

Escenario obligatorio de diseño:

- se confirma un pago;
- el entitlement se actualiza;
- posteriormente llega un evento pending más antiguo.

El sistema no debe degradar el estado sólo porque ese evento llegó después.

La estrategia conceptual debe basarse en:

- identidad del recurso;
- estado autoritativo actual cuando sea necesario;
- versión/tiempo del proveedor si existe garantía utilizable;
- monotonicidad de hechos confirmados cuando corresponda;
- transiciones de dominio válidas.

El orden de recepción es metadata, no autoridad de negocio.

---

# 40. Evento perdido

Debe asumirse que algún webhook puede no llegar.

Por ello:

- no se depende de entrega exactly-once;
- un pago confirmado debe poder descubrirse posteriormente;
- una divergencia debe ser detectable;
- la conciliación debe poder aplicar de forma idempotente un efecto faltante;
- la ausencia de evento no autoriza inventar un estado.

---

# 41. Reconciliación

La reconciliación debe comparar conceptualmente:

- Subscription local;
- entitlement local;
- paid periods;
- Payment locales;
- eventos conocidos;
- estado autoritativo disponible en Mercado Pago;
- obligaciones pendientes;
- compra de créditos cuando corresponda.

Resultados conceptuales posibles:

- consistente;
- falta aplicar un efecto confirmado;
- existe efecto local sin evidencia externa suficiente;
- estado externo cambió y requiere política;
- recurso no puede correlacionarse;
- necesita revisión excepcional.

La reconciliación debe ser idempotente y auditable.

No se diseña job/worker concreto.

---

# 42. Payment retry

Debe distinguirse:

## Retry del proveedor

Reintento automático relacionado con la misma obligación.

## Nuevo intento de pago

Nueva interacción del usuario para satisfacer una obligación todavía pendiente.

## Evento duplicado

Reentrega de la misma observación.

Estas situaciones pueden producir múltiples identificadores externos, pero no deben generar múltiples paid periods por la misma obligación.

Los retries no deben reiniciar indefinidamente la gracia si `PAY-OPEN-003` se aprueba según recomendación.

---

# 43. Pago confirmado dos veces

Si el mismo pago o la misma obligación aparece confirmada dos veces:

- el entitlement se extiende una sola vez;
- la reactivación ocurre una sola vez;
- el paid period se reconoce una sola vez;
- una compra de créditos acredita una sola vez;
- la segunda confirmación converge como duplicado o confirmación ya aplicada.

Esta invariante es obligatoria independientemente de la integración concreta.

---

# 44. Pago incorrecto / tenant incorrecto

Nunca debe aplicarse un pago de Tenant A a Tenant B.

Antes de aplicar un pago deben coincidir las relaciones autoritativas requeridas.

Un identificador externo válido no basta.

Si existe inconsistencia de ownership:

- no aplicar el efecto;
- preservar evidencia para diagnóstico;
- registrar incidente/reconciliación;
- evitar “corregir” el tenant mediante input de navegador.

---

# 45. Refund monetario

Un refund es un hecho monetario del bounded context Payments.

Debe distinguirse de:

- compensación de `AIUsageOperation`;
- liberación de una reserva IA;
- grant/adjustment de créditos;
- cancelación de renovación;
- suspensión.

No existe una política aprobada de refund por cancelación o cambio de modalidad.

Cualquier refund futuro debe:

- preservar el pago original históricamente;
- registrar la reversión como nuevo hecho;
- tener tenant y motivo inequívocos;
- conciliarse con el proveedor;
- definir explícitamente su efecto sobre entitlement y, si se tratara de compra de créditos, sobre créditos ya consumidos.

La política se mantiene en `DO-078`.

---

# 46. Chargeback/dispute

Chargeback/dispute es relevante porque puede cuestionar un pago que ya produjo entitlement.

La baseline no define si debe:

- suspender inmediatamente;
- iniciar gracia;
- mantener acceso mientras se investiga;
- crear deuda;
- requerir intervención.

No debe aplicarse una política legal o financiera inventada.

**PROPUESTA PENDIENTE DE APROBACIÓN:** tratar chargeback/dispute como evento de reconciliación comercial que no destruye datos y que sólo modifica entitlement mediante una política explícitamente aprobada. Evitar suspensión inmediata basada únicamente en una notificación no reconciliada.

Se formaliza en `PAY-OPEN-006`.

---

# 47. Relación con créditos IA

Subscription & Payments y AI Credits permanecen separados.

Reglas:

- la suscripción no incluye créditos automáticamente;
- el año $0 no incluye créditos;
- tener créditos no sustituye una suscripción válida;
- saldo IA 0 no suspende el SaaS;
- refund de suscripción no es compensación IA;
- una compra de créditos confirmada puede originar movimiento de ledger, pero el ledger pertenece a `08`;
- `PaymentEvent` puede compartir un patrón de ingesta/verificación con pagos de créditos, sin fusionar los bounded contexts;
- no se modifica `DO-T01`.

---

# 48. Compra de créditos y Mercado Pago

Este documento define sólo fronteras comunes de pago.

Para una compra de créditos:

- `COMPANY_ADMIN` puede iniciar el flujo comercial autorizado;
- el pago pertenece al tenant correcto;
- pending/failure no acredita;
- confirmación válida puede acreditar exactamente una vez;
- callback frontend no acredita;
- reconciliación debe ser posible;
- el ledger resultante pertenece a `08`.

Este documento **NO resuelve**:

- tamaños de paquetes;
- precios de paquetes;
- bonus;
- expiración;
- grants/promociones;
- catálogo.

`AI-OPEN-006` permanece abierta.

---

# 49. Estado comercial y compra de créditos

La baseline de `08` deja abierta la compra de créditos mientras el tenant está suspendido.

Alternativas:

1. permitir compra de créditos aunque el SaaS esté suspendido;
2. permitirla sólo dentro de una superficie comercial restringida de recuperación;
3. impedir nuevas compras hasta reactivar la suscripción.

### Evaluación

Permitir compras puede ser útil para preparar saldo futuro, pero puede confundir al cliente porque esos créditos no reactivan el SaaS y no pueden utilizarse mientras el tenant siga inactivo.

Impedirlas simplifica UX y evita vender capacidad temporalmente inutilizable, pero obliga a reactivar primero la suscripción.

### Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** no permitir nuevas compras de créditos IA mientras el tenant permanezca comercialmente inactivo; permitir únicamente acceso comercial necesario para regularizar la suscripción. Una vez reactivado, `COMPANY_ADMIN` puede comprar créditos normalmente.

Se formaliza en `PAY-OPEN-005`.

---

# 50. Estado comercial y Report

Un tenant inactivo no obtiene acceso online para generar, finalizar, regenerar o descargar nuevos Reports mediante interacción normal de usuario.

La suspensión no elimina:

- Reports existentes;
- ReportVersion;
- snapshots;
- PDF/DOCX históricos.

Al reactivarse, los permisos ordinarios vuelven a aplicar sobre esos históricos.

---

# 51. Estado comercial e IA

Un tenant inactivo no inicia nuevas operaciones IA de usuario.

La suspensión no elimina:

- wallet;
- ledger;
- operaciones históricas;
- saldo existente.

Procesos backend de reconciliación o settlement necesarios para cerrar operaciones previamente admitidas pueden completarse para preservar consistencia, sin constituir nuevo acceso del usuario.

---

# 52. Notificaciones comerciales

Existen eventos de negocio que merecen comunicación:

- fin próximo del año $0;
- aproximación de primera obligación paga;
- próximo cobro/renovación cuando la política se apruebe;
- pago pendiente que requiera acción;
- pago fallido;
- inicio de gracia;
- gracia próxima a vencer;
- suspensión;
- reactivación;
- cancelación programada;
- cambio futuro de precio cuando la política lo requiera.

Este documento no fija canal.

`DO-073` permanece DIFERIDA y debe resolver el alcance de notificaciones push antes de Fase 9.

Puede existir email u otro canal en el futuro, pero no se aprueba aquí.

---

# 53. Facturación fiscal

El hecho de operar en Argentina puede implicar obligaciones fiscales, comprobantes o integración con sistemas regulatorios.

Este documento no define:

- factura electrónica;
- AFIP/ARCA;
- tipo de comprobante;
- numeración fiscal;
- régimen impositivo;
- datos fiscales obligatorios.

Debe registrarse como riesgo/decisión legal-comercial previa a producción cuando corresponda.

No se confunde Payment con comprobante fiscal.

---

# 54. Impuestos

No se inventan reglas de:

- IVA;
- percepciones;
- retenciones;
- impuestos provinciales;
- tratamiento de consumidor/empresa;
- gross-up;
- precios netos/brutos.

La definición fiscal debe realizarse mediante validación legal/contable futura y no por arquitectura de software.

---

# 55. Moneda

La moneda inicial del MVP es **ARS**.

No se diseña:

- conversión;
- multi-moneda;
- USD;
- FX;
- pricing por país.

Cada precio y pago comercial del MVP debe interpretarse en ARS conforme a la configuración vigente.

---

# 56. Timezone comercial

La timezone comercial afecta:

- inicio/fin del año promocional;
- aniversarios;
- due dates;
- renovación mensual;
- renovación anual;
- inicio/fin de gracia;
- cancelación al final de período;
- efectividad de precio futuro.

La baseline no fija una timezone comercial explícita.

### Alternativas

1. UTC para toda semántica comercial;
2. timezone argentina única para el mercado inicial;
3. timezone configurable por tenant.

### Evaluación

UTC es técnicamente simple pero menos intuitiva para obligaciones de negocio locales.

Timezone configurable por tenant agrega complejidad no requerida en un mercado único.

Una timezone argentina única ofrece reglas explicables y consistentes sin multizona tenant.

### Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** definir una timezone comercial única para el MVP Argentina y usarla para límites calendario; persistir instantes autoritativos de forma no ambigua en el diseño físico futuro.

Se integra en `PAY-OPEN-001`.

---

# 57. Auditoría

Deben ser trazables conceptualmente, como mínimo:

- inicio del plan pago;
- elección mensual/anual;
- cambio de modalidad cuando se apruebe;
- cancelación solicitada/programada/efectiva;
- reactivación;
- pago confirmado;
- pago fallido relevante;
- inicio de gracia;
- fin de gracia;
- suspensión;
- reanudación de renovación si se aprueba;
- cambio de precio aplicado a obligaciones futuras;
- reconciliación que produce un cambio comercial;
- conflicto de pago cross-tenant detectado;
- cualquier acción excepcional de `SUPER_ADMIN` si se aprueba.

La auditoría debe permitir identificar:

- actor o fuente;
- tenant afectado;
- acción;
- momento;
- motivo/contexto;
- estado anterior/posterior cuando resulte útil.

No se diseña `AuditEvent` físico.

---

# 58. Seguridad

Principios obligatorios:

- aislamiento tenant;
- autorización server-side/DB coherente con `03`;
- no confiar en `tenant_id` frontend;
- no confiar en path/URL como autorización;
- no utilizar `service-role` como bypass normal para operaciones tenant;
- secretos exclusivamente server-side;
- verificar proveedor antes de efectos;
- idempotencia;
- validar ownership de referencias externas;
- minimizar privilegios;
- no copiar estado del proveedor directamente a autorización;
- no permitir que un callback de navegador produzca efectos comerciales;
- mantener trazabilidad de operaciones privilegiadas;
- impedir que support scope se convierta en omnipotencia global.

El diseño físico posterior debe incluir pruebas negativas cross-tenant.

---

# 59. Datos sensibles de pago

La plataforma no debe almacenar por inferencia:

- PAN completo;
- CVV;
- credenciales de tarjeta;
- secretos del proveedor;
- datos sensibles innecesarios.

Si Mercado Pago permite tokenización/gestión externa, el diseño debe priorizar esa frontera.

No se diseña cumplimiento PCI ni vault propio en este documento.

Los logs tampoco deben exponer secretos o payloads sensibles completos por comodidad de debugging.

---

# 60. Historial comercial

Debe ser posible interpretar históricamente:

- período promocional;
- modalidad de cada paid period;
- precio aplicado;
- due date;
- payment attempts;
- pago confirmado;
- fallos;
- pending relevante;
- inicio y fin de gracia;
- suspensión;
- reactivación;
- cancelación y fecha efectiva;
- cambios de modalidad;
- refunds/chargebacks si se aprueban;
- reconciliaciones que corrigieron divergencias.

El histórico no debe depender exclusivamente del estado mutable actual.

No se diseña UI.

---

# 61. Cambios posteriores de precio

Un precio nuevo nunca reescribe:

- paid periods anteriores;
- pagos anteriores;
- documentos/auditoría que registraron precio aplicado;
- obligaciones ya fijadas según la política aprobada.

El sistema debe poder explicar por qué dos períodos históricos tuvieron distintos precios aunque compartan el mismo único plan.

La política de efectividad se mantiene en `PAY-OPEN-002`.

---

# 62. Eliminación de tenant

Cancelación, expiración, falta de pago y suspensión **NO** equivalen a eliminación de tenant.

Este documento no autoriza:

- hard delete;
- purga automática por deuda;
- borrado de wallet/ledger;
- borrado de Reports;
- borrado de mantenimientos;
- borrado de Evidence.

Una política futura de cierre/eliminación de cuenta requerirá requisitos legales y de retención propios.

---

# 63. Testing futuro obligatorio

La futura implementación deberá incluir, como mínimo, pruebas de dominio, autorización, integración y regresión para:

- tenant ownership de Subscription;
- tenant ownership de Payment;
- tenant ownership de PaymentEvent aplicado;
- `COMPANY_ADMIN` autorizado;
- `TECHNICIAN` rechazado para administración comercial;
- `SUPER_ADMIN` ordinario rechazado;
- `SUPER_ADMIN` con support grant limitado a lo expresamente permitido;
- año $0;
- evento de inicio promocional conforme a la futura resolución aprobada de `PAY-OPEN-001`;
- aniversario normal;
- 29 de febrero;
- fechas 29/30/31 y fin de mes;
- modalidad mensual;
- modalidad anual;
- pago confirmado;
- pending;
- failure;
- gracia exactamente 20 días;
- inicio de gracia;
- fin de gracia;
- retries que no reinician indebidamente gracia según decisión aprobada;
- suspensión;
- datos preservados en suspensión;
- reactivación;
- cancelación conforme a la futura resolución aprobada de `DO-078`;
- renovación conforme a la futura resolución aprobada de `DO-078`;
- cambio mensual/anual;
- prorrateo o ausencia de prorrateo según decisión;
- refund según política aprobada;
- callback frontend no autoritativo;
- webhook válido;
- webhook inválido;
- firma/autenticidad inválida;
- evento duplicado;
- evento fuera de orden;
- pending antiguo posterior a confirmación;
- evento perdido;
- reconciliación;
- doble confirmación;
- mismo pago procesado dos veces;
- cross-tenant payment;
- evento imposible de correlacionar;
- `DO-075` y máximo offline 7 días;
- suspensión conocida al reconectar;
- trabajo local no eliminado;
- créditos IA preservados;
- suscripción no incluye créditos;
- año $0 no incluye créditos;
- tenant inactivo no inicia IA;
- compra de créditos con tenant suspendido conforme a la futura resolución aprobada de `PAY-OPEN-005`;
- ARS;
- pricing histórico;
- cambio de precio no retroactivo;
- chargeback/dispute según política aprobada;
- regularización excepcional de `SUPER_ADMIN` si se aprueba.

No se escriben tests en este documento.

---

# 64. Anti-patrones prohibidos

Quedan expresamente prohibidos:

- usar redirect/callback frontend como confirmación de pago;
- confiar ciegamente en webhook;
- no verificar autenticidad;
- aplicar un webhook duplicado dos veces;
- depender del orden de llegada para determinar estado final;
- usar un estado de Mercado Pago directamente como estado de dominio sin traducción;
- extender un período dos veces por el mismo pago;
- pagar Tenant A y activar Tenant B;
- eliminar datos por falta de pago;
- borrar créditos IA al suspender;
- permitir que créditos IA sustituyan una suscripción válida;
- incluir créditos IA en el año $0;
- dar IA gratis por suscripción por inferencia;
- suspender inmediatamente un vencimiento ignorando la gracia aprobada de 20 días;
- extender la gracia indefinidamente por retries;
- usar `updated_at` como verdad comercial;
- mezclar refund monetario con compensación IA;
- hardcodear el precio histórico consultando sólo configuración actual;
- mutar el precio aplicado a períodos pasados;
- dar administración de pagos a `TECHNICIAN`;
- confiar en `tenant_id` del frontend;
- confiar en path/URL externa para ownership;
- exponer secretos de Mercado Pago;
- almacenar PAN/CVV directamente por conveniencia;
- utilizar `service-role` como bypass normal;
- permitir a `SUPER_ADMIN` modificar estados arbitrariamente;
- resolver silenciosamente `DO-*` o `PAY-OPEN-*`;
- inventar múltiples planes;
- inventar descuento anual;
- inventar free tier permanente;
- inventar tarjeta obligatoria antes del fin promocional;
- inventar reglas fiscales;
- confundir cancelación con suspensión;
- confundir un pending con confirmed;
- depender de recepción exactly-once de webhooks;
- acreditar créditos por pago no confirmado;
- reactivar suscripción por compra de créditos.

---

# 65. Riesgos

## `PAY-RSK-001` — Ancla promocional ambigua

**Riesgo:** dos implementaciones calculan el primer año desde momentos distintos.

**Tratamiento:** resolver `PAY-OPEN-001` y conservar ancla autoritativa.

## `PAY-RSK-002` — Aniversario/calendario ambiguo

**Riesgo:** 29 de febrero o fin de mes produce vencimientos distintos.

**Tratamiento:** regla calendario explícita en `PAY-OPEN-001`.

## `PAY-RSK-003` — Timezone incorrecta

**Riesgo:** suspensión o renovación ocurre horas antes/después de lo esperado.

**Tratamiento:** timezone comercial única aprobada y tests de límites.

## `PAY-RSK-004` — Doble cobro

**Riesgo:** retries o flujos duplicados generan obligaciones/cargos redundantes.

**Tratamiento:** identidad comercial e idempotencia end-to-end.

## `PAY-RSK-005` — Doble activación/extensión

**Riesgo:** un pago confirmado dos veces extiende entitlement dos veces.

**Tratamiento:** efecto idempotente por obligación/pago.

## `PAY-RSK-006` — Evento duplicado

**Riesgo:** webhook reenviado aplica un segundo efecto.

**Tratamiento:** deduplicación y `DO-T02`.

## `PAY-RSK-007` — Evento fuera de orden

**Riesgo:** pending antiguo degrada un estado confirmado.

**Tratamiento:** precedencia autoritativa y no usar arrival order.

## `PAY-RSK-008` — Webhook falso o manipulado

**Riesgo:** atacante activa tenant o acredita créditos.

**Tratamiento:** verificación, consulta autoritativa cuando corresponda y ownership.

## `PAY-RSK-009` — Evento perdido

**Riesgo:** pago válido nunca produce efecto local.

**Tratamiento:** reconciliación.

## `PAY-RSK-010` — Pago confirmado no aplicado

**Riesgo:** cliente paga pero permanece suspendido.

**Tratamiento:** reconciliación, observabilidad y re-aplicación idempotente.

## `PAY-RSK-011` — Estado local divergente del proveedor

**Riesgo:** acceso o deuda no coinciden con realidad externa.

**Tratamiento:** adapter, reconciliación y auditoría.

## `PAY-RSK-012` — Gracia calculada incorrectamente

**Riesgo:** suspensión prematura o tardía.

**Tratamiento:** resolver `PAY-OPEN-003`, timezone y tests de frontera.

## `PAY-RSK-013` — Suspensión prematura

**Riesgo:** se bloquea antes de completar los 20 días.

**Tratamiento:** deadline autoritativo e invariantes.

## `PAY-RSK-014` — Tenant activo demasiado tiempo

**Riesgo:** retries/pending reinician gracia o falta proceso de cierre.

**Tratamiento:** gracia no renovable por retry según propuesta y reconciliación.

## `PAY-RSK-015` — Reactivación incorrecta

**Riesgo:** pago insuficiente, ajeno o duplicado reactiva acceso.

**Tratamiento:** `PAY-OPEN-004`, ownership y confirmación autoritativa.

## `PAY-RSK-016` — Cambio de modalidad ambiguo

**Riesgo:** mensual/anual solapan períodos o cobran dos veces.

**Tratamiento:** resolver `DO-078` antes de implementación.

## `PAY-RSK-017` — Prorrateo incorrecto

**Riesgo:** cálculos monetarios difíciles de conciliar.

**Tratamiento:** no implementar hasta resolver `DO-078`.

## `PAY-RSK-018` — Refund inconsistente

**Riesgo:** se devuelve dinero sin actualizar correctamente histórico/entitlement.

**Tratamiento:** política explícita, evento compensatorio y conciliación.

## `PAY-RSK-019` — Cross-tenant payment

**Riesgo:** un pago activa o acredita otro tenant.

**Tratamiento:** ownership derivado, validación de referencias y tests negativos.

## `PAY-RSK-020` — Precio histórico perdido

**Riesgo:** no puede explicarse un pago antiguo.

**Tratamiento:** preservar precio aplicado y versión comercial.

## `PAY-RSK-021` — Precio cambia retroactivamente

**Riesgo:** actualizar configuración reinterpreta períodos anteriores.

**Tratamiento:** pricing versionado y obligaciones históricas inmutables.

## `PAY-RSK-022` — Datos eliminados por suspensión

**Riesgo:** lógica de cleanup confunde inactividad con baja.

**Tratamiento:** prohibición expresa y pruebas.

## `PAY-RSK-023` — Créditos IA afectados incorrectamente

**Riesgo:** suspensión pone saldo en cero o mezcla refunds.

**Tratamiento:** bounded contexts separados y ledger inmutable.

## `PAY-RSK-024` — Método de pago sensible expuesto

**Riesgo:** PAN/CVV o secretos quedan en DB/logs/frontend.

**Tratamiento:** provider-managed/tokenized boundary y minimización.

## `PAY-RSK-025` — Reconciliación incompleta

**Riesgo:** divergencias persisten sin detección.

**Tratamiento:** catálogo de inconsistencias y observabilidad futura.

## `PAY-RSK-026` — Chargeback con efecto destructivo incorrecto

**Riesgo:** una disputa elimina acceso/datos sin política aprobada.

**Tratamiento:** `PAY-OPEN-006` y reconciliación.

## `PAY-RSK-027` — Regularización global abusiva

**Riesgo:** `SUPER_ADMIN` obtiene capacidad de alterar comerciales sin límites.

**Tratamiento:** `PAY-OPEN-007`, mínimo privilegio y auditoría.

## `PAY-RSK-028` — Venta de créditos a tenant suspendido sin claridad

**Riesgo:** cliente compra saldo que no puede usar y cree que reactivará el SaaS.

**Tratamiento:** resolver `PAY-OPEN-005` y UX explícita.

## `PAY-RSK-029` — Fin promocional inconsistente con `DO-076`

**Riesgo:** implementación suspende inmediatamente aunque se apruebe gracia.

**Tratamiento:** resolver `DO-076` y separar fin promocional de grace.

## `PAY-RSK-030` — Obligaciones fiscales no contempladas

**Riesgo:** sistema de pagos entra en producción sin tratamiento fiscal válido.

**Tratamiento:** validación legal/contable antes de producción; no inventar reglas en arquitectura.

---

# 66. ADR candidates

Las siguientes decisiones probablemente requieren ADR cuando se pase de especificación a diseño técnico:

1. lifecycle de `Subscription` y entitlement;
2. representación conceptual/física del promotional entitlement;
3. adapter de Mercado Pago;
4. normalización de `PaymentEvent`;
5. verificación e idempotencia de webhooks;
6. tratamiento de eventos fuera de orden;
7. estrategia de reconciliación;
8. cálculo de billing periods y aniversarios;
9. cálculo de grace period;
10. versionado/aplicación de pricing;
11. semántica de cancelación/renovación después de `DO-078`;
12. separación Subscription vs AI Credits;
13. frontera de autorización comercial y RLS;
14. estrategia de acciones excepcionales globales, si `PAY-OPEN-007` se aprueba.

Este documento no genera ADRs.

---

# 67. Nuevas decisiones abiertas `PAY-OPEN-*`

Todas las decisiones de esta sección permanecen sin aprobar.

## `PAY-OPEN-001` — Ancla promocional, aniversario y timezone comercial

**Motivo:** la baseline exige un año a $0, pero no fija inequívocamente el evento inicial, el cálculo calendario ni timezone.

**Alternativas:**

1. alta/activación + aniversario calendario en timezone Argentina;
2. primer admin verificado + aniversario;
3. primera operación + aniversario;
4. duración fija en horas/días desde un timestamp UTC.

**Evaluación:** alta/activación es objetiva y auditable; primer uso puede postergar la promoción arbitrariamente; días fijos generan problemas de leap year; timezone tenant-specific agrega complejidad innecesaria para un mercado único.

**Recomendación:** usar el instante autoritativo de creación/activación del tenant como ancla; calcular un aniversario calendario en una timezone comercial única de Argentina; definir explícitamente 29 de febrero y fin de mes; persistir el instante resultante sin ambigüedad.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

## `PAY-OPEN-002` — Versionado y política de cambio de precio

**Motivo:** se requieren precio mensual/anual e histórico, pero no existe política de cambios.

**Alternativas:** cambio sólo para nuevos tenants; cambio en próxima renovación de todos; grandfathering indefinido; fecha de vigencia configurable con aviso.

**Evaluación:** aplicar inmediatamente a períodos ya iniciados rompe previsibilidad e histórico; grandfathering indefinido añade complejidad comercial; una vigencia futura versionada conserva auditabilidad.

**Recomendación:** precio global versionado por modalidad con vigencia futura; fijar precio aplicado al crear la obligación; nunca reescribir históricos; definir aviso previo antes de producción sin inventar duración aquí.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

## `PAY-OPEN-003` — Inicio, deadline y reinicio de la gracia de 20 días

**Motivo:** la duración está aprobada, pero no el instante exacto ni el efecto de retries/pending.

**Alternativas:** iniciar en due date; iniciar en primer failure; reiniciar por cada retry; pausar mientras pending; reiniciar con nueva factura.

**Evaluación:** reinicios permiten gracia indefinida; primer failure puede ocurrir antes/después del due date según proveedor; due date es la referencia comercial más estable; pending no debe equivaler a pago.

**Recomendación:** una única gracia por obligación impaga, iniciada en el vencimiento autoritativo; 20 días exactos conforme a timezone/regla temporal aprobada; retries, duplicados y pending no reinician; regularización confirmada antes del deadline vuelve a active.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

## `PAY-OPEN-004` — Deuda de varios períodos y requisitos de reactivación

**Motivo:** la baseline exige reactivar con pago válido, pero no define qué debe pagarse si el tenant permaneció suspendido durante más de un ciclo.

**Alternativas:** pagar toda deuda acumulada; pagar sólo obligación que originó suspensión; crear nuevo paid period desde la reactivación; política dependiente del proveedor/contrato.

**Evaluación:** acumular indefinidamente períodos sin entitlement puede cobrar servicio no utilizado; ignorar toda deuda puede ser comercialmente incorrecto; la política debe ser explícita y consistente con cancelación/renovación.

**Recomendación:** para el MVP, favorecer una reactivación que establezca un nuevo período válido desde una confirmación comercial inequívoca, sin generar automáticamente meses/años retroactivos de entitlement; cualquier deuda exigible previa debe definirse contractualmente antes de implementar. No se aprueba condonación ni cobro retroactivo por defecto.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

## `PAY-OPEN-005` — Compra de créditos IA con tenant suspendido

**Motivo:** `08` deja abierta esta capacidad.

**Alternativas:** permitir libremente; permitir sólo en superficie comercial restringida; bloquear hasta reactivar.

**Evaluación:** una compra no reactiva la suscripción y los créditos no son utilizables mientras el tenant siga inactivo; venderlos puede generar confusión.

**Recomendación:** bloquear nuevas compras de créditos mientras el tenant esté inactivo; permitir primero regularizar suscripción y luego comprar créditos.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

## `PAY-OPEN-006` — Chargebacks y disputes

**Motivo:** pueden revertir un pago previamente confirmado y afectar entitlement, pero no existe regla aprobada.

**Alternativas:** suspensión inmediata; gracia; mantener acceso durante disputa; revisión manual; política diferenciada según resultado final.

**Evaluación:** suspensión inmediata por un evento no reconciliado puede ser incorrecta; ignorar un chargeback confirmado también puede dejar acceso sin contraprestación.

**Recomendación:** exigir reconciliación autoritativa y política comercial explícita; no destruir datos; evitar suspensión automática por una notificación aislada; definir efecto sobre entitlement antes de Fase 8.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

## `PAY-OPEN-007` — Capacidades excepcionales de `SUPER_ADMIN` para regularización comercial

**Motivo:** soporte y conciliación pueden requerir intervención, pero la baseline no otorga modificación arbitraria.

**Alternativas:** sólo lectura/diagnóstico; acciones de reconciliación automatizadas sin override manual; capacidad global limitada con reason/audit; overrides amplios.

**Evaluación:** overrides amplios violan mínimo privilegio; sólo lectura puede resultar insuficiente ante incidentes; acciones limitadas deben estar fuertemente auditadas y no permitir fabricar pagos.

**Recomendación:** no conceder override comercial genérico. Si Fase 8 demuestra una necesidad real, aprobar acciones excepcionales específicas, tenant-scoped, con motivo obligatorio, auditoría, separación de funciones y sin editar pagos/eventos históricos.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8 si se necesita alguna acción excepcional; de lo contrario mantener ausencia de permiso.

## `PAY-OPEN-008` — Representación conceptual del año promocional respecto de `Subscription`

**Motivo:** el modelo de dominio describe un ciclo de suscripción desde el tenant activado, pero no obliga a que exista una `Subscription` paga o externa durante el año $0.

**Alternativas:**

1. una única `Subscription` lógica interna desde el alta con fase promocional;
2. entitlement promocional separado y creación de `Subscription` al contratar pago;
3. relación comercial interna única, pero recurso externo sólo al iniciar pago.

**Evaluación:** una relación interna única simplifica histórico y entitlement; crear una suscripción externa a $0 podría acoplar innecesariamente el período promocional al proveedor; separar totalmente puede fragmentar el historial.

**Recomendación:** mantener una relación comercial interna única por tenant que cubra promo y pago, sin exigir recurso externo de Mercado Pago durante el año $0; la materialización física se decide después.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

---

# 68. Tratamiento formal de `DO-076`

**Pregunta:** ¿la primera obligación de pago posterior al año $0 recibe la gracia general de 20 días?

**Alternativas evaluadas:**

1. obligación al finalizar promo + 20 días;
2. 20 días previos a obligación;
3. contratación obligatoria previa;
4. suspensión inmediata.

**Tradeoffs:** continuidad operativa, claridad del vencimiento, previsibilidad, fricción de método de pago, consistencia con la gracia general y notificaciones.

**Recomendación:** obligación paga al finalizar el año promocional y, si no hay confirmación válida, aplicación de los mismos 20 días de gracia antes de suspensión; no exigir método de pago antes del final promocional sin una decisión expresa.

**Estado:** `PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

No se marca RESUELTA.

---

# 69. Tratamiento formal de `DO-078`

## Renovación

**Propuesta:** automática para mensual y anual.

## Cancelación

**Propuesta:** cancelar renovación, efectiva al final del período ya pagado.

## Cambio mensual/anual

**Propuesta:** efectivo en la siguiente renovación; no cambio intra-período por defecto.

## Prorrateo

**Propuesta:** no prorrateo automático en MVP.

## Refund

**Propuesta:** no refund automático por cancelación ordinaria; cualquier excepción requiere política expresa y validación legal/proveedor.

## Reactivación

**Propuesta:** si existe período todavía activo con cancelación programada, permitir retirar la cancelación cuando corresponda; si el período terminó, nueva activación paga; si existe suspensión por deuda, aplicar `PAY-OPEN-004`.

**Estado:** `PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

La aprobación de este documento no aprueba ninguna de estas políticas.

---

# 70. Tratamiento formal de `DO-T02`

**Propuesta conceptual:**

**evento externo → verificación → deduplicación → resolución de tenant/entidad → confirmación autoritativa cuando corresponda → aplicación idempotente → actualización de estado local → auditoría → reconciliación.**

La propuesta exige:

- autenticidad antes de efectos;
- duplicados sin doble efecto;
- out-of-order sin degradación por orden de llegada;
- retries distinguibles de nuevas intenciones;
- callback frontend no autoritativo;
- evento perdido recuperable mediante reconciliación;
- cross-tenant payment rechazado;
- pago confirmado aplicado exactamente una vez;
- divergencias observables.

**Estado:** `PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8.

No se marca RESUELTA/APROBADA.

---

# 71. Decisiones previas preservadas

Este documento no reevalúa decisiones ajenas a Subscription & Payments y conserva sus estados vigentes.

## 71.1 `DM-OPEN-001..008`

Permanecen sin resolver conforme a sus documentos aprobados:

- `DM-OPEN-001` — obligatoriedad de `EquipmentType`: **ABIERTA**;
- `DM-OPEN-002` — cardinalidad de formularios aplicables: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**;
- `DM-OPEN-003` — equipo sin formulario aplicable: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**;
- `DM-OPEN-004` — borradores simultáneos de formulario: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**;
- `DM-OPEN-005` — unicidad de informe por cliente/período: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**;
- `DM-OPEN-006` — plantilla usada en regeneración: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**;
- `DM-OPEN-007` — créditos IA insuficientes: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**;
- `DM-OPEN-008` — criterio temporal de inclusión en informes: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

## 71.2 `FORM-OPEN-001..008`

Permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**:

- tratamiento de respuesta al ocultarse un campo;
- modelo operativo de tabla/matriz;
- cardinalidad de campo `image`;
- inicio offline con versión publicada desactualizada;
- tipos permitidos como fuente de igualdad;
- nesting/semántica de contenedores compuestos;
- `required` para checkbox;
- multiplicidad de condiciones por destino.

## 71.3 `EVID-OPEN-001..006`

Permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**:

- cardinalidad required;
- multiplicidad por categoría;
- eliminación durante captura no finalizada;
- cadena/vigencia de replacements;
- categoría en visual replacement;
- continuidad entre `MaintenanceRevision`.

## 71.4 `RPT-OPEN-001..012`

Permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN** conforme a `07`:

1. timezone de reporting period;
2. momento de selección de revisión;
3. cambios/staleness durante draft;
4. inclusión/exclusión manual;
5. re-emisión técnica desde mismo snapshot;
6. atomicidad funcional de finalización;
7. huecos en numeración;
8. selección de Evidence;
9. Reporting online y no sincronizados;
10. mantenimiento con conflicto;
11. regeneración sin cambios semánticos;
12. descarte/cancelación de draft.

## 71.5 `AI-OPEN-001..008`

Permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**:

- `AI-OPEN-001` — política de costo y visibilidad previa;
- `AI-OPEN-002` — respuesta parcial/inválida;
- `AI-OPEN-003` — cancelación de operación en curso;
- `AI-OPEN-004` — operación en curso al deshabilitar IA;
- `AI-OPEN-005` — retención de input/output/metadata;
- `AI-OPEN-006` — paquetes, expiración y origen comercial de créditos;
- `AI-OPEN-007` — grants/ajustes administrativos excepcionales;
- `AI-OPEN-008` — detalle del historial visible a `COMPANY_ADMIN`.

`AI-OPEN-006` conserva expresamente su carácter abierto; este documento no aprueba catálogo, expiración, promociones, grants, tamaños, precios ni bonus.

## 71.6 `DO-*`

- `DO-073` — alcance de notificaciones push: **DIFERIDA**; resolver antes de Fase 9.
- `DO-074` — métricas del dashboard: **DIFERIDA**; resolver antes de Fase 10.
- `DO-075` — autorización offline máxima de 7 días: **RESUELTA/APROBADA**; no se reabre.
- `DO-076` — gracia al finalizar el primer año $0: **PROPUESTA PENDIENTE DE APROBACIÓN** tras el análisis de este documento; resolver antes de Fase 8.
- `DO-077` — subconjunto DOCX portable: **PENDIENTE DE APROBACIÓN**; resolver antes de Fase 6.
- `DO-078` — renovación/cancelación/prorrateo: **PROPUESTA PENDIENTE DE APROBACIÓN** tras el análisis de este documento; resolver antes de Fase 8.

## 71.7 `DO-T01..07`

- `DO-T01` — protocolo del ledger IA: **PROPUESTA PENDIENTE DE APROBACIÓN**; no se modifica.
- `DO-T02` — state machine de Mercado Pago: **PROPUESTA PENDIENTE DE APROBACIÓN** tras este análisis; resolver antes de Fase 8; no está aprobada.
- `DO-T03` — invalidación efectiva de sesiones: **PARCIALMENTE ABIERTO**; no se modifica.
- `DO-T04` — protección local: **PROPUESTA PENDIENTE DE APROBACIÓN**; no se modifica.
- `DO-T05` — escala/rendimiento objetivo: **DIFERIDO**.
- `DO-T06` — backup, RPO/RTO y restauración: **DIFERIDO**.
- `DO-T07` — privacidad/legal aplicable: **DIFERIDO**.

## 71.8 `OFF-OPEN-*`

- `OFF-OPEN-001` — destino de trabajo pendiente tras revocación: **ABIERTO — pendiente de aprobación**.
- `OFF-OPEN-002` — conservación/purga de datos sincronizados de cliente revocado: **ABIERTO — pendiente de aprobación**.

No se modifican.

---

# 72. Gate del documento

## 72.1 Contradicciones bloqueantes

**No se detectan contradicciones bloqueantes conocidas** entre `01..08` y esta especificación conceptual.

Las ambigüedades detectadas corresponden a decisiones explícitamente abiertas, principalmente transición del año $0, renovación/cancelación, estado de eventos de pago, temporalidad, pricing y regularización.

## 72.2 `DO-076`

**Estado:** `PROPUESTA PENDIENTE DE APROBACIÓN`.

**Recomendación:** primera obligación al finalizar el año promocional + 20 días de gracia si no se regulariza.

**Resolver antes de:** Fase 8.

## 72.3 `DO-078`

**Estado:** `PROPUESTA PENDIENTE DE APROBACIÓN`.

**Recomendación:** auto-renovación; cancelación al fin de período; cambios de modalidad en próxima renovación; sin prorrateo/refund automático por defecto.

**Resolver antes de:** Fase 8.

## 72.4 `DO-T02`

**Estado:** `PROPUESTA PENDIENTE DE APROBACIÓN`.

**Recomendación:** ingesta verificada → deduplicación → resolución autoritativa → aplicación idempotente → estado local → auditoría/reconciliación, con protección explícita contra out-of-order y eventos perdidos.

**Resolver antes de:** Fase 8.

## 72.5 Nuevas decisiones `PAY-OPEN-*`

Existen exactamente ocho decisiones abiertas nuevas:

1. `PAY-OPEN-001` — ancla promocional, aniversario y timezone comercial;
2. `PAY-OPEN-002` — versionado y política de cambio de precio;
3. `PAY-OPEN-003` — inicio, deadline y reinicio de la gracia de 20 días;
4. `PAY-OPEN-004` — deuda de varios períodos y requisitos de reactivación;
5. `PAY-OPEN-005` — compra de créditos IA con tenant suspendido;
6. `PAY-OPEN-006` — chargebacks y disputes;
7. `PAY-OPEN-007` — capacidades excepcionales de `SUPER_ADMIN` para regularización comercial;
8. `PAY-OPEN-008` — representación conceptual del año promocional respecto de `Subscription`.

Todas tienen estado:

`ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

En conjunto: `PAY-OPEN-001..008 = ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN`.

No existen decisiones `PAY-OPEN-009` ni `PAY-OPEN-010`.

No existe un `PAY-OPEN` independiente que duplique la transición del año $0 gobernada por `DO-076`, ni uno que duplique renovación, cancelación, cambio de modalidad, prorrateo o refunds ordinarios gobernados por `DO-078`.

Ninguna bloquea Fase 1.

Deben resolverse antes de Fase 8 según sus deadlines.

## 72.6 Riesgos

Se registran `PAY-RSK-001..030`, cubriendo temporalidad, idempotencia, eventos, conciliación, cross-tenant, pricing, suspensión, créditos, métodos de pago, disputes, fiscalidad y acciones globales.

## 72.7 ADR candidates

Se identifican candidatos para lifecycle de Subscription, entitlement, PaymentEvent, adapter, webhooks, out-of-order, reconciliación, temporalidad, pricing, cancelación/renovación, créditos IA y autorización comercial.

No se genera ningún ADR.

## 72.8 Decisiones previas

Se preservan:

- `DM-OPEN-001..008`;
- `FORM-OPEN-001..008`;
- `EVID-OPEN-001..006`;
- `RPT-OPEN-001..012`;
- `AI-OPEN-001..008`;
- `DO-073`;
- `DO-074`;
- `DO-075`;
- `DO-076`;
- `DO-077`;
- `DO-078`;
- `DO-T01..07`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`.

`FORM-OPEN-001..008` permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.

`EVID-OPEN-001..006` permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.

`RPT-OPEN-001..012` permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.

`AI-OPEN-001..008` permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.

Los `DO-*` y `OFF-OPEN-*` conservan exactamente los estados detallados en la sección 71.

`DO-075` permanece **RESUELTA/APROBADA**.

`DO-T07` permanece **DIFERIDO**.

`AI-OPEN-006` permanece **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

## 72.9 Estado documental y alcance de la aprobación

**Estado de `09-subscription-payments-spec.md`: APROBADO.**

La aprobación de `09-subscription-payments-spec.md` confirma esta especificación conceptual y funcional como baseline aprobada del subsistema Subscription & Payments del MVP.

Esta aprobación **NO**:

- aprueba `DO-076`;
- aprueba `DO-078`;
- aprueba `DO-T02`;
- resuelve `PAY-OPEN-001..008`;
- resuelve decisiones previas;
- autoriza implementación;
- autoriza una integración concreta de Mercado Pago;
- selecciona SDK;
- selecciona el recurso `preapproval`;
- autoriza checkout;
- autoriza webhooks ejecutables;
- autoriza SQL;
- autoriza migrations;
- autoriza tablas;
- autoriza enums físicos;
- autoriza RLS ejecutable;
- autoriza transactions, locks o RPC;
- autoriza jobs, queues o workers;
- fija precios;
- fija descuento anual;
- fija política fiscal;
- autoriza integración AFIP/ARCA;
- autoriza refunds;
- autoriza prorrateo;
- autoriza overrides de `SUPER_ADMIN`;
- autoriza React;
- autoriza APIs;
- autoriza Server Actions;
- autoriza Codex;
- genera ADRs;
- autoriza avanzar automáticamente al documento 10;
- cierra Fase 0.

`DO-076` permanece `PROPUESTA PENDIENTE DE APROBACIÓN`.

`DO-078` permanece `PROPUESTA PENDIENTE DE APROBACIÓN`.

`DO-T02` permanece `PROPUESTA PENDIENTE DE APROBACIÓN`.

## 72.10 Estado de Fase 0

**Estado de Fase 0: EN CURSO.**

La aprobación de `09` no cierra Fase 0 y no autoriza avanzar automáticamente al documento 10.
