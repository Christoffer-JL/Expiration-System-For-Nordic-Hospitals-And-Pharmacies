const chai = require("chai");
const chaiHttp = require("chai-http");
const app = require("./ServerApp.js"); // Assuming your Express app is in a file named 'app.js'

chai.use(chaiHttp);
const expect = chai.expect;

describe("API Endpoints", () => {
  // You may need to replace these placeholders with actual data for your tests
  const departmentId = 1;
  const productCode = 101;
  const batchNumber = "ABC123";
  const productName = "Test Product";
  const expirationDate = "2023-12-31";

  it("should get department name with DepartmentId", (done) => {
    chai
      .request(app)
      .get(`/department?DepartmentId=${departmentId}`)
      .end((err, res) => {
        expect(res).to.have.status(200);
        expect(res.body).to.be.an("array"); // Adjust based on the response type
        // Add more specific assertions based on your expected response
        done();
      });
  });

  it("should get entries with filters", (done) => {
    chai
      .request(app)
      .get(
        `/entries?DepartmentName=Example&BatchNr=123&ProductCode=456&ProductName=Test`
      )
      .end((err, res) => {
        expect(res).to.have.status(200);
        expect(res.body).to.be.an("array"); // Adjust based on the response type
        // Add more specific assertions based on your expected response
        done();
      });
  });

  it("should get expiration entries", (done) => {
    chai
      .request(app)
      .get("/expiration-entries")
      .end((err, res) => {
        expect(res).to.have.status(200);
        expect(res.body).to.be.an("array"); // Adjust based on the response type
        // Add more specific assertions based on your expected response
        done();
      });
  });

  it("should get ProductName and ProductNumber with ProductCode", (done) => {
    chai
      .request(app)
      .get(`/entry?ProductCode=${productCode}`)
      .end((err, res) => {
        expect(res).to.have.status(200);
        expect(res.body).to.be.an("array"); // Adjust based on the response type
        // Add more specific assertions based on your expected response
        done();
      });
  });

  it("should remove an entry from a single specified department", (done) => {
    chai
      .request(app)
      .post("/remove-entry-from-single-department")
      .send({
        ProductCode: productCode,
        BatchNumber: batchNumber,
        DepartmentName: "Example",
      })
      .end((err, res) => {
        expect(res).to.have.status(200);
        // Add more specific assertions based on your expected response
        done();
      });
  });

  it("should remove an entry from all departments", (done) => {
    chai
      .request(app)
      .post("/remove-entry-from-all-departments")
      .send({ ProductCode: productCode, BatchNumber: batchNumber })
      .end((err, res) => {
        expect(res).to.have.status(200);
        // Add more specific assertions based on your expected response
        done();
      });
  });

  it("should add an entry to the database", (done) => {
    chai
      .request(app)
      .post("/add-entry")
      .send({
        ProductCode: productCode,
        BatchNumber: batchNumber,
        ExpirationDate: expirationDate,
        ProductName: productName,
      })
      .end((err, res) => {
        expect(res).to.have.status(200);
        // Add more specific assertions based on your expected response
        done();
      });
  });

  it("should add a new ProductNumber mapped to unique ProductName", (done) => {
    chai
      .request(app)
      .post("/add-new-entry-type")
      .send({ ProductCode: productCode, ProductName: productName })
      .end((err, res) => {
        expect(res).to.have.status(200);
        // Add more specific assertions based on your expected response
        done();
      });
  });
});
