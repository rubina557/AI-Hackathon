const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { GoogleGenerativeAI } = require("@google/generative-ai");
const fs = require("fs");
const path = require("path");

admin.initializeApp();
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "mock-key-for-now");
const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" });

// ------------------------------------------------------------------
// 1. POST /chat
// ------------------------------------------------------------------
exports.chat = functions.https.onRequest(async (req, res) => {
  // CORS setup
  res.set("Access-Control-Allow-Origin", "*");
  if (req.method === "OPTIONS") {
    res.set("Access-Control-Allow-Methods", "POST");
    res.set("Access-Control-Allow-Headers", "Content-Type");
    res.status(204).send("");
    return;
  }

  try {
    const { message, user_id, user_lat, user_lng, is_returning_user } = req.body;
    
    // Simulate Triggering 00_orchestrator
    // We would normally pass this to Gemini to evaluate all workflows
    // and execute them sequentially based on the .md instructions.

    // Mock Response from the full 9-agent pipeline
    res.status(200).json({
      response: "Here is your best match based on your request.",
      booking_id: null,
      provider: {
        id: "prov_001",
        name: "Ali Hassan",
        category: "AC Technician",
        rating: 4.8,
        lat: 25.3960,
        lng: 68.3578,
        badges: ["Top Rated", "Expert Level", "Verified"],
        price: 1850
      },
      pricing: {
        base_fee: 300,
        travel_fee: 100,
        platform_fee: 40,
        total: 1850
      },
      reasoning: "Ali was chosen over closer providers because of his 4.8 rating and expert skill level in inverter AC repair.",
      is_urgent: false,
      artifacts: [
        "intent_log.md",
        "discovery_log.md",
        "ranking_log.md",
        "pricing_log.md",
        "matchmaker_log.md"
      ]
    });
  } catch (error) {
    res.status(200).json({
      error: false,
      response: "We are currently experiencing a system delay. Please try again or provide more details.",
      fallback: true
    });
  }
});

// ------------------------------------------------------------------
// 2. POST /confirm-booking
// ------------------------------------------------------------------
exports.confirmBooking = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  try {
    const { booking_id, selected_slot, provider_id, user_id } = req.body;
    
    res.status(200).json({
      booking_receipt: {
        booking_id: booking_id || "BK-1024",
        status: "confirmed",
        provider_id,
        user_id,
        slot: selected_slot,
        total_pkr: 1850
      },
      payment_url: "https://mock.stripe.sandbox/pay/session_id"
    });
  } catch (error) {
    res.status(200).json({ response: "Failed to confirm booking. Please try another slot." });
  }
});

// ------------------------------------------------------------------
// 3. POST /update-status
// ------------------------------------------------------------------
exports.updateStatus = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  try {
    const { booking_id, new_status, provider_id } = req.body;
    res.status(200).json({ success: true, new_status });
  } catch (error) {
    res.status(200).json({ response: "Error updating status." });
  }
});

// ------------------------------------------------------------------
// 4. POST /submit-review
// ------------------------------------------------------------------
exports.submitReview = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  try {
    const { booking_id, rating, badge_chips, comment } = req.body;
    res.status(200).json({ success: true, message: "Review processed by review agent." });
  } catch (error) {
    res.status(200).json({ response: "Could not submit review at this time." });
  }
});

// ------------------------------------------------------------------
// 5. POST /raise-dispute
// ------------------------------------------------------------------
exports.raiseDispute = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  try {
    const { booking_id, dispute_type, description } = req.body;
    res.status(200).json({ 
      success: true, 
      resolution: "Dispute handled by agent 09", 
      refund_issued: true 
    });
  } catch (error) {
    res.status(200).json({ response: "Please contact support directly." });
  }
});

// ------------------------------------------------------------------
// 6. GET /artifacts
// ------------------------------------------------------------------
exports.artifacts = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  try {
    // We would normally read from the actual logs/ folder generated by Antigravity workflows.
    // Simulating the response
    const mockArtifacts = {
      "intent_log.md": "# Intent Log\n\nParsed from: AC repair needed tomorrow\nConfidence: 0.95",
      "discovery_log.md": "# Discovery Log\n\nFound 5 AC Technicians within 15km.",
      "ranking_log.md": "# Ranking Log\n\n1. Ali Hassan (Score: 92)\n2. Bilal Ahmed (Score: 85)",
      "pricing_log.md": "# Pricing Log\n\nBase: 300\nTravel: 100\nTotal: 400",
      "matchmaker_log.md": "# Matchmaker Log\n\nAli Hassan chosen due to top rating and expert skill.",
      "booking_log.md": "# Booking Log\n\nSlot 2025-05-16 09:00 locked.",
      "followup_log.md": "# Followup Log\n\nScheduled T-1hr reminder.",
      "review_log.md": "# Review Log\n\nUpdated rating to 4.85.",
      "dispute_log.md": "# Dispute Log\n\nNo disputes raised."
    };
    res.status(200).json(mockArtifacts);
  } catch (error) {
    res.status(200).json({ error: "Could not fetch artifacts." });
  }
});

// ------------------------------------------------------------------
// 7. POST /register-provider
// ------------------------------------------------------------------
exports.registerProvider = functions.https.onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  try {
    const { name, phone, cnic_image_base64, password } = req.body;
    res.status(200).json({ success: true, status: "pending", message: "Application under review" });
  } catch (error) {
    res.status(200).json({ response: "Registration failed." });
  }
});
