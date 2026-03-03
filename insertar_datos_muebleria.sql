USE `muebleria`;

-- Inserción de Categorías
INSERT INTO `categoria_producto` (`id_categoria_producto`, `nombre`, `descripcion`) VALUES
(1, 'Dormitorio', 'Muebles para el descanso y guardado en habitaciones'),
(2, 'Sala de Estar', 'Muebles confortables para áreas comunes'),
(3, 'Comedor', 'Mesas y sillas para áreas de alimentación');

-- Inserción de Clientes
INSERT INTO `cliente` (`nombre`, `apellido`, `telefono`, `email`, `direccion`) VALUES
('Juan', 'Pérez', '1122334455', 'juan.perez@email.com', 'Av. Siempre Viva 123'),
('María', 'García', '2233445566', 'maria.garcia@email.com', 'Calle Falsa 456');

-- Inserción de Proveedores
INSERT INTO `proveedor` (`razon_social`, `telefono`, `email`, `direccion`) VALUES
('Maderas del Sur S.A.', '011-4567-8900', 'ventas@maderassur.com', 'Parque Industrial Lote 5'),
('Telas Premium S.R.L.', '011-9988-7766', 'contacto@telapremium.com', 'Calle Textil 202');

-- Inserción de Productos
INSERT INTO `producto` (`id_categoria_producto`, `nombre`, `descripcion`, `precio`, `stock`, `activo`) VALUES
(1, 'Cama King Size', 'Madera de roble con acabado natural', 1500.00, 0, 1),
(2, 'Sofá 3 Cuerpos', 'Tapizado en lino gris', 1200.00, 0, 1),
(3, 'Mesa de Comedor', 'Vidrio templado y patas de metal', 850.00, 0, 1);

-- Inserción de Compras a Proveedores
INSERT INTO `compra` (`id_proveedor`, `fecha`, `total`) VALUES
(1, '2026-03-01 10:00:00', 6000.00),
(2, '2026-03-01 11:30:00', 2400.00);

-- Inserción de Detalles de Compra (Aumenta el stock vía Trigger)
INSERT INTO `detalle_compra` (`id_compra`, `id_producto`, `cantidad`, `precio_unitario`) VALUES
(1, 1, 4, 1500.00),
(2, 2, 2, 1200.00);

-- Inserción de Ventas a Clientes
INSERT INTO `venta` (`id_cliente`, `fecha`, `estado`) VALUES
(1, '2026-03-02 14:00:00', 'CONFIRMADA'),
(2, '2026-03-02 16:45:00', 'PENDIENTE');

-- Inserción de Detalles de Venta (Reduce el stock y registra movimiento vía Trigger)
INSERT INTO `detalle_venta` (`id_venta`, `id_producto`, `cantidad`, `precio_unitario`, `subtotal`) VALUES
(1, 1, 1, 1500.00, 1500.00),
(2, 2, 1, 1200.00, 1200.00);