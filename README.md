AI-powered plant intelligence, health analysis, 3D reconstruction, and AR visualization platform.

FloraLens AI transforms a smartphone camera into an intelligent plant scanner. Users can capture a plant, identify its species, analyze its health, measure its structure, monitor growth over time, and visualize it as an interactive 3D model or in augmented reality.

✨ Features
🌱 Plant Identification — Recognize plant species using computer vision and AI.
🔬 Health Analysis — Analyze leaves for potential disease, discoloration, and visible stress.
📏 Plant Measurement — Estimate plant height, canopy size, and leaf characteristics.
🧊 3D Reconstruction — Create an interactive 3D representation of a scanned plant.
🥽 AR Visualization — Place and inspect plants in the real environment.
📈 Growth Tracking — Compare scans over time to monitor plant development.
🤖 AI Insights — Generate plant descriptions, observations, and care recommendations.
📸 Scan History — Maintain a timeline of previously scanned plants.
📦 3D Export — Export supported models for external 3D applications.
🏗️ Architecture
                    FloraLens AI
                         │
             ┌───────────┴───────────┐
             │                       │
        iOS Application          AI Backend
             │                       │
      ┌──────┼───────┐          ┌────┴─────┐
      │      │       │          │          │
   Vision  ARKit  RealityKit  ML Models  LLM
      │      │       │          │          │
      └──────┴───────┘          └────┬─────┘
             │                       │
             └───────────┬───────────┘
                         │
                    Plant Profile
                         │
              ┌──────────┼──────────┐
              │          │          │
           Health      Growth       3D/AR
           Analysis   Tracking   Visualization
🛠️ Technology Stack
iOS
Swift
SwiftUI
ARKit
RealityKit
Vision
Core ML
Core Image
Metal
Model I/O
USDZ
Swift Concurrency
Backend
Python
FastAPI
PostgreSQL
Object Storage
REST APIs
AI/ML
Computer Vision
Plant Classification
Leaf/Disease Detection
Image Analysis
LLM-powered plant insights
📱 Application Flow
Open App
   ↓
Start Plant Scan
   ↓
Capture Plant
   ↓
AI Identification
   ↓
Health Analysis
   ↓
Measurements
   ↓
Create Plant Profile
   ↓
3D Reconstruction
   ↓
AR Visualization
   ↓
Track Growth
🌱 Plant Profile

Each scanned plant can maintain a digital profile:

Species
 ├── Common Name
 ├── Scientific Name
 └── Confidence Score


Health
 ├── Overall Health
 ├── Leaf Condition
 └── Potential Issues


Measurements
 ├── Height
 ├── Canopy Width
 └── Leaf Count


Growth
 ├── Previous Scans
 ├── Growth Rate
 └── Timeline


AI Insights
 ├── Plant Description
 ├── Observations
 └── Care Recommendations
🔮 Future Roadmap
 Real-time plant detection
 Advanced 3D reconstruction
 Improved disease classification
 Plant-to-plant comparison
 Growth prediction
 Garden mapping
 Multi-plant AR scenes
 Offline Core ML inference
 AI-powered plant recommendations
 Cloud synchronization
 Plant health analytics dashboard
🎯 Potential Use Cases

Home Gardening
Identify plants and monitor their health and growth.

Nurseries
Create digital plant catalogs with 3D/AR experiences.

Agriculture
Support visual crop monitoring and early detection of plant stress.

Landscaping
Build digital inventories and preview plants in outdoor environments.

E-commerce
Allow customers to visualize plants in their homes before purchasing.

🔐 Privacy

FloraLens AI is designed with a privacy-first approach. Where possible, image processing and ML inference can be performed directly on the device, reducing the need to upload personal camera data to the cloud.

📄 License

This project is intended as an open-source research and portfolio project. Add your preferred license before publishing.

FloraLens AI — See. Understand. Grow.
