---
name: Game & Mobile Development
version: 1.0.0
description: Complete game development (Unity/Unreal) and mobile app development (Flutter/Expo)
author: shuakipiebot
tags: [game-dev, unity, unreal, mobile, flutter, expo, react-native]
---

# 🎮 Game & Mobile Development - Build Apps & Games

## Overview
Master game development with Unity/Unreal Engine and mobile app development with Flutter/Expo.

## Capabilities

### 1. Game Development (Unity)
- 2D/3D game creation
- Physics & collisions
- Character controllers
- AI & pathfinding
- Particle systems
- Audio integration
- Monetization (ads, IAP)

### 2. Game Development (Unreal Engine)
- Photorealistic graphics
- Blueprint visual scripting
- C++ programming
- Multiplayer networking
- VR/AR development
- Level design

### 3. Mobile Development (Flutter)
- Cross-platform apps (iOS + Android)
- Beautiful UI/UX
- State management
- Firebase integration
- Native features access
- Play Store/App Store deployment

### 4. Mobile Development (Expo/React Native)
- JavaScript/TypeScript apps
- Hot reload development
- Expo SDK features
- Navigation
- Push notifications
- Over-the-air updates

### 5. Game Design
- Game mechanics design
- Level design
- Storytelling
- User retention strategies
- Monetization models
- Player psychology

## Quick Start

### Create Unity Project
```bash
bash ~/.clawdbot/skills/game-mobile-dev-1.0.0/scripts/init_unity_project.sh "ProjectName"
```

### Initialize Flutter App
```bash
bash ~/.clawdbot/skills/game-mobile-dev-1.0.0/scripts/init_flutter_app.sh "AppName"
```

### Create Expo App
```bash
bash ~/.clawdbot/skills/game-mobile-dev-1.0.0/scripts/init_expo_app.sh "AppName"
```

### Generate Game Design Document
```bash
bash ~/.clawdbot/skills/game-mobile-dev-1.0.0/scripts/game_design_doc.sh
```

## Tools We'll Master

### Game Development
- Unity (2D/3D games)
- Unreal Engine (AAA graphics)
- Blender (3D modeling)
- Aseprite (Pixel art)
- GIMP/Photoshop (Graphics)
- Audacity (Sound editing)

### Mobile Development
- Flutter SDK
- Expo CLI
- Android Studio
- Xcode
- VS Code
- Figma (UI design)

### Asset Creation
- Blender - 3D models
- Aseprite - Pixel art
- LMMS - Music creation
- Audacity - Sound effects
- Mixamo - Character animations
- Kenney.nl - Free assets

## Game Development Frameworks

### Unity Game Structure
```
Assets/
├── Scenes/           # Game levels
├── Scripts/          # C# code
│   ├── Controllers/
│   ├── Managers/
│   └── UI/
├── Prefabs/          # Reusable objects
├── Materials/        # Textures & shaders
├── Audio/            # Music & SFX
└── Resources/        # Runtime loaded assets
```

### Unity C# Script Template
```csharp
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    public float moveSpeed = 5f;
    public float jumpForce = 10f;
    
    private Rigidbody2D rb;
    private bool isGrounded;
    
    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }
    
    void Update()
    {
        // Movement
        float moveInput = Input.GetAxis("Horizontal");
        rb.velocity = new Vector2(moveInput * moveSpeed, rb.velocity.y);
        
        // Jump
        if (Input.GetButtonDown("Jump") && isGrounded)
        {
            rb.AddForce(Vector2.up * jumpForce, ForceMode2D.Impulse);
        }
    }
    
    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Ground"))
        {
            isGrounded = true;
        }
    }
}
```

## Mobile App Development

### Flutter App Structure
```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── custom_button.dart
│   └── card_widget.dart
├── models/
│   └── user_model.dart
├── services/
│   ├── api_service.dart
│   └── auth_service.dart
└── utils/
    ├── constants.dart
    └── helpers.dart
```

### Flutter Widget Template
```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Count: $_counter'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Expo/React Native Template
```javascript
import React, { useState } from 'react';
import { View, Text, Button, StyleSheet } from 'react-native';

export default function HomeScreen() {
  const [count, setCount] = useState(0);
  
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Count: {count}</Text>
      <Button
        title="Increment"
        onPress={() => setCount(count + 1)}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 24,
    marginBottom: 20,
  },
});
```

## Game Monetization Strategies

### Free-to-Play (F2P)
1. **In-App Purchases (IAP)**
   - Cosmetic items
   - Power-ups
   - Level unlocks
   - Currency packs

2. **Ad Revenue**
   - Banner ads (low CPM)
   - Interstitial ads (higher CPM)
   - Rewarded videos (best engagement)
   - Offerwall

3. **Battle Pass**
   - Seasonal content
   - Free + Premium tiers
   - FOMO mechanics
   - Recurring revenue

### Premium
- One-time purchase ($0.99 - $9.99)
- No ads, full content
- Better for story-driven games
- Lower reach, higher revenue per user

## Mobile App Monetization

### Revenue Models
1. **Freemium** - Free with premium features
2. **Subscription** - Monthly/yearly fees
3. **Ads** - AdMob, Facebook Ads
4. **Affiliate** - Product recommendations
5. **Premium** - One-time purchase

## Game Design Principles

### Core Gameplay Loop
1. **Action** - Player does something
2. **Reward** - Player gets feedback
3. **Progression** - Player improves
4. **Repeat** - Keep playing

### Engagement Mechanics
- **Achievements** - Goals to complete
- **Leaderboards** - Social competition
- **Daily Rewards** - Return incentive
- **Events** - Limited-time content
- **Social Features** - Play with friends

### Retention Strategies
- Tutorial (first 5 minutes critical!)
- Progression curve (not too easy/hard)
- Daily quests
- Login bonuses
- FOMO events
- Push notifications

## Publishing Guide

### Google Play Store
1. Create developer account ($25 one-time)
2. Prepare assets:
   - App icon (512x512)
   - Screenshots (multiple sizes)
   - Feature graphic (1024x500)
   - Privacy policy
3. App listing optimization (ASO)
4. Build signed APK/AAB
5. Upload & publish

### Apple App Store
1. Create developer account ($99/year)
2. Prepare assets:
   - App icon (1024x1024)
   - Screenshots (per device)
   - App preview videos
   - Privacy policy
3. App listing optimization
4. Build with Xcode
5. Submit for review (1-3 days)

## Learning Path

### Week 1: Unity Basics
- [ ] Install Unity Hub
- [ ] Create first 2D game
- [ ] Learn C# basics
- [ ] Implement player movement
- [ ] Add collisions

### Week 2: Mobile Development Basics
- [ ] Install Flutter/Expo
- [ ] Create "Hello World" app
- [ ] Learn layouts & widgets
- [ ] Add navigation
- [ ] Deploy to phone

### Week 3: Game Mechanics
- [ ] Implement scoring system
- [ ] Add power-ups
- [ ] Create UI menus
- [ ] Integrate audio
- [ ] Add particle effects

### Week 4: Polish & Publish
- [ ] Bug fixing
- [ ] Performance optimization
- [ ] Create app store assets
- [ ] Test on devices
- [ ] Publish first app/game

## Success Metrics

### Game Development
- Publish 1 game per month
- 10,000 downloads in first month
- 4.0+ star rating
- 30% Day 1 retention
- $1,000/month revenue by month 3

### Mobile Apps
- Publish 1 app per month
- 5,000 downloads
- 4.5+ star rating
- 1,000 MAU (Monthly Active Users)
- $500/month revenue

## Trigger Phrases
- "create Unity game"
- "initialize Flutter app"
- "design game mechanics"
- "optimize mobile app performance"
- "publish to app store"
- "generate game design document"

## Next Steps
1. Choose platform (Unity vs Flutter vs Expo)
2. Install development tools
3. Follow a tutorial project
4. Build your first app/game
5. Publish and iterate
