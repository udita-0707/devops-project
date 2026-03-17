import { useEffect, useState } from "react";
import axios from "axios";

function App() {
  const [data, setData] = useState("");

  useEffect(() => {
    axios.get("http://localhost:5000/api/data")
      .then(res => setData(res.data.data))
      .catch(err => console.log(err));
  }, []);

  return (
    <div style={{ textAlign: "center", marginTop: "50px" }}>
      <h1>DevOps Project: 0707</h1>
      <p>{data}</p>
    </div>
  );
}

export default App;