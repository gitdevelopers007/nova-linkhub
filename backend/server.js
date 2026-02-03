import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";

// ROUTES
import authRoutes from "./routes/auth.js";
import hubRoutes from "./routes/hubs.js";

dotenv.config();

const app = express();

/* =====================
   MIDDLEWARE
===================== */
app.use(cors());
app.use(express.json());

/* =====================
   ROUTES
===================== */
app.use("/api/auth", authRoutes);
app.use("/api/hubs", hubRoutes);

/* =====================
   DEFAULT ROUTE
===================== */
app.get("/", (req, res) => {
   res.send("🚀 NOVA Backend API is running");
});

/* =====================
   DATABASE
===================== */
mongoose
   .connect(process.env.MONGO_URI)
   .then(async () => {
      console.log("✅ MongoDB Connected");
      try {
         await mongoose.connection.collection('hubs').dropIndex('publicSlug_1');
         console.log("🗑️ Dropped legacy index: publicSlug_1");
      } catch (e) {
         // Index might not exist, ignore
      }
   })
   .catch((err) => {
      console.error("❌ MongoDB Error:", err.message);
      process.exit(1);
   });

/* =====================
   SERVER
===================== */
const PORT = process.env.PORT || 5005;

app.listen(PORT, () => {
   console.log(`🚀 NOVA backend running on ${PORT}`);
});
