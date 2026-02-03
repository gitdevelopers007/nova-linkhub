import mongoose from "mongoose";

const ruleSchema = new mongoose.Schema({
  type: { type: String, enum: ['time', 'device'] },
  startTime: String,
  endTime: String,
  device: { type: String, enum: ['mobile', 'desktop'] }
});

const linkSchema = new mongoose.Schema({
  label: String,
  url: String,
  clicks: { type: Number, default: 0 },
  rules: [ruleSchema]
});

const hubSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    title: String,
    username: { type: String, unique: true },
    bio: String,
    links: [linkSchema],
    views: { type: Number, default: 0 }
  },
  { timestamps: true }
);

export default mongoose.model("Hub", hubSchema);
