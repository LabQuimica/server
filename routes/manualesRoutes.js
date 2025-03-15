import express from 'express';
import fetch from 'node-fetch';
import dotenv from "dotenv";

dotenv.config();

const manualRoutes = express.Router();

const DRIVE_API_KEY = process.env.DRIVE_API_KEY;

const FOLDER_ID = "1rGhTFyjo4j3UrAMUITE11lX7aHtRS76V"; // ID de la carpeta de Google Drive

manualRoutes.get("/drive-files", async (req, res) => {
  try {
    const response = await fetch(
      `https://www.googleapis.com/drive/v3/files?q='${FOLDER_ID}'+in+parents&key=${DRIVE_API_KEY}&fields=files(id,name,mimeType,webViewLink)`
    );
    const data = await response.json();
    res.json(data.files || []);
  } catch (error) {
    console.error("Error obteniendo archivos de Google Drive:", error);
    res.status(500).json({ error: "Error obteniendo archivos" });
  }
});

export default manualRoutes;