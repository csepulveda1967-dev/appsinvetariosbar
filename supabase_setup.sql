-- =====================================================================
-- ESQUEMA DE BASE DE DATOS EN SUPABASE PARA SISTEMA DE INVENTARIOS
-- =====================================================================

-- 1. Tabla de Productos (Maestro de Inventario)
CREATE TABLE IF NOT EXISTS public.productos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo TEXT UNIQUE NOT NULL,
    nombre TEXT NOT NULL,
    area TEXT NOT NULL DEFAULT 'BAR',
    departamento TEXT DEFAULT 'BARRA',
    udm TEXT NOT NULL DEFAULT 'BOT',
    stock_actual NUMERIC(10, 2) NOT NULL DEFAULT 0,
    stock_minimo NUMERIC(10, 2) NOT NULL DEFAULT 0,
    costo_unitario NUMERIC(10, 2) NOT NULL DEFAULT 0,
    ubicacion TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Tabla de Movimientos Kardex (Auditoría en Tiempo Real)
CREATE TABLE IF NOT EXISTS public.movimientos_kardex (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fecha_hora TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    tipo TEXT NOT NULL,
    codigo_producto TEXT,
    nombre_producto TEXT,
    cantidad NUMERIC(10, 2) NOT NULL,
    detalle TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Tabla de Pedidos a Bodega Central
CREATE TABLE IF NOT EXISTS public.pedidos_bodega (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo_producto TEXT,
    nombre_producto TEXT NOT NULL,
    cantidad_pedida NUMERIC(10, 2) NOT NULL,
    cantidad_recibida NUMERIC(10, 2),
    tipo TEXT NOT NULL DEFAULT 'Sugerido Mínimo',
    motivo TEXT,
    estado TEXT NOT NULL DEFAULT 'Pendiente',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Habilitar seguridad Row Level Security (RLS)
ALTER TABLE public.productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.movimientos_kardex ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pedidos_bodega ENABLE ROW LEVEL SECURITY;

-- 5. Políticas de acceso para la aplicación web (Lectura y Escritura controlada)
DROP POLICY IF EXISTS "Acceso total productos" ON public.productos;
CREATE POLICY "Acceso total productos" ON public.productos FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Acceso total movimientos" ON public.movimientos_kardex;
CREATE POLICY "Acceso total movimientos" ON public.movimientos_kardex FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Acceso total pedidos" ON public.pedidos_bodega;
CREATE POLICY "Acceso total pedidos" ON public.pedidos_bodega FOR ALL USING (true) WITH CHECK (true);

-- 6. Carga inicial de productos base de Bar
INSERT INTO public.productos (codigo, nombre, area, departamento, udm, stock_actual, stock_minimo, costo_unitario, ubicacion)
VALUES 
    ('BAR-001', 'PISCO ALTO DEL CARMEN 35° 1.5 LTS', 'BAR', 'BARRA', 'BOT', 2, 4, 8500, 'Barra principal'),
    ('BAR-002', 'PISCO MISTRAL 35° 750 ML', 'BAR', 'BARRA', 'BOT', 3, 5, 6200, 'Barra principal'),
    ('BAR-003', 'WHISKY JOHNNIE WALKER BLACK 750 ML', 'BAR', 'CONTRABARRA', 'BOT', 1, 3, 18000, 'Contrabarra'),
    ('BAR-004', 'GIN BEEFEATER 750 ML', 'BAR', 'CONTRABARRA', 'BOT', 0, 2, 14500, 'Contrabarra'),
    ('BAR-005', 'CORONA BOTELLA 330 ML', 'BAR', 'COOLER', 'UNID', 56, 48, 1200, 'Cooler 1 cerveza'),
    ('BAR-006', 'CACHANTUN CON GAS 500 ML', 'BAR', 'COOLER', 'UNID', 120, 48, 600, 'Cooler aguas')
ON CONFLICT (codigo) DO NOTHING;
