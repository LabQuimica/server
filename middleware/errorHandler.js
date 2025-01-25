// middleware/errorHandler.js
export const errorHandler = (err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Something broke!' });
};

export default errorHandler;