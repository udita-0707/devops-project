const request = require("supertest");
const app = require("../index");

test("GET / should return API running", async () => {
    const res = await request(app).get("/");
    expect(res.statusCode).toBe(200);
    expect(res.body.message).toBe("API running");
});

test("GET /api/data should return data", async () => {
    const res = await request(app).get("/api/data");
    expect(res.statusCode).toBe(200);
    expect(res.body.data).toBe("Hello from backend");
});