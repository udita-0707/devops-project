describe("App Flow", () => {
  it("loads and displays backend data", () => {
    cy.visit("http://localhost:5173");

    cy.contains("DevOps Project");
    cy.contains("Hello from backend");
  });
});
