export const allVales = `
SELECT
    va.id_vale,
    u.name AS alumno,
    g.grupo,
    g.semestre,
    va.status AS estado_vale,
    va.observaciones AS observaciones_vale,
    va.fecha_solicitada,
    va.fecha_modificacion,
    up.name AS profesor,
    pa.status AS estado_practica
FROM
    grupo g
JOIN
    practicas_asignadas pa ON g.id_grupo = pa.fk_grupo_pa
JOIN
    vale_alumno va ON pa.id_pa = va.fk_pa_vale
JOIN
    users u ON va.fk_alumno_users_vale = u.id_user
JOIN
    users up ON pa.fk_profesor_users_pa = up.id_user
`;

export const vales = `
SELECT
    *
FROM
    vale_alumno
`;
