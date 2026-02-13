Feature Switch System

A database-backed Feature Flag System built with Ruby on Rails.

This system allows you to enable or disable features at runtime without deploying new code.
It supports global defaults, user-specific overrides, group-based overrides, and region-based overrides.

📌 What Problem This Solves

1. Safely roll out new features
2. Enable features for specific users or groups
3. Perform gradual rollouts by region
4. Disable features instantly without deployment
5. Support A/B testing scenarios

🏗 System Architecture

1. Models
2. Feature
3. FeatureOverride
4. User
5. Group
6. Feature Evaluation Order

When checking if a feature is enabled, the system follows this priority:

1. User-specific override
2. Group-specific override
3. Region-specific override
4. Global feature default

⚙️ Requirements
1. Ruby 3.3+
2. Rails 8.1+
3. PostgreSQL

🛠 Installation

Clone the repository:

git clone <your_repository_url>
cd Feature-Switch-System

1. Install dependencies:
2. bundle install
3. Setup database:
4. rails db:create
5. rails db:migrate
6. rails db:seed # optional


Start the server:
rails server

Application runs at:

http://localhost:3000

🧪 Running Tests
bundle exec rspec

Tests include:
API endpoints
Feature evaluation logic
Override logic
Error handling

🌐 API Documentation

Base URL:

http://localhost:3000/api/feature_flags

1️⃣ List All Features
Endpoint
GET /api/feature_flags

cURL
curl -X GET http://localhost:3000/api/feature_flags

2️⃣ Create Feature
Endpoint
POST /api/feature_flags

cURL
curl -X POST http://localhost:3000/api/feature_flags \
  -H "Content-Type: application/json" \
  -d '{
    "feature": {
      "name": "chat_feature",
      "enabled": false,
      "description": "Chat system feature"
    }
  }'

3️⃣ Update Feature
Endpoint
PATCH /api/feature_flags/:id

Example (id = 1)
curl -X PATCH http://localhost:3000/api/feature_flags/1 \
  -H "Content-Type: application/json" \
  -d '{
    "feature": {
      "enabled": true
    }
  }'

4️⃣ Evaluate Feature
Endpoint
GET /api/feature_flags/:id/evaluate

Example
curl -X GET "http://localhost:3000/api/feature_flags/1/evaluate?region=US"

Example Response
{
  "feature": "chat_feature",
  "enabled": true
}

🔁 Feature Overrides API

Overrides are nested under a feature:

/api/feature_flags/:feature_flag_id/overrides

5️⃣ Create Override
Endpoint
POST /api/feature_flags/:feature_flag_id/overrides

User Override
curl -X POST http://localhost:3000/api/feature_flags/1/overrides \
  -H "Content-Type: application/json" \
  -d '{
    "override": {
      "enabled": true,
      "user_id": 1
    }
  }'

Group Override
curl -X POST http://localhost:3000/api/feature_flags/1/overrides \
  -H "Content-Type: application/json" \
  -d '{
    "override": {
      "enabled": true,
      "group_id": 1
    }
  }'

Region Override
curl -X POST http://localhost:3000/api/feature_flags/1/overrides \
  -H "Content-Type: application/json" \
  -d '{
    "override": {
      "enabled": true,
      "region": "US"
    }
  }'

6️⃣ Update Override
Endpoint
PATCH /api/feature_flags/:feature_flag_id/overrides/:id

Example
curl -X PATCH http://localhost:3000/api/feature_flags/1/overrides/2 \
  -H "Content-Type: application/json" \
  -d '{
    "override": {
      "enabled": false
    }
  }'

7️⃣ Delete Override
Endpoint
DELETE /api/feature_flags/:feature_flag_id/overrides/:id

Example
curl -X DELETE http://localhost:3000/api/feature_flags/1/overrides/2

🧠 Rails Console Usage

Check feature status:

user = User.first
FeatureFlagEngine.enabled?("chat_feature", user, region: "US")


Create user override:

feature = Feature.find_by(name: "chat_feature")
FeatureOverride.create!(
  feature: feature,
  user_id: user.id,
  enabled: true
)


Clear cache (if caching enabled):

FeatureFlagEngine.clear_cache!

🗄 Database Schema Overview
Features

1. name (string)
2. enabled (boolean)
3. description (text)
4. Feature Overrides
5. feature_id (foreign key)
6. enabled (boolean)
7. user_id (optional)
8. group_id (optional)
9. region (optional)
10. Project Improvements

While the current implementation is functional and production-ready for small to medium-scale applications, the following enhancements can further improve scalability, reliability, and maintainability:

Performance Optimization
Introduce Redis-based caching with proper cache invalidation to reduce database load during feature evaluation.

Database Enhancements
Add composite indexes and uniqueness constraints on overrides (feature + user/group/region) to improve lookup speed and prevent duplicate records.

Authentication & Authorization
Implement JWT-based authentication and role-based access control to restrict feature management to authorized users.

API Versioning
Introduce versioned APIs (e.g., /api/v1/) to ensure backward compatibility for future updates.

Scheduled & Percentage Rollouts
Support time-based activation (starts_at, ends_at) and percentage-based rollouts for gradual feature releases.

Monitoring & Logging
Add structured logging, audit trails, and monitoring integration (e.g., error tracking and metrics) for production observability.

Admin Dashboard (UI)
Develop a web interface to manage features, overrides, and view evaluation logs without direct database access.

✅ Best Practices

Always create the feature first
Ensure users/groups exist before creating overrides
Use region overrides carefully
Clear cache after changing overrides (if caching enabled)
Keep feature names unique