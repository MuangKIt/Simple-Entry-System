// src/controllers/setting.controller.js
const { readData, writeData, DB_PATH } = require('../utils/db');

const getSettings = (req, res) => {
    const db = readData();
    res.json({ success: true, data: db.settings });
};

const updateSettings = (req, res) => {
    const db = readData();
    db.settings = {
        ...db.settings,
        ...req.body
    };
    writeData(db);
    res.json({ success: true, message: 'บันทึกการตั้งค่าเรียบร้อยแล้ว', data: db.settings });
};

const downloadBackup = (req, res) => {
    res.download(DB_PATH, `backup-data-${new Date().toISOString().slice(0, 10)}.json`);
};

module.exports = {
    getSettings,
    updateSettings,
    downloadBackup
};
