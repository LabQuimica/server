
export const infoItems = `
SELECT 
    items.id_item, 
    items.nombre, 
    items.cantidad, 
    marcas.nombre 
AS 
    marca 
FROM 
    items 
JOIN 
    marcas 
ON 
    items.fk_marca_item = marcas.id_marca 
WHERE 
    tipo 
IN
    ('solidos', 'liquidos', 'materiales');

`;
