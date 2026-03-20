describe("App Flow", () => {
  it("loads and displays backend data", () => {
    cy.visit("http://localhost:5173");

    // Check header and hero
    cy.contains("ShopSmart");
    cy.contains("Discover Incredible Deals");
    
    // Check backend health status text
    cy.contains("ok", { timeout: 10000 });
  });
});
