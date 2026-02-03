import express from "express";
import Hub from "../models/Hub.js";
import auth from "../middleware/auth.js";

const router = express.Router();

// CREATE HUB
router.post("/", auth, async (req, res) => {
  try {
    const { title, bio } = req.body;

    // Generate simple username slug
    const safeTitle = (title || 'hub').toLowerCase().replace(/[^a-z0-9]/g, '-');
    const username = `${safeTitle}-${Date.now().toString(36)}`;

    const hub = await Hub.create({
      user: req.user.id,
      title: title || 'Untitled Hub',
      bio: bio || '',
      username
    });
    res.json({ message: "Hub created", hub });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// GET USER HUBS
router.get("/", auth, async (req, res) => {
  const hubs = await Hub.find({ user: req.user.id });
  res.json(hubs);
});

// UPDATE HUB
router.put("/:id", auth, async (req, res) => {
  try {
    const hub = await Hub.findOneAndUpdate(
      { _id: req.params.id, user: req.user.id },
      { $set: req.body },
      { new: true }
    );
    if (!hub) return res.status(404).json({ message: "Hub not found" });
    res.json(hub);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// PUBLIC HUB PAGE
router.get("/public/:username", async (req, res) => {
  const hub = await Hub.findOne({ username: req.params.username });
  if (!hub) return res.status(404).json({ message: "Hub not found" });

  hub.views++;
  await hub.save();

  res.json(hub);
});

// LINK CLICK TRACK
router.post("/:hubId/link/:linkId/click", async (req, res) => {
  const { hubId, linkId } = req.params;

  const hub = await Hub.findById(hubId);
  if (!hub) return res.status(404).json({ message: "Hub not found" });

  const link = hub.links.id(linkId);
  if (!link) return res.status(404).json({ message: "Link not found" });

  link.clicks += 1;
  await hub.save();

  res.json({ message: "Click recorded" });
});

export default router;
