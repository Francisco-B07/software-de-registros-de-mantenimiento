# 01 — Definición normativa del producto

> **Revisión de cierre documental:** 2026-08-13 — aprobación explícita de la baseline normativa de producto y resolución de DO-075, sin cambios en requisitos aprobados.

**Ruta de entrega:** `docs/product/01-product-definition.md`  
**Documento normativo:** `docs/product/01-product-definition.md`  
**Estado del documento:** **APROBADO — baseline normativa de producto**  
**Estado de Fase 0:** **EN CURSO — pendientes documentos derivados y ADRs**  
**Carácter:** especificación maestra y normativa del producto  
**Fuente principal:** `00-master-product-brief.md` y decisiones de producto aprobadas durante Fase 0  

---

## 1. Propósito y autoridad del documento

Este documento define normativamente el producto que se construirá durante el MVP del SaaS de registros de mantenimiento.

Ante una contradicción entre documentación anterior y una decisión posterior aprobada durante Fase 0, prevalece la decisión más reciente incorporada en este documento y debe actualizarse la documentación afectada.

Este documento NO autoriza todavía:

- inicializar Next.js;
- diseñar tablas SQL;
- crear migraciones;
- implementar RLS;
- escribir código de producto;
- avanzar a Fase 1.

La definición normativa contenida en este documento está aprobada. La Fase 0 sólo podrá cerrarse cuando los documentos maestros derivados y los ADRs requeridos hayan sido realmente creados, revisados y aprobados, y las decisiones que deban resolverse antes de cada fase hayan sido tratadas conforme a su fecha límite.

### 1.1 Palabras normativas

- **DEBE / DEBEN:** requisito obligatorio.
- **NO DEBE / NO DEBEN:** prohibición obligatoria.
- **PUEDE:** capacidad permitida u opcional.
- **FUERA DEL MVP:** no debe implementarse durante el MVP sin una decisión de producto que modifique este documento.

---

## 2. Visión del producto

Construir un SaaS B2B multiempresa para compañías que prestan servicios de mantenimiento técnico, inicialmente orientado a una empresa piloto de climatización industrial, pero con un núcleo suficientemente genérico para incorporar posteriormente otros rubros de mantenimiento sin rediseñar el producto base.

El sistema debe permitir registrar y ejecutar mantenimientos técnicos, capturar evidencia, trabajar offline durante períodos prolongados, producir informes profesionales PDF/DOCX, y asistir la redacción de informes mediante IA controlada por créditos.

Cada empresa de mantenimiento constituye un tenant completamente aislado.

Los clientes industriales administrados por una empresa de mantenimiento no son usuarios del SaaS y no contratan servicios a través de la plataforma.

---

## 3. Objetivos

**OBJ-001.** Centralizar información técnica y registros de mantenimiento de cada empresa de mantenimiento.

**OBJ-002.** Proteger estrictamente el aislamiento entre tenants.

**OBJ-003.** Permitir operación real de campo durante días sin conectividad.

**OBJ-004.** Disponer de un motor de formularios suficientemente flexible para distintos tipos de mantenimiento y rubros.

**OBJ-005.** Conservar historial técnico inmutable y trazable de registros finalizados, revisiones y evidencias.

**OBJ-006.** Generar informes mensuales profesionales en PDF y DOCX desde un modelo común de documento.

**OBJ-007.** Usar IA únicamente como asistencia editorial controlada para informes, sin alterar hechos técnicos.

**OBJ-008.** Gestionar créditos IA mediante un ledger inmutable y conciliable.

**OBJ-009.** Mantener una arquitectura simple y modular dentro de un único proyecto Next.js.

**OBJ-010.** Permitir crecimiento posterior hacia otros rubros sin introducir especializaciones rígidas de climatización en el núcleo.

---

## 4. Alcance general del producto MVP

El MVP comprende:

1. administración global de empresas de mantenimiento;
2. autenticación y ciclo de vida de usuarios;
3. roles fijos `SUPER_ADMIN`, `COMPANY_ADMIN` y `TECHNICIAN`;
4. multitenancy con RLS obligatorio;
5. clientes industriales;
6. jerarquías arbitrarias de ubicaciones;
7. tipos de equipo privados por tenant;
8. equipos;
9. motor de formularios versionado;
10. mantenimientos preventivos, correctivos, predictivos e inspecciones;
11. revisiones de mantenimientos finalizados;
12. evidencias fotográficas;
13. operación PWA offline-first;
14. informes mensuales por cliente en PDF y DOCX;
15. IA para redacción de informes;
16. créditos IA;
17. suscripción mensual/anual mediante Mercado Pago;
18. primer año promocional a costo $0;
19. notificaciones push cuando exista conectividad;
20. dashboard.

No existen sucursales de empresas de mantenimiento en el MVP.

No existen órdenes de trabajo en el MVP.

---

## 5. Actores

### 5.1 `SUPER_ADMIN`

Actor global de plataforma.

- No pertenece a ninguna empresa de mantenimiento.
- Crea empresas de mantenimiento.
- Inicia el alta del primer `COMPANY_ADMIN`.
- Gestiona aspectos globales de la plataforma.
- No accede normalmente a datos operativos de tenants.
- Puede recibir acceso excepcional, explícito, limitado y revocable a una empresa de mantenimiento cuando un `COMPANY_ADMIN` de dicha empresa lo autoriza.

### 5.2 `COMPANY_ADMIN`

Usuario perteneciente exactamente a una empresa de mantenimiento.

- Administra usuarios de su empresa.
- Administra clientes, ubicaciones, equipos y tipos de equipos.
- Administra formularios.
- Administra y finaliza informes.
- Puede usar IA para informes.
- Administra suscripción y créditos IA.
- Puede corregir mantenimientos finalizados dentro de su alcance.
- Concede y revoca acceso excepcional a `SUPER_ADMIN`.

### 5.3 `TECHNICIAN`

Usuario perteneciente exactamente a una empresa de mantenimiento.

- Accede sólo a los clientes expresamente autorizados por un `COMPANY_ADMIN`.
- Dentro de cada cliente autorizado accede a toda su jerarquía de ubicaciones y todos sus equipos.
- Ejecuta mantenimientos sin necesidad de asignación previa.
- Puede corregir mantenimientos finalizados dentro de su alcance.
- No administra plantillas de formularios.
- No administra ni genera informes.
- No utiliza IA en el MVP.

### 5.4 Cliente industrial

No es usuario del SaaS en el MVP.

---

## 6. Modelo SaaS y multitenancy

**MT-001.** Cada empresa de mantenimiento es un tenant independiente.

**MT-002.** `SUPER_ADMIN` es una identidad global y no pertenece a ningún tenant.

**MT-003.** Cada `COMPANY_ADMIN` y `TECHNICIAN` pertenece a una única empresa de mantenimiento.

**MT-004.** El MVP NO DEBE modelar sucursales internas de una empresa de mantenimiento.

**MT-005.** Todo dato perteneciente a un tenant DEBE estar asociado conceptualmente a `maintenance_company_id`.

**MT-006.** Supabase PostgreSQL DEBE ser la fuente de verdad remota.

**MT-007.** RLS DEBE ser la barrera primaria de aislamiento tenant en la capa de datos.

**MT-008.** El frontend, middleware o filtros de UI NO DEBEN ser considerados controles suficientes de aislamiento.

**MT-009.** Un usuario de tenant NO DEBE poder acceder a datos de otra empresa de mantenimiento.

**MT-010.** El acceso efectivo de un usuario de tenant se determina por empresa, rol y clientes autorizados.

---

## 7. Requisitos funcionales

### 7.1 Alta de empresas y usuarios

**RF-001.** `SUPER_ADMIN` DEBE poder crear una empresa de mantenimiento.

**RF-002.** Una empresa recién creada DEBE quedar activa inmediatamente.

**RF-003.** Durante el alta de empresa DEBE indicarse el correo del primer `COMPANY_ADMIN`.

**RF-004.** El sistema DEBE enviar un código de verificación al correo indicado.

**RF-005.** Cada código DEBE tener una vigencia de 8 horas desde su emisión.

**RF-006.** Cada código DEBE admitir como máximo 3 intentos de verificación.

**RF-007.** El actor autorizado para el alta DEBE poder reenviar el código las veces que sea necesario.

**RF-008.** Cada reenvío DEBE emitir un código nuevo.

**RF-009.** Al emitir un nuevo código, el código anterior DEBE quedar inmediatamente invalidado.

**RF-010.** Cada código nuevo DEBE disponer de sus propios 3 intentos.

**RF-011.** Un código vencido NO DEBE poder recuperarse ni reutilizarse.

**RF-012.** El primer `COMPANY_ADMIN` DEBE ingresar utilizando correo y código válido y completar su perfil.

**RF-013.** Un `COMPANY_ADMIN` autorizado DEBE poder dar de alta nuevos `COMPANY_ADMIN` y `TECHNICIAN` mediante el mismo patrón de correo + código.

**RF-014.** Al crear un usuario, el `COMPANY_ADMIN` DEBE asignarle uno de los roles fijos permitidos.

**RF-015.** El `COMPANY_ADMIN` DEBE poder asignar a un usuario uno o más clientes pertenecientes a su propia empresa.

**RF-016.** Un `COMPANY_ADMIN` NO DEBE poder conceder acceso a clientes de otro tenant.

**RF-017.** El `COMPANY_ADMIN` DEBE poder modificar posteriormente el rol y los clientes autorizados de un usuario.

**RF-018.** El `COMPANY_ADMIN` DEBE poder deshabilitar un usuario sin eliminarlo.

**RF-019.** Al deshabilitar o revocar un usuario, sus sesiones activas DEBEN cerrarse automáticamente.

**RF-020.** Un usuario deshabilitado DEBE conservar su identidad e historial.

**RF-021.** Un usuario deshabilitado DEBE poder ser reintegrado posteriormente.

### 7.2 Permisos operativos

**RF-022.** Un `TECHNICIAN` DEBE acceder únicamente a clientes que tenga autorizados.

**RF-023.** El acceso a un cliente autorizado DEBE incluir toda su jerarquía de ubicaciones.

**RF-024.** El acceso a un cliente autorizado DEBE incluir todos los equipos de ese cliente.

**RF-025.** El acceso del técnico NO DEBE depender de una asignación previa a un mantenimiento.

**RF-026.** Las asignaciones de técnicos a mantenimientos quedan FUERA DEL MVP.

### 7.3 Acceso excepcional de soporte

**RF-027.** `SUPER_ADMIN` NO DEBE acceder por defecto a datos operativos de tenants.

**RF-028.** Un `COMPANY_ADMIN` DEBE poder conceder acceso excepcional de soporte a `SUPER_ADMIN`.

**RF-029.** Para datos operativos, el permiso DEBE poder limitarse a clientes específicos.

**RF-030.** Para cada cliente autorizado, el `COMPANY_ADMIN` DEBE poder seleccionar las secciones accesibles.

**RF-031.** Las secciones operativas seleccionables DEBEN incluir: información del cliente, ubicaciones, equipos, mantenimientos, formularios/respuestas, evidencias e informes.

**RF-032.** A nivel empresa, el `COMPANY_ADMIN` DEBE poder conceder por separado acceso de soporte a usuarios/permisos, suscripción/pagos y créditos IA.

**RF-033.** El `COMPANY_ADMIN` DEBE poder revocar el acceso excepcional cuando lo desee.

**RF-034.** El acceso excepcional NO DEBE convertirse en un bypass general de RLS o aislamiento tenant.

### 7.4 Clientes y ubicaciones

**RF-035.** Una empresa DEBE poder administrar múltiples clientes industriales.

**RF-036.** Un cliente DEBE poder contener una jerarquía arbitraria de ubicaciones.

**RF-037.** Las ubicaciones DEBEN admitir relaciones padre/hijo mediante una estructura conceptual equivalente a `parent_location_id`.

**RF-038.** El producto NO DEBE modelar sede/planta/sector/subsector/sala mediante tablas rígidas específicas por nivel.

### 7.5 Equipos

**RF-039.** Una empresa DEBE poder definir sus propios tipos de equipos.

**RF-040.** Los tipos de equipo DEBEN ser privados del tenant.

**RF-041.** Un equipo DEBE poder asociarse a cualquier nodo de ubicación de su cliente.

**RF-042.** Un formulario PUEDE asociarse a un tipo de equipo.

**RF-043.** Un equipo individual PUEDE tener una plantilla específica.

**RF-044.** Si un equipo posee una plantilla específica, ésta DEBE tener prioridad absoluta sobre la plantilla asociada a su tipo de equipo.

**RF-045.** Identificación mediante QR queda FUERA DEL MVP.

### 7.6 Motor de formularios

**RF-046.** `COMPANY_ADMIN` DEBE poder crear formularios.

**RF-047.** `COMPANY_ADMIN` DEBE poder clonar formularios.

**RF-048.** `COMPANY_ADMIN` DEBE poder editar borradores.

**RF-049.** `COMPANY_ADMIN` DEBE poder previsualizar formularios.

**RF-050.** `COMPANY_ADMIN` DEBE poder archivar formularios.

**RF-051.** Importación y exportación de formularios quedan FUERA DEL MVP.

**RF-052.** Un formulario lógico DEBE tener estado activo o archivado.

**RF-053.** Una versión de formulario DEBE tener estado borrador o publicada.

**RF-054.** Una versión borrador DEBE poder editarse.

**RF-055.** Una versión publicada DEBE ser inmutable.

**RF-056.** Editar un formulario ya publicado DEBE crear un nuevo borrador, sin modificar la versión publicada.

**RF-057.** Publicar el nuevo borrador DEBE crear la nueva versión vigente.

**RF-058.** Las versiones publicadas anteriores DEBEN conservarse históricamente.

**RF-059.** Archivar un formulario DEBE impedir su uso en nuevos mantenimientos sin afectar registros históricos.

**RF-060.** Cada mantenimiento DEBE conservar para siempre la versión exacta del formulario utilizada.

**RF-061.** El constructor DEBE priorizar una UX simple para el administrador y evitar complejidad innecesaria.

**RF-062.** El motor DEBE soportar texto corto y largo.

**RF-063.** El motor DEBE soportar entero y decimal.

**RF-064.** El motor DEBE soportar select.

**RF-065.** El motor DEBE soportar selección múltiple.

**RF-066.** El motor DEBE soportar checkbox.

**RF-067.** El motor DEBE soportar campos de imágenes como ítems autónomos del formulario cuya respuesta es una o más imágenes.

**RF-068.** El motor DEBE soportar campos de archivos.

**RF-069.** El motor DEBE soportar tablas o matrices.

**RF-070.** El motor DEBE soportar secciones.

**RF-071.** El motor DEBE soportar grupos repetibles.

**RF-072.** Campos numéricos DEBEN poder definir unidad, mínimo y máximo.

**RF-073.** El motor DEBE soportar la regla simple “SI campo = valor → mostrar campo”.

**RF-074.** El motor DEBE soportar la regla simple “SI campo = valor → hacer obligatorio campo”.

**RF-075.** El MVP NO DEBE implementar expresiones arbitrarias ni condiciones complejas AND/OR.

**RF-184.** Los campos pertenecientes a distintas versiones de un formulario DEBEN considerarse independientes; el MVP NO DEBE mantener una identidad lógica estable de campo entre versiones.

### 7.7 Mantenimiento

**RF-076.** El MVP NO DEBE incluir órdenes de trabajo.

**RF-077.** Cada mantenimiento DEBE existir y gestionarse de forma autónoma.

**RF-078.** El sistema DEBE soportar mantenimiento preventivo.

**RF-079.** El sistema DEBE soportar mantenimiento correctivo.

**RF-080.** El sistema DEBE soportar mantenimiento predictivo.

**RF-081.** El sistema DEBE soportar inspecciones.

**RF-082.** Los mantenimientos recurrentes quedan FUERA DEL MVP.

**RF-083.** Un técnico autorizado DEBE poder realizar un mantenimiento sin asignación previa.

**RF-084.** Un mantenimiento finalizado DEBE conservar historial inmutable.

**RF-085.** Una corrección posterior DEBE generar una nueva revisión y NO DEBE sobrescribir la anterior.

**RF-086.** `COMPANY_ADMIN` y `TECHNICIAN` DEBEN poder corregir mantenimientos finalizados dentro de su alcance autorizado.

**RF-087.** Las correcciones NO DEBEN requerir sistema de aprobación.

**RF-088.** Una corrección PUEDE modificar todos los campos del mantenimiento, preservando las revisiones anteriores.

### 7.8 Evidencias

**RF-089.** Todo campo de formulario DEBE poder habilitar evidencias fotográficas.

**RF-090.** La configuración DEBE admitir: sin fotos, antes, después, antes y después.

**RF-091.** Las evidencias DEBEN poder configurarse como opcionales u obligatorias.

**RF-092.** El usuario DEBE poder capturar fotografías desde cámara o seleccionar desde galería.

**RF-093.** Las imágenes PUEDEN comprimirse antes de sincronizar.

**RF-094.** Una evidencia fotográfica DEBE estar vinculada a una respuesta concreta y no tratarse como un adjunto genérico del formulario. A diferencia de un campo de tipo imagen, la evidencia es una capacidad asociable a cualquier campo del formulario.

**RF-095.** Una evidencia de un mantenimiento finalizado NO DEBE eliminarse.

**RF-096.** En una revisión correctiva PUEDE agregarse una nueva fotografía que reemplace visualmente a una anterior.

**RF-097.** Una fotografía reemplazada visualmente DEBE conservarse íntegramente en el historial.

**RF-185.** El MVP NO DEBE imponer límites funcionales o comerciales propios sobre cantidad, tamaño o formatos de fotografías y archivos. Las restricciones físicas o técnicas inevitables de dispositivo, navegador o proveedores de infraestructura NO constituyen cuotas funcionales del producto y DEBEN documentarse técnicamente cuando se definan.

### 7.9 Offline-first y sincronización

**RF-098.** La aplicación DEBE funcionar como PWA orientada principalmente a Android.

**RF-099.** La aplicación DEBE soportar operación durante días sin conectividad.

**RF-100.** Los assets necesarios DEBEN poder servirse offline mediante Service Worker.

**RF-101.** La información operativa local DEBE almacenarse mediante Dexie/IndexedDB.

**RF-102.** Los formularios publicados requeridos por el alcance autorizado del técnico DEBEN estar disponibles offline.

**RF-103.** Para cada cliente autorizado, el técnico DEBE disponer offline de la jerarquía completa de ubicaciones, todos sus equipos y los formularios aplicables necesarios para operar.

**RF-104.** Las operaciones offline DEBEN persistirse primero localmente y pasar a una outbox.

**RF-105.** Cada operación de sincronización DEBE ser idempotente.

**RF-106.** Las fotografías DEBEN conservarse localmente hasta confirmar almacenamiento remoto.

**RF-107.** La UI DEBE mostrar siempre estado de conectividad.

**RF-108.** La UI DEBE mostrar la cantidad de operaciones pendientes.

**RF-109.** El sistema NO DEBE utilizar Last Write Wins silencioso para registros críticos.

**RF-110.** Ante conflicto, el sistema DEBE conservar ambas versiones y evitar sobrescritura automática.

**RF-111.** El usuario DEBE poder visualizar las diferencias relevantes del conflicto.

**RF-112.** `TECHNICIAN` DEBE poder resolver conflictos de mantenimientos dentro de sus clientes autorizados.

**RF-113.** `COMPANY_ADMIN` DEBE poder resolver conflictos dentro de su alcance.

**RF-114.** La resolución de un conflicto de mantenimiento DEBE producir una nueva revisión.

**RF-115.** Si un usuario cierra sesión, los datos offline pendientes o necesarios DEBEN conservarse cuando sea técnicamente posible.

**RF-116.** Los datos offline DEBEN quedar aislados por identidad.

**RF-117.** Un segundo usuario del mismo dispositivo NO DEBE poder reutilizar ni leer la copia local del usuario anterior aunque compartan clientes autorizados.

**RF-118.** Una autorización comercial validada online PUEDE mantenerse offline durante un máximo de 7 días desde la última validación.

**RF-119.** Superados los 7 días, el dispositivo DEBE requerir conectividad y revalidación antes de iniciar nuevas operaciones.

**RF-120.** El vencimiento de la autorización comercial offline NO DEBE eliminar trabajo ya capturado localmente.

**RF-186.** Cuando el usuario presione `Guardar` para completar el formulario de mantenimiento y se satisfagan sus validaciones, el mantenimiento DEBE considerarse finalizado localmente aunque todavía existan datos, operaciones o fotografías pendientes de sincronización.

**RF-187.** El estado de finalización del mantenimiento y el estado de sincronización DEBEN ser conceptos independientes: un mantenimiento PUEDE estar finalizado y simultáneamente pendiente de sincronización.

**RF-188.** Las operaciones y fotografías pendientes de un mantenimiento finalizado localmente DEBEN sincronizarse automáticamente cuando se restablezca la conectividad y corresponda ejecutar la sincronización según las demás reglas de autorización.

### 7.10 Informes

**RF-121.** Los informes DEBEN ser una capacidad central del producto.

**RF-122.** El informe principal DEBE ser mensual y corresponder a un cliente de una empresa de mantenimiento.

**RF-123.** El informe mensual DEBE consolidar mantenimientos de los equipos del cliente durante el período.

**RF-124.** `COMPANY_ADMIN` DEBE poder configurar plantillas de informe propias.

**RF-125.** La plantilla DEBE admitir branding, portada, encabezado, pie, secciones, campos visibles, orden, fotografías y tablas.

**RF-126.** Los gráficos quedan FUERA DEL MVP.

**RF-127.** La plantilla DEBE poder ocultar valores vacíos.

**RF-128.** La plantilla DEBE poder presentar fotografías, incluyendo comparación antes/después cuando corresponda.

**RF-129.** Cada generación DEBE crear un snapshot inmutable de los datos utilizados.

**RF-130.** Los informes DEBEN soportar borrador y versiones.

**RF-131.** Los informes DEBEN tener numeración correlativa por empresa de mantenimiento.

**RF-132.** El número oficial DEBE asignarse al finalizar el informe, no al crear el borrador.

**RF-133.** Una regeneración DEBE conservar el mismo número oficial del informe.

**RF-134.** Cada regeneración DEBE crear una nueva versión correlativa del mismo informe, por ejemplo `INF-000123 v1`, `INF-000123 v2`, `INF-000123 v3`.

**RF-135.** Cada versión DEBE conservar su propio snapshot inmutable.

**RF-136.** Una corrección posterior de un mantenimiento incluido NO DEBE modificar versiones de informe ya finalizadas.

**RF-137.** Al regenerar un informe, la nueva versión DEBE utilizar las revisiones vigentes al momento de esa regeneración.

**RF-138.** El PDF DEBE ser el documento oficial generado por la plataforma.

**RF-139.** El sistema DEBE generar además DOCX completamente editable y compatible en lo posible con Microsoft Word, Google Docs y LibreOffice.

**RF-140.** PDF y DOCX DEBEN derivarse del mismo modelo intermedio de documento.

### 7.11 IA para informes

**RF-141.** En el MVP la IA DEBE utilizarse exclusivamente para asistencia de redacción de informes.

**RF-142.** Sólo `COMPANY_ADMIN` DEBE poder utilizar IA en el MVP.

**RF-143.** La IA PUEDE generar resumen ejecutivo, descripción del trabajo, síntesis mensual, observaciones narrativas y textos basados en datos e históricos permitidos.

**RF-144.** La IA PUEDE ayudar a describir mediciones fuera de rango.

**RF-145.** La IA NO DEBE modificar datos registrados, mediciones ni evidencias.

**RF-146.** Todo contenido generado DEBE poder ser revisado y editado por `COMPANY_ADMIN` antes de finalizar el informe.

**RF-147.** El informe DEBE poder generarse completamente sin IA.

**RF-148.** Las llamadas a OpenAI DEBEN realizarse exclusivamente desde el servidor.

**RF-149.** El MVP NO DEBE enviar fotografías a la IA.

**RF-150.** Los datos enviados al proveedor DEBEN minimizar identificadores innecesarios.

**RF-151.** La IA PUEDE utilizar datos del mantenimiento actual e históricos relevantes del mismo equipo y/o cliente.

### 7.12 Créditos IA

**RF-152.** Cada empresa DEBE poseer sus propios créditos IA.

**RF-153.** Los créditos DEBEN comprarse separadamente de la suscripción mediante paquetes.

**RF-154.** Cada operación IA DEBE consumir créditos.

**RF-155.** Diferentes funcionalidades IA PUEDEN consumir cantidades diferentes de créditos.

**RF-156.** El costo en créditos DEBE definirse por tipo de operación implementada.

**RF-157.** Una regeneración IA DEBE volver a consumir los créditos correspondientes.

**RF-158.** Una operación IA fallida DEBE revertir automáticamente el consumo asociado.

**RF-159.** Los créditos DEBEN implementarse conceptualmente mediante un ledger inmutable de movimientos y no mediante la mera modificación de un campo saldo.

**RF-160.** Límites IA por usuario quedan FUERA DEL MVP.

**RF-161.** `COMPANY_ADMIN` DEBE poder deshabilitar IA para su empresa.

**RF-162.** El sistema DEBE registrar métricas mínimas para conciliación de costos/consumo sin almacenar innecesariamente prompts o respuestas completas.

### 7.13 Suscripciones y pagos

**RF-163.** El MVP DEBE ofrecer un único plan pago sin niveles comerciales diferenciados.

**RF-164.** El plan DEBE poder contratarse con modalidad mensual o anual.

**RF-165.** Toda empresa nueva DEBE disponer durante un año de exactamente las mismas capacidades del plan pago con costo de suscripción $0.

**RF-166.** Finalizado el primer año, la empresa DEBE requerir una suscripción paga para continuar usando la plataforma.

**RF-167.** A efectos de acceso, la suscripción DEBE poder estar activa o inactiva.

**RF-168.** Tras vencer un pago, la empresa DEBE conservar acceso durante 20 días de gracia.

**RF-169.** Durante el período de gracia DEBE mostrarse un indicador visible de próxima suspensión.

**RF-170.** Al finalizar los 20 días sin regularización, la suscripción DEBE pasar a inactiva.

**RF-171.** Con suscripción inactiva, todos los usuarios del tenant DEBEN perder acceso online.

**RF-172.** La suspensión NO DEBE eliminar ni alterar la información del tenant.

**RF-173.** Un dispositivo podrá continuar offline sólo conforme a la autorización comercial máxima de 7 días definida en RF-118 a RF-120.

**RF-174.** Al reconocerse un pago válido de reactivación, el acceso DEBE restablecerse inmediatamente.

**RF-175.** La integración inicial de pagos DEBE utilizar Mercado Pago.

**RF-176.** La moneda inicial DEBE ser ARS.

**RF-177.** El mercado inicial DEBE ser Argentina.

**RF-178.** El idioma inicial DEBE ser español.

**RF-179.** Suscripción y compra de créditos DEBEN ser conceptos comerciales independientes.

**RF-180.** Los webhooks de pago DEBEN verificarse antes de producir efectos internos.

**RF-181.** El procesamiento de webhooks DEBE ser idempotente.

### 7.14 Dashboard y notificaciones

**RF-182.** El MVP DEBE incluir un dashboard.

**RF-183.** El MVP DEBE incluir notificaciones push cuando exista conectividad.

---

## 8. Requisitos no funcionales

### 8.1 Seguridad

**RNF-001.** El aislamiento tenant DEBE existir en la capa de datos mediante RLS.

**RNF-002.** Toda migración que modifique acceso DEBE incluir las políticas RLS correspondientes y pruebas.

**RNF-003.** Entradas provenientes de límites de confianza DEBEN validarse.

**RNF-004.** `service-role` keys, secretos de OpenAI y credenciales de Mercado Pago NO DEBEN exponerse al cliente.

**RNF-005.** Operaciones críticas DEBEN ser idempotentes cuando corresponda.

**RNF-006.** Cambios de autorización DEBEN aplicarse sin depender exclusivamente de estado cacheado en frontend.

### 8.2 Calidad y mantenibilidad

**RNF-007.** TypeScript DEBE mantenerse en modo estricto.

**RNF-008.** `any` NO DEBE utilizarse salvo justificación excepcional documentada.

**RNF-009.** La arquitectura DEBE ser modular dentro del mismo proyecto Next.js.

**RNF-010.** NO DEBEN introducirse microservicios sin una necesidad técnica demostrada y un ADR aprobado.

**RNF-011.** UI, dominio, persistencia e integraciones externas DEBEN mantenerse conceptualmente separadas.

**RNF-012.** Toda migración DEBE quedar versionada.

### 8.3 Offline y resiliencia

**RNF-013.** El sistema DEBE tolerar conectividad intermitente y períodos de varios días offline dentro de las reglas comerciales definidas.

**RNF-014.** Una falla de red NO DEBE provocar pérdida silenciosa de datos capturados localmente.

**RNF-015.** Sincronización y uploads DEBEN ser reintentables.

**RNF-016.** Los conflictos críticos DEBEN ser visibles y resolverse explícitamente.

### 8.4 Trazabilidad

**RNF-017.** Versiones publicadas de formularios DEBEN preservar interpretación histórica.

**RNF-018.** Revisiones de mantenimiento DEBEN ser trazables.

**RNF-019.** Versiones de informe DEBEN preservar snapshots inmutables.

**RNF-020.** El ledger de créditos DEBE permitir conciliación.

### 8.5 Compatibilidad

**RNF-021.** La PWA DEBE priorizar Android.

**RNF-022.** El DOCX DEBE buscar compatibilidad práctica con Microsoft Word, Google Docs y LibreOffice dentro del subconjunto de maquetación que se defina.

### 8.6 Privacidad y minimización

**RNF-023.** Los datos enviados a proveedores externos DEBEN limitarse a lo necesario para la operación.

**RNF-024.** No deben persistirse prompts/respuestas completas de IA salvo necesidad explícitamente aprobada.

---

## 9. Roles y permisos

| Capacidad | SUPER_ADMIN | COMPANY_ADMIN | TECHNICIAN |
|---|---|---|---|
| Crear empresa | Sí | No | No |
| Administrar plataforma global | Sí | No | No |
| Acceder normalmente a datos tenant | No | Sí, su tenant | Sólo alcance autorizado |
| Soporte excepcional tenant | Sólo con permiso explícito | Concede/revoca | No |
| Dar de alta usuarios tenant | No salvo primer admin | Sí | No |
| Deshabilitar/reintegrar usuarios | No salvo funciones globales futuras | Sí | No |
| Asignar clientes a usuarios | No | Sí, sólo de su empresa | No |
| Administrar clientes/ubicaciones/equipos | No por defecto | Sí | No |
| Crear/editar formularios | No por defecto | Sí | No |
| Ejecutar mantenimientos | No como operación normal; un `SupportAccessGrant` no debe inferir ejecución inicial | No | Sí dentro de clientes autorizados |
| Corregir mantenimientos | Sólo si soporte expresamente habilitado | Sí | Sí dentro de clientes autorizados |
| Administrar/finalizar informes | Sólo si soporte expresamente habilitado | Sí | No |
| Usar IA | No como operación normal | Sí | No |
| Administrar suscripción/créditos | Sólo soporte autorizado | Sí | No |

> **Nota de armonización de permisos:** la ejecución inicial de un mantenimiento corresponde a `TECHNICIAN` dentro de sus clientes autorizados. `COMPANY_ADMIN` puede leer mantenimientos cuando corresponda a sus funciones, corregir mantenimientos finalizados y resolver conflictos dentro de su alcance; esas capacidades pueden generar una nueva `MaintenanceRevision`, pero no conceden ejecución inicial. Un `SupportAccessGrant` concede únicamente el acceso excepcional expresamente autorizado por sus scopes y no genera capacidades operativas nuevas para `SUPER_ADMIN`. Esta corrección armoniza una fila histórica de la matriz con las reglas ya aprobadas y no constituye una ampliación ni una reducción nueva del alcance del producto.

### 9.1 Herencia de acceso del técnico

Cuando un `TECHNICIAN` tiene acceso a un cliente:

- obtiene acceso a todas las ubicaciones de ese cliente;
- obtiene acceso a todos los equipos de ese cliente;
- puede acceder a mantenimientos permitidos del cliente;
- no necesita asignación adicional por equipo ni mantenimiento.

---

## 10. Entidades principales del dominio

Esta sección es conceptual. NO define tablas SQL.

- **PlatformUser:** identidad autenticada de plataforma.
- **MaintenanceCompany:** tenant.
- **CompanyMembership/UserProfile:** pertenencia de `COMPANY_ADMIN` o `TECHNICIAN` a una empresa, rol y estado.
- **UserClientAccess:** autorización de un usuario sobre clientes concretos de su empresa.
- **SupportAccessGrant:** concesión excepcional de acceso de `SUPER_ADMIN`, con alcance y revocación.
- **AuditEvent:** evento de seguridad/auditoría no eliminable por operación normal.
- **Client:** cliente industrial del tenant.
- **Location:** nodo jerárquico perteneciente a un cliente.
- **EquipmentType:** clasificación privada del tenant.
- **Equipment:** activo mantenido perteneciente a un cliente y opcionalmente asociado a una ubicación.
- **FormTemplate:** formulario lógico activo/archivado.
- **FormVersion:** versión borrador/publicada.
- **MaintenanceRecord:** mantenimiento técnico autónomo.
- **MaintenanceRevision:** estado histórico de un mantenimiento finalizado/corregido.
- **Response:** respuesta a un campo de una versión de formulario.
- **Evidence:** fotografía vinculada a una respuesta.
- **EvidenceReplacementRelation:** vínculo que identifica una evidencia posterior como reemplazo visual sin borrar la original.
- **SyncOperation/OutboxItem:** operación local pendiente de sincronización.
- **SyncConflict:** conflicto de concurrencia detectado.
- **Report:** informe lógico mensual, con número oficial por empresa.
- **ReportVersion:** versión `v1`, `v2`, etc. con snapshot propio.
- **ReportSnapshot:** representación inmutable de datos utilizados para una versión de informe.
- **ReportTemplate:** configuración visual/estructural del informe.
- **AIUsageOperation:** operación IA facturable en créditos.
- **AICreditLedgerEntry:** movimiento inmutable de créditos.
- **Subscription:** estado comercial del tenant.
- **PaymentEvent:** evento conciliable/idempotente proveniente de Mercado Pago.
- **PushNotification:** notificación enviada cuando existe conectividad.

No forman parte del dominio MVP:

- sucursales;
- órdenes de trabajo;
- órdenes de compra;
- recurrencias;
- calendario;
- inventario;
- facturación de trabajos;
- presupuestos;
- portal cliente;
- IoT.

---

## 11. Reglas e invariantes de negocio

**INV-001.** Ningún usuario tenant puede pertenecer a más de una empresa de mantenimiento.

**INV-002.** `SUPER_ADMIN` no pertenece a ninguna empresa de mantenimiento.

**INV-003.** Todo dato tenant-owned pertenece exactamente a una empresa.

**INV-004.** Un usuario nunca puede recibir autorización sobre clientes de otro tenant.

**INV-005.** El acceso de `TECHNICIAN` a un cliente implica acceso a todas sus ubicaciones y equipos.

**INV-006.** El MVP no posee sucursales.

**INV-007.** El MVP no posee órdenes de trabajo.

**INV-008.** Una versión publicada de formulario es inmutable.

**INV-009.** Un mantenimiento conserva siempre la versión exacta de formulario utilizada.

**INV-010.** Una corrección de mantenimiento nunca sobrescribe una revisión finalizada anterior.

**INV-011.** Una evidencia finalizada nunca se elimina.

**INV-012.** Reemplazar visualmente una evidencia no elimina la evidencia sustituida.

**INV-013.** No existe Last Write Wins silencioso para registros críticos.

**INV-014.** Un usuario distinto no puede acceder a los datos offline locales de otra identidad.

**INV-015.** El trabajo capturado localmente no se elimina por suspensión comercial o expiración de la autorización offline.

**INV-016.** Una versión finalizada de informe no cambia aunque posteriormente cambien los mantenimientos fuente.

**INV-017.** El número oficial de informe se asigna al finalizarlo.

**INV-018.** Las regeneraciones conservan el mismo número oficial y aumentan la versión.

**INV-019.** Cada versión de informe posee snapshot propio e inmutable.

**INV-020.** IA nunca altera directamente mediciones, respuestas técnicas ni evidencias.

**INV-021.** El producto debe permitir generar informes sin IA.

**INV-022.** Los créditos se contabilizan mediante movimientos de ledger, no sólo mediante saldo mutable.

**INV-023.** Una operación IA fallida no puede dejar consumo definitivo sin compensación.

**INV-024.** Suscripción y créditos IA son conceptos independientes.

**INV-025.** Una empresa suspendida conserva íntegramente sus datos.

**INV-026.** El acceso se reactiva cuando se reconoce un pago válido de reactivación.

---

## 12. Flujos principales

### FL-01 — Alta de empresa y primer administrador

1. `SUPER_ADMIN` crea la empresa.
2. La empresa queda activa.
3. Ingresa el correo del primer `COMPANY_ADMIN`.
4. Se emite un código válido por 8 horas y 3 intentos.
5. Si se reenvía, se genera un código nuevo y se invalida el anterior.
6. El administrador ingresa con correo + código.
7. Completa su perfil.
8. Queda habilitado para administrar su empresa.

### FL-02 — Alta de usuario tenant

1. `COMPANY_ADMIN` registra el correo.
2. Define rol fijo.
3. Define clientes autorizados.
4. Se envía código con las mismas reglas de alta.
5. El usuario verifica su acceso y completa perfil.
6. El alcance queda limitado por tenant, rol y clientes autorizados.

### FL-03 — Deshabilitación y reintegración

1. `COMPANY_ADMIN` deshabilita al usuario.
2. Las sesiones activas se cierran automáticamente.
3. La identidad e historial se conservan.
4. Datos offline existentes permanecen protegidos y aislados por identidad.
5. En una reintegración futura se restablece el estado del usuario conforme a los permisos vigentes.

### FL-04 — Soporte excepcional de `SUPER_ADMIN`

1. `COMPANY_ADMIN` selecciona los clientes a los que dará acceso.
2. Para cada cliente selecciona secciones operativas permitidas.
3. Puede conceder además permisos de soporte a nivel empresa para usuarios/permisos, suscripción/pagos y créditos IA.
4. El acceso queda auditado.
5. `COMPANY_ADMIN` puede modificar o revocar el permiso en cualquier momento.
6. Los accesos efectivamente realizados quedan auditados.

### FL-05 — Creación y publicación de formulario

1. `COMPANY_ADMIN` crea o clona formulario.
2. Configura campos y reglas simples.
3. Previsualiza.
4. Publica.
5. La versión publicada queda inmutable.
6. Una edición futura crea automáticamente un nuevo borrador.
7. Una nueva publicación reemplaza la versión vigente para nuevos usos, conservando las anteriores.

### FL-06 — Ejecución de mantenimiento

1. El técnico selecciona un cliente autorizado.
2. Selecciona equipo/contexto de mantenimiento disponible.
3. El sistema determina la plantilla aplicable: específica del equipo si existe; de lo contrario, la asociada al tipo.
4. El técnico completa respuestas y evidencias.
5. En offline, los cambios se persisten localmente y entran en outbox.
6. El mantenimiento se finaliza conforme a las validaciones aplicables.
7. La sincronización conserva revisión y versión exacta del formulario.

### FL-07 — Corrección de mantenimiento finalizado

1. `COMPANY_ADMIN` o `TECHNICIAN` autorizado abre un mantenimiento finalizado.
2. Inicia una corrección.
3. Puede modificar todos los campos.
4. Puede agregar evidencia nueva y marcarla como reemplazo visual.
5. La evidencia/revisión previa se conserva.
6. La corrección genera una nueva revisión.
7. No existe aprobación posterior obligatoria.

### FL-08 — Sincronización y conflictos

1. Al recuperar conectividad, la outbox sincroniza operaciones.
2. Cada operación usa semántica idempotente.
3. Fotos permanecen locales hasta confirmación remota.
4. Si la revisión esperada difiere de la remota, se crea un conflicto.
5. Se conservan ambas versiones.
6. Se muestran diferencias.
7. Un actor autorizado decide resolución.
8. La resolución de mantenimiento produce una nueva revisión.

### FL-09 — Informe mensual

1. `COMPANY_ADMIN` selecciona cliente y período mensual.
2. Se construye un borrador a partir de mantenimientos aplicables.
3. Se configura contenido/plantilla.
4. Opcionalmente se utilizan funciones IA.
5. El administrador revisa y edita.
6. Al finalizar, se asigna el siguiente número correlativo de la empresa.
7. Se crea `v1` y su snapshot inmutable.
8. Se genera PDF oficial y DOCX editable desde el mismo modelo intermedio.

### FL-10 — Regeneración de informe

1. Se abre un informe finalizado, por ejemplo `INF-000123 v1`.
2. Se solicita regeneración.
3. Se toman las revisiones vigentes de los mantenimientos al momento de regenerar.
4. Se crea un snapshot nuevo.
5. Se conserva `INF-000123`.
6. Se crea `v2` (luego `v3`, etc.).
7. Las versiones anteriores permanecen inmutables.

### FL-11 — Operación IA

1. `COMPANY_ADMIN` elige una función IA disponible en informes.
2. El servidor prepara contexto minimizado.
3. Se aplica el costo de créditos de la operación.
4. Se invoca OpenAI desde servidor.
5. Si la operación falla, el consumo se revierte/compensa.
6. El resultado se presenta como texto editable.
7. Ningún dato técnico se modifica automáticamente.

### FL-12 — Suscripción

1. La empresa dispone del plan completo a $0 durante el primer año.
2. Luego contrata modalidad mensual o anual.
3. Si un pago vence, comienza gracia de 20 días.
4. Se muestra indicador de próxima suspensión.
5. Si no se paga, la suscripción pasa a inactiva.
6. El acceso online se bloquea sin borrar datos.
7. Offline sólo sigue siendo válido dentro de la autorización máxima de 7 días desde la última validación online.
8. Un pago válido de reactivación restablece acceso inmediatamente al ser reconocido.

---

## 13. Alcance exacto del MVP

Está dentro del MVP:

- SaaS multiempresa;
- `SUPER_ADMIN`, `COMPANY_ADMIN`, `TECHNICIAN`;
- alta por correo + código;
- clientes autorizados por usuario;
- clientes, ubicaciones jerárquicas, tipos de equipos y equipos;
- motor de formularios simple y versionado;
- mantenimiento preventivo, correctivo, predictivo e inspección;
- revisiones y evidencias;
- PWA offline-first;
- conflictos explícitos;
- informes mensuales PDF/DOCX;
- versionado de informes conservando correlativo;
- IA exclusivamente para redacción de informes;
- créditos IA;
- un único plan comercial mensual/anual;
- año inicial a $0;
- Mercado Pago;
- dashboard;
- notificaciones push con conectividad.

---

## 14. Funcionalidades explícitamente fuera del MVP

- sucursales de empresas de mantenimiento;
- órdenes de trabajo;
- asignaciones de técnicos a mantenimientos;
- técnico responsable asignado;
- mantenimientos recurrentes;
- calendario;
- órdenes de compra;
- exportación PDF de órdenes de compra;
- QR para equipos;
- importación/exportación de formularios;
- gráficos configurables en informes;
- límites IA por usuario;
- múltiples planes comerciales diferenciados;
- portal cliente;
- Client User;
- aplicación móvil nativa;
- IoT;
- inventario;
- presupuestos;
- facturación de trabajos;
- roles personalizados;
- multiidioma;
- white-label;
- IA de imágenes;
- SSO.

---

## 15. Requisitos offline consolidados

1. PWA orientada a Android.
2. Service Worker para assets.
3. Dexie/IndexedDB para datos operativos locales.
4. Precarga del alcance completo de clientes autorizados necesario para trabajo de campo.
5. Formularios publicados requeridos disponibles offline.
6. Escritura local antes de sincronización.
7. Outbox durable.
8. Operaciones idempotentes.
9. Fotos retenidas hasta confirmación remota.
10. Indicador de conexión y pendientes.
11. Sin Last Write Wins silencioso.
12. Conflictos conservan ambas versiones.
13. Resolución explícita con nueva revisión.
14. Datos locales aislados por identidad.
15. Logout no habilita a otro usuario a reutilizar datos locales previos.
16. Autorización comercial offline máxima de 7 días.
17. Suspensión comercial nunca elimina trabajo ya capturado.

---

## 16. Requisitos consolidados del motor de formularios

El motor DEBE ser deliberadamente simple para el usuario administrador.

Estados:

- formulario: activo / archivado;
- versión: borrador / publicada.

Capacidades MVP:

- crear;
- clonar;
- editar borrador;
- previsualizar;
- publicar;
- archivar;
- versionar automáticamente al editar un formulario publicado.

Tipos de campo MVP:

- texto corto/largo;
- entero/decimal;
- select;
- multiselect;
- checkbox;
- imágenes;
- archivos;
- tablas/matrices;
- secciones;
- grupos repetibles.

Condicionales MVP:

- mostrar campo según igualdad simple;
- volver obligatorio un campo según igualdad simple.

Quedan fuera:

- importación/exportación;
- expresiones arbitrarias;
- AND/OR complejos.

---

## 17. Requisitos consolidados de evidencias

- evidencia vinculada a una respuesta y asociable a cualquier campo;
- el campo de tipo imagen es un ítem autónomo cuya respuesta es imagen y no se confunde con evidencia;
- modos sin fotos/antes/después/antes y después;
- opcional u obligatoria;
- cámara o galería;
- compresión previa permitida;
- almacenamiento local hasta confirmación remota;
- inmutabilidad tras finalización;
- reemplazo visual permitido en revisión;
- evidencia sustituida permanece histórica;
- sin límites funcionales/comerciales propios del MVP sobre cantidad, tamaño o formatos de fotos/archivos, sin perjuicio de restricciones técnicas inevitables de infraestructura.

---

## 18. Requisitos consolidados de informes

- principal: mensual por cliente;
- consolidación de mantenimientos del período;
- plantilla propia por empresa;
- branding, portada, encabezado, pie, secciones, campos, orden, fotos y tablas;
- sin gráficos en MVP;
- ocultar valores vacíos;
- comparación antes/después;
- snapshot inmutable por versión;
- número correlativo por empresa al finalizar;
- regeneraciones conservan número y aumentan `vN`;
- PDF oficial;
- DOCX editable;
- modelo intermedio único para ambos formatos;
- modificaciones posteriores de mantenimientos no alteran informes ya emitidos.

---

## 19. Requisitos consolidados de IA y créditos

IA:

- sólo redacción de informes;
- sólo `COMPANY_ADMIN`;
- servidor exclusivamente;
- sin fotografías;
- contexto actual + históricos relevantes de equipo/cliente;
- minimización de datos identificatorios;
- contenido siempre revisable/editable;
- sistema totalmente utilizable sin IA.

Créditos:

- separados por tenant;
- compra por paquetes;
- separados de suscripción;
- costo variable por tipo de operación;
- regeneración vuelve a consumir;
- operación fallida compensa consumo;
- ledger inmutable;
- sin límites por usuario en MVP;
- administrador puede desactivar IA para toda su empresa.

---

## 20. Suscripciones

- un solo plan comercial;
- mensual o anual;
- mismas capacidades para todos;
- primer año exactamente igual al plan pago pero a $0;
- después requiere pago;
- estados comerciales de acceso: activa/inactiva;
- 20 días de gracia después del vencimiento;
- indicador visible durante la gracia;
- suspensión tras la gracia;
- sin pérdida de información;
- reactivación inmediata cuando se reconoce pago válido;
- autorización offline comercial máxima de 7 días desde última validación;
- Argentina, ARS, español;
- Mercado Pago;
- webhooks verificados e idempotentes.

---

## 21. Seguridad

### 21.1 Principios obligatorios

- RLS obligatorio para datos tenant-owned.
- Nunca confiar sólo en UI o middleware.
- Validar entradas en límites de confianza.
- No exponer secretos al cliente.
- Verificar webhooks externos.
- Operaciones críticas idempotentes.
- Acceso de soporte explícito, limitado y revocable.
- Datos offline aislados por identidad.

### 21.2 Revocación

La deshabilitación de usuario debe provocar cierre de sesiones activas. El usuario no se elimina y puede reintegrarse.

La implementación concreta de invalidación de sesiones, tokens y cachés se definirá en el documento de seguridad/RLS de Fase 0 sin debilitar esta regla de producto.

---

## 22. Auditoría

Como mínimo DEBEN registrarse como eventos no eliminables por operación normal:

- alta de usuario;
- deshabilitación/revocación;
- reintegración;
- cambio de rol;
- cambio de clientes/permisos autorizados;
- concesión de soporte a `SUPER_ADMIN`;
- modificación del alcance de soporte;
- revocación del soporte;
- accesos excepcionales efectivamente realizados por `SUPER_ADMIN`.

Cada evento debe permitir identificar al menos actor, empresa afectada, acción, momento y alcance.

Además deben existir las trazas históricas implícitas de versiones de formularios, revisiones de mantenimiento, snapshots/versiones de informes, movimientos de créditos y eventos de pago.

---

## 23. Restricciones técnicas

Stack aprobado:

- Next.js App Router;
- React;
- TypeScript estricto;
- Tailwind CSS;
- Supabase PostgreSQL;
- Supabase Auth;
- Supabase Storage;
- Supabase RLS;
- Dexie + IndexedDB;
- PWA / Service Worker;
- OpenAI API;
- Mercado Pago;
- Vercel;
- GitHub.

Restricciones:

- arquitectura modular en el mismo proyecto Next.js;
- no microservicios sin justificación y ADR;
- migraciones versionadas;
- RLS y pruebas junto con cambios de acceso;
- secretos sólo del lado servidor;
- TypeScript estricto;
- no `any` salvo excepción justificada.

---

## 24. Riesgos principales

| ID | Riesgo | Severidad | Mitigación normativa |
|---|---|---:|---|
| RSK-001 | Fuga entre tenants | Crítica | RLS obligatorio + pruebas negativas |
| RSK-002 | Permisos de cliente mal derivados | Alta | Modelo explícito usuario→cliente y herencia sólo descendente |
| RSK-003 | Soporte SUPER_ADMIN se convierte en bypass | Crítica | Grants explícitos, alcance granular, revocación y auditoría |
| RSK-004 | Revocación no corta sesiones efectivamente | Crítica | bloqueo por membresía/RLS online + revocación de sesión; autorización offline de identidad limitada a un máximo de 7 días desde la última validación online conforme a DO-075 aprobado |
| RSK-005 | Pérdida de datos offline | Crítica | local-first + outbox durable + idempotencia |
| RSK-006 | Conflictos sobrescritos | Alta | Prohibir LWW silencioso |
| RSK-007 | Fotos perdidas antes de upload | Crítica | conservar local hasta confirmación remota |
| RSK-008 | Dispositivo compartido expone datos | Crítica | aislamiento local por identidad |
| RSK-009 | Versionado de formularios rompe históricos | Crítica | versiones publicadas inmutables |
| RSK-010 | Evidencia reemplazada borra historia | Alta | reemplazo lógico, nunca eliminación |
| RSK-011 | PDF y DOCX divergen | Alta | modelo intermedio único |
| RSK-012 | Numeración/versiones de informes ambiguas | Reducida | número al finalizar + mismo número entre versiones |
| RSK-013 | Créditos duplicados por retries | Alta | ledger + reserva/confirmación/compensación idempotente (ADR-0006 propuesto) |
| RSK-014 | Webhooks duplicados/fuera de orden | Alta | verificación + idempotencia + reconciliación (ADR-0007 propuesto) |
| RSK-015 | Suspensión contradice operación offline | Alta | autorización offline acotada a 7 días |
| RSK-016 | IA recibe datos identificatorios innecesarios | Alta | minimización server-side |
| RSK-017 | UX del constructor se vuelve demasiado compleja | Alta | modelo simple y exclusión de features no esenciales |
| RSK-018 | Alcance se expande a ERP/IoT | Media/Alta | fuera de MVP explícito |
| RSK-019 | Ausencia de límites funcionales de fotos/archivos incrementa consumo local, ancho de banda y almacenamiento | Alta | documentar restricciones técnicas inevitables, observar consumo y mantener compresión opcional sin inventar cuotas de producto |

---

## 25. Contradicciones y ambigüedades revisadas

### 25.1 Resueltas durante Fase 0

**C-R01 — `SUPER_ADMIN` vs pertenencia tenant.** Resuelto: `SUPER_ADMIN` es global y no pertenece a empresa.

**C-R02 — Sucursales.** Resuelto: eliminadas del MVP.

**C-R03 — Asignaciones del técnico.** Resuelto: eliminadas; acceso por clientes autorizados.

**C-R04 — Correcciones post-finalización.** Resuelto: admin y técnico autorizados; todos los campos; nueva revisión; sin aprobación.

**C-R05 — Evidencia en correcciones.** Resuelto: reemplazo visual sin borrado histórico.

**C-R06 — Conflictos offline.** Resuelto: conservar ambas versiones, mostrar diferencias y generar nueva revisión al resolver.

**C-R07 — Logout en dispositivo compartido.** Resuelto: datos locales aislados por identidad; no reutilizables por otro usuario.

**C-R08 — Suscripción vs offline.** Resuelto en producto: autorización offline máxima de 7 días.

**C-R09 — Numeración de informes.** Resuelto: correlativa por empresa al finalizar.

**C-R10 — Regeneración de informes.** Resuelto: conserva número y crea `v2`, `v3`, etc.

**C-R11 — QR, recurrencias, calendario, órdenes de compra y órdenes de trabajo.** Resuelto: fuera del MVP.

**C-R12 — Campo de tipo imagen vs evidencia fotográfica.** Resuelto: el campo de imagen es un ítem autónomo del formulario cuya respuesta es imagen; la evidencia fotográfica es una capacidad asociable a cualquier campo y puede configurarse como sin fotos, antes, después o antes y después.

**C-R13 — Finalización offline.** Resuelto: al presionar `Guardar` y superar validaciones, el mantenimiento queda finalizado localmente aunque aún no esté sincronizado; la sincronización es un estado independiente y se ejecuta automáticamente al recuperar conexión cuando corresponda.

**C-R14 — Identidad de campos entre versiones.** Resuelto: los campos de versiones diferentes son independientes y no conservan una identidad lógica estable entre versiones en el MVP.

**C-R15 — Límites de evidencia/archivos.** Resuelto a nivel de producto: el MVP no impone límites funcionales/comerciales propios sobre formatos, tamaños o cantidades. Las restricciones técnicas inevitables de plataforma/infrastructura deberán documentarse sin presentarlas como cuotas de producto.

**C-A06 — Revocación de usuario estando totalmente offline.** **RESUELTA/APROBADA mediante DO-075.** La autorización offline de identidad puede mantenerse durante un máximo de 7 días desde la última validación online; una revocación conocida por el servidor debe aplicarse al recuperar conectividad; vencidos los 7 días no pueden iniciarse nuevas operaciones sin revalidación online; el trabajo ya capturado localmente no debe eliminarse.

### 25.2 Ambigüedades todavía abiertas

**C-A05 — Compatibilidad DOCX verificable.** Debe definirse y aprobarse, antes de Fase 6, el subconjunto portable de maquetación y su criterio de verificación práctica en Microsoft Word, Google Docs y LibreOffice. **Pendiente de aprobación de producto; bloquea Fase 6, no Fase 1.**

**C-A07 — Fin del año promocional y gracia.** El producto define un año a $0 y una gracia general de 20 días tras vencimiento. Debe resolverse antes de Fase 8 si la primera obligación de pago al finalizar el año también entra en esos 20 días de gracia. **Pendiente de aprobación; bloquea el detalle comercial de Fase 8, no Fase 1.**

---

## 26. Decisiones abiertas

Las decisiones ya resueltas no deben reaparecer como abiertas.

### 26.1 Decisiones de producto/aceptación todavía pendientes

**DO-073 — Alcance de notificaciones push.** Definir eventos que generan push. **No bloquea Fase 1–5; resolver antes de Fase 9.**

**DO-074 — Métricas del dashboard.** Definir métricas y filtros del MVP. **No bloquea Fase 1–9; resolver antes de Fase 10.**

**DO-076 — Gracia al finalizar el primer año a $0.** Propuesta: la primera obligación de pago al terminar el año promocional se trata como un vencimiento y dispone de los mismos **20 días de gracia** antes de suspensión. **Requiere aprobación antes de Fase 8; no bloquea Fase 1.**

**DO-077 — Subconjunto DOCX portable.** Definir y aprobar antes de Fase 6 el subconjunto de maquetación portable y la verificación práctica requerida en Microsoft Word, Google Docs y LibreOffice. **No bloquea Fase 1.**

**DO-078 — Cancelación/renovación comercial.** Definir antes de Fase 8 si mensual/anual renuevan automáticamente, cómo se cancela y si existe alguna regla de prorrateo. El brief actual no lo define.

### 26.2 Decisiones arquitectónicas/técnicas

**DO-T01 — Protocolo del ledger IA. PROPUESTO.** Reserva idempotente → ejecución → confirmación de consumo o liberación/compensación. Debe documentarse y aprobarse antes de Fase 7 en el documento derivado y ADR que correspondan.

**DO-T02 — State machine de Mercado Pago. PROPUESTO.** Ingesta verificada, eventos idempotentes, resolución/reconciliación y protección ante eventos fuera de orden. Debe documentarse y aprobarse antes de Fase 8 en el documento derivado y ADR que correspondan.

**DO-T03 — Invalidación efectiva de sesiones. PARCIALMENTE PROPUESTO.** Online: membresía/estado debe bloquear acceso en RLS aunque exista token, más revocación de sesión/credenciales renovables. Offline: DO-075 ya fija la política de producto aprobada de máximo 7 días y revalidación; la implementación técnica debe respetarla.

**DO-T04 — Protección local. PROPUESTO.** Persistencia particionada por identidad; una sesión sólo abre su propia réplica; logout no borra outbox pendiente. Cifrado adicional queda sujeto a análisis de amenazas/legal. Debe documentarse y aprobarse en la estrategia offline y ADR que correspondan antes de Fase 5.

**DO-T05 — Escala y rendimiento objetivo. DIFERIDO.** No existen volúmenes de negocio aprobados para fijar números sin inventarlos. Debe cuantificarse antes de pruebas de performance/piloto; no bloquea Fase 1.

**DO-T06 — Backup, RPO/RTO y restauración. DIFERIDO.** Requiere objetivos operativos de negocio y capacidades del plan de infraestructura elegido. Debe cerrarse antes del piloto/producción; no bloquea Fase 1.

**DO-T07 — Privacidad/legal aplicable. DIFERIDO.** Debe validarse antes del piloto con requisitos legales/contractuales aplicables a Argentina, fotografías y proveedores. No se inventan períodos de retención ni obligaciones jurídicas en Fase 0.

## 27. Documentos derivados requeridos para cerrar Fase 0

La especificación maestra `docs/product/01-product-definition.md` está **APROBADA** como baseline normativa de producto.

Para cerrar completamente la Fase 0 todavía deben ser realmente creados, revisados y aprobados, según corresponda:

1. `docs/product/02-domain-model.md`;
2. `docs/product/03-permissions-rls-strategy.md`;
3. `docs/product/04-offline-sync-strategy.md`;
4. `docs/product/05-form-engine-spec.md`;
5. `docs/product/06-maintenance-evidence-spec.md`;
6. `docs/product/07-reporting-engine-spec.md`;
7. `docs/product/08-ai-credits-spec.md`;
8. `docs/product/09-subscriptions-payments-spec.md`;
9. los ADRs arquitectónicos que resulten necesarios conforme se documenten las decisiones relevantes.

Si se mantiene un índice de Fase 0, deberá crearse o actualizarse `docs/product/00-phase-0-index.md` cuando corresponda.

Este documento NO declara que los documentos `02` a `09`, el índice ni los ADRs anteriores ya existan o estén aprobados. Su existencia y aprobación deberán verificarse individualmente antes de cerrar la Fase 0.

---

## 28. Gate de Fase 0

**Estado de la especificación maestra `01-product-definition.md`: APROBADA — baseline normativa de producto.**

**Estado de Fase 0: EN CURSO — pendientes documentos derivados y ADRs.**

`DO-075` está **RESUELTO/APROBADO** con la política ya definida: la autorización offline de identidad puede mantenerse durante un máximo de 7 días desde la última validación online; una revocación conocida por el servidor debe aplicarse al recuperar conectividad; vencidos los 7 días no pueden iniciarse nuevas operaciones sin revalidación online; el trabajo ya capturado localmente no debe eliminarse.

Para cerrar completamente la Fase 0 todavía corresponde:

1. crear, revisar y aprobar los documentos derivados enumerados en la sección 27;
2. crear, revisar y aprobar los ADRs que resulten necesarios para las decisiones arquitectónicas relevantes;
3. mantener `DO-073` diferida hasta antes de Fase 9;
4. mantener `DO-074` diferida hasta antes de Fase 10;
5. resolver `DO-076` y `DO-078` antes de Fase 8;
6. resolver `DO-077` antes de Fase 6;
7. documentar y resolver las decisiones técnicas `DO-T01` a `DO-T04` antes de las fases indicadas en la sección 26.2;
8. mantener `DO-T05`, `DO-T06` y `DO-T07` diferidas hasta los hitos expresamente indicados, sin inventar cifras, obligaciones o políticas no aprobadas.

La aprobación de `01-product-definition.md` NO equivale al cierre completo de la Fase 0.

Hasta cerrar el Gate completo de Fase 0, **NO corresponde inicializar Next.js, diseñar SQL, crear migraciones, escribir código ni iniciar Fase 1**.
