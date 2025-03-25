import express from 'express';
import multer from 'multer';
import { google } from 'googleapis';
import fs from 'fs';
import stream from 'stream';
import dotenv from 'dotenv';

dotenv.config();

const manualRoutes = express.Router();
const FOLDER_ID = "1rGhTFyjo4j3UrAMUITE11lX7aHtRS76V"; // ID de la carpeta de Google Drive

// almacenar archivos temporalmente
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// me falta pasarle esto a los demas --------------------------------
const oauth2Client = new google.auth.OAuth2(
  process.env.DRIVE_CLIENT_ID,
  process.env.DRIVE_CLIENT_SECRET,
  process.env.DRIVE_REDIRECT_URI
);

oauth2Client.setCredentials({
  refresh_token: process.env.DRIVE_REFRESH_TOKEN
});

const drive = google.drive({
  version: 'v3',
  auth: oauth2Client
});

// obtener archivos
manualRoutes.get("/drive-files", async (req, res) => {
  try {
    const folderId = req.query.folderId || FOLDER_ID;
    const response = await fetch(
      `https://www.googleapis.com/drive/v3/files?q='${folderId}'+in+parents&key=${process.env.DRIVE_API_KEY}&fields=files(id,name,mimeType,webViewLink)`
    );
    const data = await response.json();
    res.json(data.files || []);
  } catch (error) {
    console.error("Error obteniendo archivos de Google Drive:", error);
    res.status(500).json({ error: "Error obteniendo archivos" });
  }
});

// subir archivos
manualRoutes.post("/upload-to-drive", upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "No se ha enviado ningún archivo" });
    }

    const folderId = req.body.folderId || FOLDER_ID;
    const bufferStream = new stream.PassThrough();
    bufferStream.end(req.file.buffer);

    const response = await drive.files.create({
      requestBody: {
        name: req.file.originalname,
        mimeType: req.file.mimetype,
        parents: [folderId]
      },
      media: {
        mimeType: req.file.mimetype,
        body: bufferStream
      }
    });

    res.json(response.data);
  } catch (error) {
    console.error("Error subiendo archivo a Google Drive:", error);
    res.status(500).json({ error: "Error al subir el archivo" });
  }
});

// eliminar archivos
manualRoutes.post("/delete-from-drive", async (req, res) => {
  try {
    const { fileIds } = req.body;
    
    if (!fileIds || !Array.isArray(fileIds) || fileIds.length === 0) {
      return res.status(400).json({ error: "No se han proporcionado IDs de archivos válidos" });
    }

    const results = await Promise.allSettled(
      fileIds.map(async (fileId) => {
        return drive.files.delete({
          fileId: fileId
        });
      })
    );
    
    // exito y error en los archivo selecionados
    const successful = results.filter(result => result.status === 'fulfilled').length;
    const failed = results.filter(result => result.status === 'rejected').length;
    
    res.json({
      message: `${successful} archivos eliminados con éxito${failed > 0 ? `, ${failed} fallaron` : ''}`,
      successful,
      failed
    });
    
  } catch (error) {
    console.error("Error al eliminar archivos de Google Drive:", error);
    res.status(500).json({ error: "Error al eliminar archivos" });
  }
});

export default manualRoutes;