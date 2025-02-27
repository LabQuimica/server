export const allVales = `
SELECT
    va.id_vale,
    u.name AS alumno,
    g.nombre,
    g.semestre,
    va.status AS estado_vale,
    va.observaciones AS observaciones_vale,
    DATE_FORMAT(va.fecha_solicitada, '%d/%m/%Y %H:%i') AS fecha_solicitada,
    DATE_FORMAT(va.fecha_modificacion, '%d/%m/%Y %H:%i') AS fecha_modificacion,
    u2.name AS profesor,
    pa.status AS estado_practica
FROM
    vale_alumno va
JOIN
    practicas_asignadas pa on va.fk_pa_vale = pa.id_pa
JOIN
    grupo g on pa.fk_grupo_pa = g.id_grupo
JOIN
    users u on va.fk_alumno_users_vale = u.id_user
JOIN
    practicas p on pa.fk_practicas_pa = p.id_practica
JOIN
    users u2 on p.fk_profesor_users_practica = u2.id_user;
`;

export const vales = `
SELECT
    *
FROM
    vale_alumno
`;
