import express from 'express';
import fetch from 'node-fetch';

const manualRoutes = express.Router();

const API_KEY = "AIzaSyBPwojlt4qo7_R6jZzcXAXUX02LT2TCEC8";
const FOLDER_ID = "1rGhTFyjo4j3UrAMUITE11lX7aHtRS76V";

// Endpoint para obtener archivos de Google Drive
manualRoutes.get("/drive-files", async (req, res) => {
  try {
    const response = await fetch(
      `https://www.googleapis.com/drive/v3/files?q='${FOLDER_ID}'+in+parents&key=${API_KEY}&fields=files(id,name,mimeType,webViewLink)`
    );
    const data = await response.json();
    res.json(data.files || []);
  } catch (error) {
    console.error("Error obteniendo archivos de Google Drive:", error);
    res.status(500).json({ error: "Error obteniendo archivos" });
  }
});

export default manualRoutes;