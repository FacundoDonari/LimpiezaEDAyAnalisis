

-- PREGUNTAS A RESPONDER --

-- 1. Promedio de ventas mensuales -- 
-- 2. Cuantas ventas por mes --
-- 3. Cual es el mes en el que mas venden --
-- 4. Quienes son los clientes mas importantes --
-- 5. Monto promedio que gastan los clientes --
-- 6. Que porcentaje de sus clientes volcieron a comprar --
-- 7. Como se desglosa esta informacion segun los paises a los que les venden --


select*
from ventass;

select
		max(fecha_de_factura),
        min(fecha_de_factura)
from ventass;

-- 1.Promedio de ventas mensuales --

with ventas_mensuales as
(
select
		sum(monto) as total_mes,
        month(fecha_de_factura) as mes
from ventass
group by 2 -- se esta juntado diciembre de 2020 y diciembre 2021 pero solo correponden 9 dias a diciembre de 2021 --
order by 2 asc
)
select
        avg(total_mes) as promedio_mensual
from ventas_mensuales;



-- 2.Cuantas ventas por mes --

select 
	count(numero_de_factura) as ventas_por_mes,
    month(fecha_de_factura) as mes
from ventass
group by 2
order by 2 asc;





-- 3. Cual es el mes en el que mas venden --

select 
	count(numero_de_factura) as ventas_por_mes,
    month(fecha_de_factura) as mes
from ventass
group by 2
order by 1 desc; -- por cantidad de operacion de venta --

select
		sum(monto) as total_mes,
        month(fecha_de_factura) as mes
from ventass
group by 2 
order by 2 desc; -- por monto --


select
		sum(cantidad) as cantidad_mes,
        month(fecha_de_factura) as mes
from ventass
group by 2 
order by 1 desc; -- por unidades vendidas --




-- 4. Quienes son los clientes mas importantes --

select
		ID_Cliente,
        Pais,
        sum(monto) as monto_total_vendido,
        sum(cantidad) as cantidad_total_vendida     
from ventass
group by id_cliente
order by 4 desc
limit 10; -- los 10 clientes mas importantes



-- 5. Monto promedio que gastan los clientes --

with clientes as
(
select
	id_cliente,
    sum(monto) as monto_gastado
from ventass
group by 1
order by 2 desc
)
select
		count(id_cliente) as cantidad_clientes,
        sum(monto_gastado) as total_vendido,
        avg(monto_gastado) as promedio_gastado_por_cliente
from clientes;




-- 6. Que porcentaje de sus clientes le volvieron a comprar --

with clientes_con_mas_de_una_compra as
(
select 
		id_cliente as cliente,
        count(Numero_de_factura) as cantidad_ventas
from ventass
group by 1
having cantidad_ventas > 1
order by 2 desc
)
select
		count(distinct cliente) as clientes_mas_de_una_compra,
        (select count(distinct id_cliente) from ventass) as clientes_totales,
        count(distinct cliente) / (select count(distinct id_cliente) from ventass) as porcentaje_clientes
from clientes_con_mas_de_una_compra;



-- 7. Como se desglosa esta infrmacion segun los paises a los que les venden --

-- los 10 paises a los que mas venden --

select
		pais,
		sum(monto) as monto_total,
        sum(cantidad) as cantidad_total
from ventass
group by 1
order by 2 desc
limit 10;

-- cliente mas importante por pais --
-- seleciones los 5 clientes mas importantes dentro de los 5 paises a los que mas la venden --

(select
		id_cliente,
        sum(monto) as monto_vendido,
        pais
from ventass
where pais="United Kingdom"
group by 1
order by 2 desc
limit 10)
union 
(select
		id_cliente,
        sum(monto) as monto_vendido,
        pais
from ventass
where pais="Netherlands"
group by 1
order by 2 desc
limit 5)

union

(select
		id_cliente,
        sum(monto) as monto_vendido,
        pais
from ventass
where pais="EIRE"
group by 1
order by 2 desc
limit 5)

union

(select
		id_cliente,
        sum(monto) as monto_vendido,
        pais
from ventass
where pais="Germany"
group by 1
order by 2 desc
limit 5)

union

(select
		id_cliente,
        sum(monto) as monto_vendido,
        pais
from ventass
where pais="France"
group by 1
order by 2 desc
limit 5);