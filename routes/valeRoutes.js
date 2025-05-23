import express from "express";
import {
  getValeStatus,
  updateValeWithStatusAndComment,
  updateValeWithStatus,
  updateValeWithComment,
  queryValeAlumnoDetails,
  getValeProfesorStatus,
  getValeProfesorDetails,
  queryGetAllValesAlumno,
  queryGetAllValesProfesor,
} from "../querys/valeQuerys.js";

const valeRouter = express.Router();

valeRouter.get("/", (req, res) => {
  res.send("GET request to the homepage");
});

valeRouter.post("/updateVales", async (req, res) => {
  const data = req.body;
  try {
    const responses = [];
    for (const change of data) {
      if (change.newStatus && change.newObservation) {
        // Caso 1: Actualización de estado y comentario
        const response = await updateValeWithStatusAndComment(
          change.id_vale,
          change.newStatus,
          change.newObservation
        );
        responses.push(response);
      } else if (change.newStatus) {
        // Caso 2: Actualización solo de estado
        const response = await updateValeWithStatus(
          change.id_vale,
          change.newStatus
        );
        responses.push(response);
      } else if (change.newObservation) {
        // Caso 3: Actualización solo de comentario
        const response = await updateValeWithComment(
          change.id_vale,
          change.newObservation
        );
        responses.push(response);
      }
    }

    res.status(200).json({
      message: "Vales actualizados correctamente",
      responses,
    });
  } catch (error) {
    console.error("Error en /updateVales:", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
});

valeRouter.get("/getAlumnoValeStatus", async (req, res) => {
  const { estado } = req.query;
  if (
    ![
      "pendiente",
      "progreso",
      "completada",
      "cancelada",
      "incompleto",
    ].includes(estado)
  ) {
    return res.status(400).json({ error: "Estado no válido" });
  }

  try {
    const vales = await getValeStatus(estado);
    res.json(vales);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Error al obtener los vales" });
  }
});

valeRouter.get("/getValeAlumnoDetails", async (req, res) => {
  const { id_vale } = req.query;
  if (!id_vale) {
    return res.status(400).json({ error: "Falta el id del vale" });
  }
  try {
    const vales = await queryValeAlumnoDetails(id_vale);
    res.json(vales);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Error al obtener los detalles del vale" });
  }
});

valeRouter.get("/getProfesorValeStatus", async (req, res) => {
  const { estado } = req.query;
  if (!["pendiente", "progreso", "completada", "cancelada"].includes(estado)) {
    return res.status(400).json({ error: "Estado no válido" });
  }

  try {
    const vales = await getValeProfesorStatus(estado);
    res.json(vales);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Error al obtener los vales" });
  }
});

valeRouter.get("/getValeProfesorDetails", async (req, res) => {
  const { id_practica_asignada } = req.query;
  if (!id_practica_asignada) {
    return res.status(400).json({ error: "Falta el id del vale" });
  }
  try {
    const profeDetails = await getValeProfesorDetails(id_practica_asignada);
    res.json(profeDetails);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Error al obtener los detalles del vale" });
  }
});

valeRouter.get("/getAllValesAlumno", async (req, res) => {
  const { fk_alumno_users_vale } = req.query;
  if (!fk_alumno_users_vale) {
    return res.status(400).json({ error: "Falta el id del alumno" });
  }
  try {
    const alumnoAllVales = await queryGetAllValesAlumno(fk_alumno_users_vale);
    res.json(alumnoAllVales);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Error al obtener los detalles del vale" });
  }
});

valeRouter.get("/getAllValesProfesor", async (req, res) => {
  const { id_users_vale } = req.query;
  if (!id_users_vale) {
    return res.status(400).json({ error: "Falta el id del usuario" });
  }
  try {
    const profesorAllVales = await queryGetAllValesProfesor(id_users_vale);
    res.json(profesorAllVales);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Error al obtener los detalles del vale" });
  }
});

export default valeRouter;
