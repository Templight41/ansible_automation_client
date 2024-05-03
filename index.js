const ip = require("ip").address();
const fs = require("fs/promises");
const { v4: uuidv4 } = require("uuid");
const axios = require("axios");
require("dotenv").config();

async function pushIP() {
    const id = await getId();

    axios.post(`${process.env.SERVER_URL}/api/inventory`, {
        address: ip,
        id
    })
}
pushIP()

async function getId() {
    try {
        let res = await fs.readFile("uuid.json", "utf-8");
        res = JSON.parse(res);
        return res.id;
    }
    catch (err) {
        const id = uuidv4();
        fs.writeFile("uuid.json", JSON.stringify({ id }));
        return id;
    }

}