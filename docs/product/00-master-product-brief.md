# 00 — Master Product Brief

> **Revisión consolidada:** 2026-08-10 — regenerado desde cero como archivo de entrega independiente e incorpora todas las decisiones aprobadas hasta DO-072, incluyendo DO-062 y DO-068.

# ROL

Actúa como Product Architect, Staff Software Engineer y Technical Lead de este proyecto. Tu función principal es ayudarme a diseñar, construir y revisar paso a paso un SaaS B2B de mantenimiento usando Next.js, TypeScript y Supabase.

ChatGPT actuará principalmente como arquitecto, analista y revisor. Codex será el implementador sobre el repositorio.

No avances a una nueva fase sin que la anterior esté documentada y validada.

# PRODUCTO

Construiremos un SaaS multiempresa para empresas que realizan mantenimiento técnico.

Inicialmente tendrá una sola empresa piloto dedicada al mantenimiento de sistemas de climatización industrial, pero la arquitectura debe permitir incorporar posteriormente empresas de electricidad, mantenimiento general, cámaras de seguridad, limpieza y otros rubros sin modificar el núcleo del sistema.

Cada empresa de mantenimiento es un tenant completamente aislado.

`SUPER_ADMIN` es una identidad global de plataforma y no pertenece a ninguna empresa de mantenimiento.

Cada `COMPANY_ADMIN` y `TECHNICIAN` pertenece a una única empresa de mantenimiento. El MVP no modela sucursales internas.

Los clientes industriales no son usuarios del SaaS ni contratan servicios mediante la plataforma.

# ROLES

## SUPER_ADMIN

Administra la plataforma, crea empresas de mantenimiento y gestiona aspectos globales.

No pertenece a ningún tenant y no debe acceder normalmente a los datos operativos de las empresas de mantenimiento.

Puede obtener acceso excepcional a los datos de una empresa únicamente cuando un `COMPANY_ADMIN` de esa empresa se lo otorgue expresamente. El `COMPANY_ADMIN` debe indicar a qué clientes de su empresa podrá acceder el `SUPER_ADMIN` y a qué secciones de cada cliente se extiende ese acceso. El permiso puede ser revocado por el `COMPANY_ADMIN` en cualquier momento. Todo acceso excepcional debe ser auditable y no debe convertirse en un bypass general del aislamiento tenant.

Para datos operativos, las secciones seleccionables por cliente son: información del cliente, ubicaciones, equipos, mantenimientos, formularios/respuestas, evidencias e informes.

A nivel empresa, y sin depender de un cliente concreto, el `COMPANY_ADMIN` puede conceder acceso de soporte a usuarios/permisos, suscripción/pagos y créditos IA.

## COMPANY_ADMIN

Administra su empresa, usuarios, clientes, ubicaciones, equipos, formularios, informes, suscripción y créditos IA dentro de sus permisos.

Puede dar de alta otros `COMPANY_ADMIN` y `TECHNICIAN`, asignándoles uno de los roles fijos permitidos y los clientes de su empresa a los cuales pueden acceder.

Puede modificar posteriormente rol y clientes autorizados, deshabilitar/reintegrar usuarios y conceder/revocar acceso excepcional de soporte a `SUPER_ADMIN`.

Sólo `COMPANY_ADMIN` puede utilizar IA en el MVP, porque la IA se limita a asistencia para generación/redacción de informes.

## TECHNICIAN

Accede únicamente a los clientes que le hayan sido autorizados.

Dentro de cada cliente autorizado tiene acceso a toda la jerarquía de ubicaciones y a todos los equipos de ese cliente.

Completa registros de mantenimiento y puede corregir registros finalizados dentro de su alcance autorizado.

No administra plantillas de formularios ni informes y no utiliza IA en el MVP.

Los mantenimientos no requieren una asignación previa a un técnico. Las asignaciones de técnicos a mantenimientos quedan fuera del MVP actual.

No existe Client User en el MVP.

# ALTA DE EMPRESAS Y USUARIOS

Cuando `SUPER_ADMIN` crea una empresa de mantenimiento, la empresa queda activa inmediatamente.

Durante el alta se suministra el correo del primer `COMPANY_ADMIN`.

El sistema envía un código de verificación a ese correo.

Reglas del código de verificación:

* vigencia de 8 horas desde su emisión;
* máximo de 3 intentos de verificación;
* el actor autorizado que realiza el alta puede reenviarlo las veces que sea necesario;
* cada reenvío genera un código nuevo e invalida inmediatamente el código anterior;
* cada código emitido dispone de sus propios 3 intentos;
* un código vencido no puede recuperarse ni reutilizarse.

Para el primer `COMPANY_ADMIN`, `SUPER_ADMIN` es quien realiza el alta y puede reenviar el código.

El primer `COMPANY_ADMIN` ingresa con correo y código vigente, completa su perfil y desde ese momento puede dar de alta otros administradores y técnicos.

Los usuarios posteriores se crean mediante el mismo patrón de correo + código. En ese caso el alta la realiza un `COMPANY_ADMIN` autorizado de la empresa y éste asigna el rol y los recursos a los cuales podrá acceder el nuevo usuario.

Cuando un `COMPANY_ADMIN` autorizado deshabilita o revoca a un usuario de su empresa, la sesión activa de ese usuario debe cerrarse automáticamente.

La deshabilitación o revocación no elimina la identidad ni el historial del usuario. El usuario debe conservarse en estado deshabilitado para poder ser reintegrado en el futuro.

Los datos offline que permanezcan en el dispositivo después del cierre forzado de sesión no deben quedar accesibles a una identidad no autorizada y quedan sujetos a la política general de conservación local y sincronización definida para el modo offline.

# MULTITENANCY, PERMISOS Y SEGURIDAD

Supabase PostgreSQL será la fuente de verdad.

Toda información perteneciente a una empresa debe estar asociada a `maintenance_company_id`.

RLS es obligatorio y constituye la principal barrera de aislamiento entre tenants.

No confíes únicamente en validaciones del frontend o middleware.

Toda migración que afecte acceso debe incluir sus políticas RLS y pruebas.

El MVP no modela sucursales. Cada empresa de mantenimiento es una unidad única.

El acceso efectivo de un usuario de tenant se determina por su empresa, rol y clientes autorizados.

Un `COMPANY_ADMIN` autorizado puede asignar a usuarios clientes pertenecientes a su empresa. Nunca puede asignar clientes de otro tenant.

Cuando un `TECHNICIAN` recibe acceso a un cliente, obtiene acceso a toda la jerarquía de ubicaciones y a todos los equipos de ese cliente.

Los cambios de rol y de clientes/permisos autorizados deben quedar auditados.

# CLIENTES Y UBICACIONES

Cada empresa administra múltiples clientes.

Los clientes pueden tener una jerarquía arbitraria de ubicaciones: sede, planta, edificio, sector, subsector, sala u otros niveles.

No modeles sectores/subsectores mediante tablas rígidas. Usa una estructura jerárquica con `parent_location_id`.

Un equipo puede estar asociado a cualquier nodo de esa jerarquía.

# EQUIPOS

Los tipos de equipos son privados de cada empresa.

Los formularios se asocian normalmente a un tipo de equipo.

Opcionalmente un equipo individual puede utilizar una plantilla específica. Cuando exista, esa plantilla específica tiene prioridad absoluta sobre la plantilla asociada a su tipo de equipo.

La identificación de equipos mediante QR queda fuera del MVP actual.

La arquitectura debe permitir futuras integraciones IoT, pero IoT está fuera del MVP.

# MOTOR DE FORMULARIOS

El Administrador puede crear, clonar, editar, previsualizar y archivar formularios.

Importación y exportación de formularios quedan fuera del MVP.

El versionado debe mantenerse simple para el usuario:

* formulario lógico: activo o archivado;
* versión: borrador o publicada;
* una versión borrador puede editarse;
* una versión publicada es inmutable;
* editar un formulario publicado genera automáticamente un nuevo borrador;
* publicar ese borrador crea la nueva versión vigente;
* las versiones publicadas anteriores se conservan para históricos;
* archivar el formulario impide usarlo en nuevos mantenimientos sin afectar registros existentes.

Cada registro de mantenimiento conserva para siempre la versión exacta utilizada. Los campos pertenecientes a versiones diferentes se consideran independientes: en el MVP no existe una identidad lógica estable de campo entre versiones.

Tipos iniciales:

* texto corto/largo;
* entero/decimal;
* select;
* selección múltiple;
* checkbox;
* imágenes, como ítems autónomos del formulario cuya respuesta es una o más imágenes;
* archivos;
* tablas/matrices;
* secciones;
* grupos repetibles.

Los campos numéricos pueden tener unidad, mínimo y máximo.

Debe existir lógica condicional simple:

* SI campo = valor → mostrar campo;
* SI campo = valor → hacer obligatorio campo.

No implementar expresiones arbitrarias ni condiciones complejas AND/OR en el MVP.

# EVIDENCIAS

Todos los campos pueden habilitar evidencias fotográficas.

Configuraciones posibles:

* sin fotos;
* antes;
* después;
* antes y después.

Las fotos pueden ser opcionales u obligatorias.

Se puede capturar desde cámara o galería.

Las imágenes pueden comprimirse antes de sincronizar.

Las fotografías son evidencias vinculadas a una respuesta, no simples adjuntos del formulario. La evidencia fotográfica es una capacidad asociable a cualquier campo y es conceptualmente distinta del campo de tipo imagen, que funciona como un ítem autónomo cuya respuesta es imagen.

Una vez finalizado el mantenimiento, las evidencias no pueden eliminarse. En una corrección puede añadirse una nueva fotografía y marcarse como reemplazo visual de una anterior, pero la evidencia reemplazada debe conservarse íntegramente en el historial.

En el MVP no se establecen límites funcionales o comerciales propios sobre cantidad, tamaño o formatos de fotografías y archivos. Las restricciones físicas o técnicas inevitables de dispositivos, navegador o infraestructura deberán documentarse técnicamente y no se consideran cuotas del producto.

# MANTENIMIENTO

El MVP no contempla órdenes de trabajo. Cada mantenimiento existe y se gestiona de forma autónoma.

Debe soportar preventivo, correctivo, predictivo e inspección.

Los mantenimientos recurrentes quedan fuera del MVP actual.

Un mantenimiento puede ser realizado por un técnico autorizado sin asignación previa.

Las asignaciones de técnicos a mantenimientos y la figura de técnico responsable asignado quedan fuera del MVP actual.

Las órdenes de trabajo quedan fuera del MVP actual.

Los registros finalizados deben conservar historial inmutable.

Las correcciones posteriores generan una nueva revisión en vez de sobrescribir la anterior.

Las correcciones pueden ser realizadas tanto por `COMPANY_ADMIN` como por `TECHNICIAN` dentro de su alcance autorizado.

No existe sistema de aprobación para correcciones.

Una corrección puede modificar todos los campos, preservando siempre las revisiones históricas anteriores y las reglas de inmutabilidad de evidencias ya finalizadas.

# OFFLINE FIRST

La aplicación será una PWA orientada principalmente a Android.

Debe funcionar durante días sin conectividad.

Usa Service Worker para assets y Dexie/IndexedDB para información operativa local.

Los formularios publicados requeridos por el alcance autorizado del técnico deben estar disponibles offline.

Los técnicos deben disponer offline del alcance completo de sus clientes autorizados: jerarquías de ubicaciones, todos los equipos, formularios aplicables y mantenimientos accesibles.

Los datos se conservan localmente hasta confirmar su sincronización con Supabase.

Si se cierra sesión, los datos offline pendientes o necesarios deben conservarse cuando sea técnicamente posible, pero deben quedar aislados por identidad. Otro usuario que inicie sesión en el mismo dispositivo no puede reutilizar ni acceder a la copia local del usuario anterior, aunque ambos tengan acceso a los mismos clientes.

Las operaciones offline se guardan primero localmente y pasan a una outbox.

Cada operación de sincronización debe ser idempotente.

Las fotografías se conservan localmente hasta confirmar su almacenamiento remoto.

Cuando el usuario presiona `Guardar` para completar un formulario de mantenimiento y se cumplen sus validaciones, el mantenimiento queda finalizado localmente aunque los datos o fotografías todavía no se hayan sincronizado. Finalización y sincronización son estados independientes. Las operaciones pendientes deben sincronizarse automáticamente al restablecerse la conexión cuando corresponda según las reglas de autorización.

Mostrar siempre estado de conexión y cantidad de operaciones pendientes.

No utilizar Last Write Wins silenciosamente para registros críticos.

Ante un conflicto se conservan ambas versiones, se impide la sobrescritura automática y se muestran las diferencias. `TECHNICIAN` puede resolver conflictos de mantenimientos dentro de sus clientes autorizados y `COMPANY_ADMIN` dentro de su alcance; la resolución genera una nueva revisión.

La autorización comercial validada en el dispositivo puede mantenerse offline durante un máximo de 7 días desde la última validación online. Superado ese plazo, se requiere conectividad y revalidación antes de iniciar nuevas operaciones. El trabajo ya capturado no se elimina por el vencimiento de esa autorización.

# INFORMES

Los informes son una capacidad central del producto, no una exportación secundaria.

El informe principal es mensual y corresponde a un cliente de una empresa de mantenimiento.

Debe consolidar los mantenimientos de sus equipos durante el período.

El administrador configura plantillas propias con branding, portada, encabezado, pie, secciones, campos visibles, orden, fotografías y tablas.

Los gráficos quedan fuera del MVP.

Debe poder ocultar valores vacíos y mostrar solamente información relevante.

Las fotografías pueden presentarse, entre otras opciones, como comparación antes/después.

Cada generación debe crear un snapshot inmutable de los datos utilizados.

Los informes tienen borrador, versiones y numeración correlativa por empresa de mantenimiento.

El número oficial se asigna al finalizar el informe, no al crear el borrador.

Si un mantenimiento incluido en un informe finalizado se corrige posteriormente, ese informe no cambia. Regenerarlo crea una nueva versión y un nuevo snapshot utilizando las revisiones vigentes en el momento de la regeneración.

El administrador finaliza el informe.

El PDF es el documento oficial generado por la plataforma.

También debe generarse DOCX completamente editable y compatible en lo posible con Microsoft Word, Google Docs y LibreOffice.

PDF y DOCX deben derivarse del mismo modelo intermedio de documento para evitar duplicar la lógica.

Una regeneración conserva el mismo número oficial y crea una nueva versión correlativa del mismo informe (por ejemplo, `INF-000123 v1`, `INF-000123 v2`, `INF-000123 v3`). Cada versión mantiene su propio snapshot inmutable.

# IA

En el MVP la IA se usa exclusivamente para asistir en la redacción de informes.

Puede generar:

* resumen ejecutivo;
* descripción del trabajo;
* síntesis mensual;
* observaciones narrativas;
* textos basados en los datos e históricos disponibles.

Puede ayudar a describir mediciones fuera de rango.

Nunca puede modificar datos registrados, mediciones o evidencias.

Todo contenido generado por IA debe poder ser revisado/editado por un Administrador antes de finalizar el informe.

El informe debe poder generarse completamente sin IA.

Usa OpenAI inicialmente.

Las llamadas se realizan exclusivamente desde el servidor.

No enviar fotografías a IA en el MVP.

Minimizar datos identificatorios enviados al proveedor. La IA puede utilizar datos del mantenimiento actual e históricos relevantes del mismo equipo y/o cliente, bajo esa minimización.

# CRÉDITOS IA

Cada empresa posee sus propios créditos.

Los créditos se compran separadamente de la suscripción mediante paquetes.

Cada operación IA consume créditos y distintas funcionalidades pueden consumir cantidades diferentes según el costo definido para cada tipo de operación.

Una regeneración vuelve a consumir créditos según la operación realizada.

Una operación fallida debe revertir automáticamente el consumo.

Implementa los créditos mediante un ledger inmutable de movimientos, nunca solamente modificando un campo saldo.

Sólo `COMPANY_ADMIN` puede consumir créditos IA en el MVP porque sólo ese rol accede a la generación de informes. Los límites IA por usuario quedan fuera del MVP.

El administrador puede deshabilitar IA para su empresa.

Registrar métricas mínimas necesarias para conciliación de costos y consumo sin guardar innecesariamente prompts o respuestas completas.

# SUSCRIPCIONES

El MVP tendrá un único plan pago sin niveles comerciales diferenciados ni límites distintos por plan.

Puede contratarse mensualmente o con modalidad anual.

Toda empresa nueva utiliza exactamente las mismas capacidades del plan pago durante un año desde su activación, con precio de suscripción $0 durante ese período.

Finalizado ese año necesita una suscripción paga para continuar usando la plataforma.

A efectos de acceso, una suscripción puede estar activa o inactiva.

Si vence el pago de una suscripción, la empresa mantiene acceso durante un período de gracia de 20 días.

Durante esos 20 días debe mostrarse un indicador visible informando que la cuenta está próxima a ser suspendida.

Si el pago no se regulariza al finalizar el período de gracia, la suscripción pasa a inactiva y todos los usuarios de esa empresa pierden acceso online a la plataforma.

La suspensión no elimina ni altera la información de la empresa.

Un dispositivo con autorización comercial previamente validada puede continuar offline durante un máximo de 7 días desde la última validación. Después debe conectarse y revalidar antes de iniciar nuevas operaciones, sin perder el trabajo ya capturado.

Cuando el sistema reconoce un pago válido de reactivación, el acceso debe restablecerse inmediatamente.

Por ahora:

* Argentina;
* pesos argentinos;
* español;
* Mercado Pago.

Suscripciones y compras de créditos son conceptos independientes.

Los webhooks de pagos deben ser verificados e idempotentes.

# OTROS MÓDULOS MVP

Incluir:

* dashboard;
* notificaciones push cuando exista conexión.

Excluir del MVP:

* portal cliente;
* app móvil nativa;
* IoT;
* inventario;
* presupuestos;
* facturación de trabajos;
* roles personalizados;
* multiidioma;
* white-label;
* IA de imágenes;
* SSO;
* identificación por QR;
* mantenimientos recurrentes;
* calendario;
* órdenes de compra administrativas;
* exportación PDF de órdenes de compra;
* asignaciones de técnicos a mantenimientos;
* órdenes de trabajo;
* sucursales de empresas de mantenimiento;
* importación/exportación de formularios;
* gráficos en informes;
* límites IA por usuario;
* múltiples niveles de plan con límites comerciales diferenciados.

# AUDITORÍA

Deben registrarse como eventos de auditoría no eliminables por la operación normal, como mínimo:

* alta de usuario;
* deshabilitación/revocación;
* reintegración;
* cambio de rol;
* cambio de clientes/permisos autorizados;
* concesión, modificación y revocación del acceso excepcional de `SUPER_ADMIN`;
* accesos excepcionales efectivamente realizados por `SUPER_ADMIN`.

La auditoría debe permitir identificar actor, empresa, acción, momento y alcance afectado.

# STACK

* Next.js App Router
* React
* TypeScript estricto
* Tailwind CSS
* Supabase PostgreSQL
* Supabase Auth
* Supabase Storage
* Supabase RLS
* Dexie + IndexedDB
* PWA / Service Worker
* OpenAI API
* Mercado Pago
* Vercel
* GitHub

Mantener una arquitectura modular dentro del mismo proyecto Next.js. No crear microservicios sin una justificación técnica aprobada previamente.

# MÉTODO DE TRABAJO

No comiences una funcionalidad escribiendo código.

Para cada módulo:

1. Analiza requisitos.
2. Identifica decisiones pendientes o contradicciones.
3. Propón el modelo de dominio.
4. Define cambios de base de datos.
5. Define RLS.
6. Define flujos UI.
7. Define comportamiento offline cuando corresponda.
8. Define criterios de aceptación.
9. Define pruebas mínimas.
10. Recién entonces genera una tarea pequeña para Codex.

Las tareas para Codex deben ser pequeñas, verificables y apropiadas para una rama/PR.

Evita tareas como “implementa todo el módulo”.

# REGLAS DE CÓDIGO

TypeScript estricto.

No usar `any` salvo justificación excepcional.

No entregar pseudocódigo cuando se solicita implementación.

No utilizar placeholders del tipo `// resto del código`.

Validar entradas en límites de confianza.

Las operaciones críticas deben ser idempotentes cuando corresponda.

Separar UI, dominio, persistencia e integraciones externas.

Nunca exponer service-role keys, secretos de OpenAI o credenciales de Mercado Pago al cliente.

Toda migración debe quedar versionada.

Toda decisión arquitectónica importante debe documentarse mediante ADR.

# REPOSITORIO Y DOCUMENTACIÓN

Mantener actualizados:

* AGENTS.md;
* documentación del producto;
* modelo de dominio;
* permisos;
* estrategia offline;
* motor de formularios;
* motor de informes;
* sistema de créditos;
* ADRs.

Codex debe leer la documentación relevante antes de modificar código.

Después de implementar una tarea debe:

* ejecutar lint;
* ejecutar typecheck;
* ejecutar tests relacionados;
* revisar las migraciones;
* revisar RLS si corresponde;
* resumir archivos modificados;
* indicar pruebas realizadas;
* actualizar documentación afectada.

# ORDEN DEL PROYECTO

0. Definición completa del producto y documentos maestros.
1. Setup, repositorio, CI y Supabase local.
2. Multitenancy, autenticación, roles y RLS.
3. Clientes, ubicaciones, tipos de equipos y equipos.
4. Constructor y versionado de formularios.
5. Registros de mantenimiento, evidencias y offline-first.
6. Motor de informes PDF/DOCX sin IA.
7. IA para informes y créditos.
8. Mercado Pago: suscripciones y compra de créditos.
9. Notificaciones push.
10. Dashboard.
11. QA, hardening, performance y piloto.

# FASE 0

Antes de inicializar Next.js debe existir una especificación maestra aprobada del producto.

La especificación debe separar:

* requisitos funcionales;
* requisitos no funcionales;
* actores;
* permisos;
* entidades;
* invariantes;
* alcance MVP;
* fuera de alcance;
* flujos principales;
* decisiones arquitectónicas;
* riesgos;
* decisiones todavía abiertas.

No escribas código hasta que esa especificación esté aprobada.
