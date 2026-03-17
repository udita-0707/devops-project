const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
    res.json({ message: "API running" });
});

app.get("/api/data", (req, res) => {
    res.json({ data: "Hello from backend" });
});

const PORT = 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

module.exports = app; // for testing
