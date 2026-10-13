# Diseño técnico del sistema de inventario para cocina y bar

## Objetivo

Diseñar un sistema de inventario para controlar productos de cocina y bar, considerando ingreso de materia prima, producción, mermas, rotación FIFO, stock mínimo, solicitudes de mercadería, venta de líquidos por receta y un maestro de movimientos en tiempo real.

## Áreas y bodegas

El sistema considera tres ubicaciones principales: Bodega Central, Bodega Transitoria Cocina y Bodega Transitoria Bar. La Bodega Central recibe y abastece. La Bodega Transitoria Cocina mantiene insumos, materias primas y producciones para el servicio. La Bodega Transitoria Bar mantiene líquidos, insumos de coctelería y productos necesarios para ventas de bar.

## Módulos del sistema

El sistema se divide en maestro de productos, ingreso por lote, control FIFO, producción de cocina, recetas de bar, mermas, traspasos, stock mínimo, solicitudes a bodega central y maestro de movimientos. Cada módulo genera movimientos auditables para reconstruir el kardex de cualquier producto.

## Modelo de datos recomendado

Las entidades principales son Producto, Bodega, Lote, Movimiento, Receta, Ingrediente de receta, Producción, Venta bar, Merma y Solicitud. Producto contiene código, nombre, área, categoría, unidad y mínimo. Lote contiene producto, bodega, cantidad, costo y vencimiento. Movimiento es la tabla central y registra fecha, tipo, producto, bodega, cantidad, costo, lote y observación. Receta define el consumo estándar de cocina o bar.

## Reglas de negocio

Todo ingreso aumenta stock y crea lote. Toda salida debe aplicar FIFO por vencimiento. Si no existe stock suficiente, la operación debe bloquearse. Las recetas de cocina consumen insumos y pueden generar un producto terminado o semielaborado. Las recetas de bar rebajan líquidos por cantidad exacta, idealmente en mililitros. Las mermas siempre requieren motivo. El stock mínimo genera alerta y una solicitud sugerida a bodega central.

## Flujo cocina

Cocina recibe materia prima desde bodega central, registra ingresos en bodega transitoria, produce recetas, consume insumos con FIFO, registra mermas y revisa mínimos antes del servicio. Cuando un producto queda bajo mínimo, se crea una solicitud a bodega central.

## Flujo bar

Bar recibe líquidos desde bodega central, mantiene control por botella o mililitros, registra ventas por receta y rebaja stock teórico. El control permite comparar inventario físico contra consumo esperado y detectar diferencias por sobreporción, merma, invitación no registrada o error de registro.

## Maestro de movimientos en tiempo real

El maestro de movimientos debe mostrar todos los eventos de stock: ingresos, consumos de producción, producción generada, ventas de bar, mermas, salidas por traspaso, ingresos por traspaso y ajustes. Este maestro es la fuente de auditoría y permite calcular stock por producto y bodega.

## Indicadores recomendados

Los indicadores principales son stock actual, productos bajo mínimo, productos sin stock, valorización de inventario, mermas por motivo, consumo por receta, solicitudes pendientes, rotación por producto y productos próximos a vencer.

## Etapas de implementación

La primera etapa es validar el flujo con el prototipo HTML local. La segunda etapa es cargar productos, recetas y mínimos reales. La tercera etapa es operar con la planilla Excel como respaldo y control diario. La cuarta etapa es migrar a una aplicación con base de datos, usuarios, permisos y reportes. La quinta etapa es integrar el punto de venta para que las ventas de bar rebajen inventario automáticamente por receta.
