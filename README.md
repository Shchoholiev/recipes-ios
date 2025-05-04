# recipes-ios
Mobile app for browsing and searching recipes. The app retrieves data from a Web API and displays categories and recipes using Swift and Storyboards.

## Table of Contents
- [Features](#features)
- [Stack](#stack)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Setup Instructions](#setup-instructions)
- [Configuration](#configuration)

## Features
- Browse and search recipe categories
- Fetch and display recipes by category
- View detailed recipe information
- Pagination support for large recipe lists
- Tab‐based navigation across app sections
- Custom UITableViewCells with XIBs for categories and recipes

## Stack
- Swift 5
- UIKit
- Storyboards & XIBs
- URLSession for networking
- MVC architectural pattern
- Xcode 12+

## Installation

### Prerequisites
- macOS with Xcode 12 or later
- Swift 5.3 or later
- Internet connection to access the recipes API

### Setup Instructions
```bash
# Clone the repository
git clone https://github.com/Shchoholiev/recipes-ios.git

# Navigate into the project directory
cd recipes-ios/Recipes

# Open the Xcode project
open Recipes.xcodeproj
```
Select a simulator or device in Xcode, then build and run (⌘R).

## Configuration
If the API endpoint differs from the default, update the base URL in `ServiceBase.swift`:
```swift
baseUrl = "https://api.example.com"
```
