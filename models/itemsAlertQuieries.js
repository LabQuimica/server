
export const infoItems = `
SELECT 
    items.nombre, 
    items.cantidad,
    items.tipo
FROM 
    items 
WHERE 
    tipo 
IN
    ('reactivos');

`;
