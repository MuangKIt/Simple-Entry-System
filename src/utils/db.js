const fs = require('fs');
const path = require('path');

const MASTER_PATH = path.join(__dirname, '..', '..', 'data', 'master.json');
const TRANSACTIONS_PATH = path.join(__dirname, '..', '..', 'data', 'transactions.json');
const DB_PATH = path.join(__dirname, '..', '..', 'data', 'data.json');

// 1. อ่านข้อมูล Master Data (Users, Products, Settings)
const readMasterData = () => {
    try {
        if (fs.existsSync(MASTER_PATH)) {
            const raw = fs.readFileSync(MASTER_PATH, 'utf-8');
            return JSON.parse(raw);
        }
        if (fs.existsSync(DB_PATH)) {
            const raw = fs.readFileSync(DB_PATH, 'utf-8');
            const data = JSON.parse(raw);
            return {
                users: data.users || [],
                products: data.products || [],
                settings: data.settings || {}
            };
        }
        return { users: [], products: [], settings: {} };
    } catch (err) {
        console.error('Error reading master database file:', err);
        return { users: [], products: [], settings: {} };
    }
};

// 2. อ่านข้อมูล Transactions (ประวัติการรับเข้า-จ่ายออก)
const readTransactions = () => {
    try {
        if (fs.existsSync(TRANSACTIONS_PATH)) {
            const raw = fs.readFileSync(TRANSACTIONS_PATH, 'utf-8');
            return JSON.parse(raw);
        }
        if (fs.existsSync(DB_PATH)) {
            const raw = fs.readFileSync(DB_PATH, 'utf-8');
            const data = JSON.parse(raw);
            return data.transactions || [];
        }
        return [];
    } catch (err) {
        console.error('Error reading transactions database file:', err);
        return [];
    }
};

// 3. รวมข้อมูลทั้งระบบสำหรับความเข้ากันได้แบบย้อนหลัง (Backward Compatibility)
const readData = () => {
    const master = readMasterData();
    const transactions = readTransactions();
    return {
        ...master,
        transactions
    };
};

// 4. บันทึกข้อมูล Master Data
const writeMasterData = (masterData) => {
    try {
        fs.writeFileSync(MASTER_PATH, JSON.stringify(masterData, null, 2), 'utf-8');
        return true;
    } catch (err) {
        console.error('Error writing to master database file:', err);
        return false;
    }
};

// 5. บันทึกข้อมูล Transactions
const writeTransactions = (transactions) => {
    try {
        fs.writeFileSync(TRANSACTIONS_PATH, JSON.stringify(transactions, null, 2), 'utf-8');
        return true;
    } catch (err) {
        console.error('Error writing to transactions database file:', err);
        return false;
    }
};

// 6. บันทึกข้อมูลแบบแยกไฟล์อัตโนมัติ
const writeData = (data) => {
    try {
        const { transactions, ...master } = data;
        let success = true;

        if (transactions !== undefined) {
            success = writeTransactions(transactions) && success;
        }
        success = writeMasterData(master) && success;

        // อัปเดต data.json เป็นสำรอง (Mirror Backup)
        try {
            fs.writeFileSync(DB_PATH, JSON.stringify({ ...master, transactions: transactions || [] }, null, 2), 'utf-8');
        } catch (_) {}

        return success;
    } catch (err) {
        console.error('Error writing to database files:', err);
        return false;
    }
};

module.exports = {
    readData,
    writeData,
    readMasterData,
    writeMasterData,
    readTransactions,
    writeTransactions,
    MASTER_PATH,
    TRANSACTIONS_PATH,
    DB_PATH
};
