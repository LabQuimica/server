
export const infoItems = `
SELECT 
    items.nombre, 
    items.cantidad
FROM 
    items 
WHERE 
    tipo 
IN
    ('solidos', 'liquidos', 'materiales');

`;
