-- ============================================
-- ARCHIVO: Crear_Objetos.sql
-- PROYECTO: muebleria
-- FECHA: Febrero 2026
-- ============================================

USE muebleria;

-- ============================================
-- CREACIÓN DE VISTAS
-- ============================================

DROP VIEW IF EXISTS productos_activos;
CREATE VIEW productos_activos AS
SELECT 
    p.id_producto,
    p.nombre,
    p.precio,
    p.stock,
    p.activo
FROM producto p
WHERE p.activo = 1;


DROP VIEW IF EXISTS ventas_por_cliente;
CREATE VIEW ventas_por_cliente AS
SELECT 
    c.id_cliente,
    c.nombre,
    c.apellido,
    COUNT(DISTINCT v.id_venta) AS cantidad_compras,
    COALESCE(SUM(dv.subtotal), 0) AS total_gastado
FROM cliente c
LEFT JOIN venta v 
    ON c.id_cliente = v.id_cliente
LEFT JOIN detalle_venta dv 
    ON dv.id_venta = v.id_venta
GROUP BY c.id_cliente, c.nombre, c.apellido;


DROP VIEW IF EXISTS mas_vendidos_mes_actual;
CREATE VIEW mas_vendidos_mes_actual AS
SELECT 
    MONTHNAME(CURDATE()) AS mes_actual,
    p.id_producto,
    p.nombre,
    SUM(dv.cantidad) AS cantidad_vendida
FROM producto p
JOIN detalle_venta dv 
    ON p.id_producto = dv.id_producto
JOIN venta v 
    ON dv.id_venta = v.id_venta
WHERE MONTH(v.fecha) = MONTH(CURDATE())
  AND YEAR(v.fecha) = YEAR(CURDATE())
GROUP BY p.id_producto, p.nombre;


DROP VIEW IF EXISTS resumen_diario_ventas;
CREATE VIEW resumen_diario_ventas AS
SELECT 
    DATE(v.fecha) AS fecha,
    COUNT(DISTINCT v.id_venta) AS cantidad_ventas,
    COALESCE(SUM(dv.subtotal), 0) AS ingreso_total
FROM venta v
JOIN detalle_venta dv 
    ON v.id_venta = dv.id_venta
GROUP BY DATE(v.fecha);


DROP VIEW IF EXISTS producto_por_categoria;
CREATE VIEW producto_por_categoria AS
SELECT 
    cp.nombre AS nombre_categoria,
    p.id_producto,
    p.nombre AS nombre_producto
FROM producto p
JOIN categoria_producto cp 
    ON p.id_categoria_producto = cp.id_categoria_producto;


-- ============================================
-- CREACIÓN DE FUNCIONES
-- ============================================

DROP FUNCTION IF EXISTS calcular_iva;

DELIMITER $$

CREATE FUNCTION calcular_iva(monto DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
    RETURN ROUND(monto * 1.21, 2);
END $$

DELIMITER ;


DROP FUNCTION IF EXISTS stock_disponible;

DELIMITER $$

CREATE FUNCTION stock_disponible(p_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE stock_actual INT;

    SELECT stock
    INTO stock_actual
    FROM producto
    WHERE id_producto = p_id;

    RETURN stock_actual;
END $$

DELIMITER ;


-- ============================================
-- CREACIÓN DE PROCEDURES
-- ============================================

DROP PROCEDURE IF EXISTS registrar_venta;

DELIMITER $$

CREATE PROCEDURE registrar_venta(
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_id_venta INT;
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_stock INT;

    -- Verificar existencia y stock
    SELECT precio, stock
    INTO v_precio, v_stock
    FROM producto
    WHERE id_producto = p_id_producto;

    IF v_precio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Producto inexistente';
    END IF;

    IF v_stock < p_cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;

    START TRANSACTION;

    -- Crear cabecera de venta
    INSERT INTO venta (id_cliente, fecha)
    VALUES (p_id_cliente, NOW());

    SET v_id_venta = LAST_INSERT_ID();

    -- Insertar detalle
    INSERT INTO detalle_venta (
        id_venta,
        id_producto,
        cantidad,
        precio_unitario,
        subtotal
    )
    VALUES (
        v_id_venta,
        p_id_producto,
        p_cantidad,
        v_precio,
        ROUND(v_precio * p_cantidad, 2)
    );

    -- Descontar stock
    UPDATE producto
    SET stock = stock - p_cantidad
    WHERE id_producto = p_id_producto;

    COMMIT;

END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS actualizar_precios_categoria;

DELIMITER $$

CREATE PROCEDURE actualizar_precios_categoria(
    IN p_id_categoria_producto INT,
    IN p_porcentaje DECIMAL(5,2)
)
BEGIN
    UPDATE producto
    SET precio = ROUND(precio * (1 + p_porcentaje / 100), 2)
    WHERE id_categoria_producto = p_id_categoria_producto;
END $$

DELIMITER ;


-- ============================================
-- CREACIÓN DE TRIGGERS
-- ============================================

DROP TRIGGER IF EXISTS validar_stock;

DELIMITER $$

CREATE TRIGGER validar_stock
BEFORE UPDATE
ON producto
FOR EACH ROW
BEGIN
    IF NEW.stock < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;
END $$

DELIMITER ;


DROP TRIGGER IF EXISTS validar_cantidad;

DELIMITER $$

CREATE TRIGGER validar_cantidad
BEFORE INSERT
ON detalle_venta
FOR EACH ROW
BEGIN
    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad debe ser mayor a cero';
    END IF;
END $$

DELIMITER ;