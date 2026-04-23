# 🎯 Debugging Methodology - Real Examples

**Purpose:** Show concrete examples of the debugging methodology in action

---

## Example 1: Frontend Build Error

### Problem
```
User: "My React app won't build. Getting 'Cannot find module react-router-dom'"
```

### Clawdbot Response (Phase 1: Investigation)
```
Let me help debug this. Running initial investigation...

✅ System check complete
📦 Node v20.10.0, npm 10.2.3
🔍 Checking package.json... react-router-dom is listed
⚠️ Found node_modules but package might be corrupted

This looks like a dependency installation issue.
Confidence: HIGH (seen 15 similar cases, 87% success rate)
```

### Solution Applied
```bash
# Phase 2: Analysis
cd ~/Projects/koopprijs/realwork-frontend-master
npm list react-router-dom  # Shows not installed despite being in package.json

# Phase 3: Solution
# Based on pattern: "Clean reinstall fixes 87% of module not found errors"

# Phase 4: Implementation
rm -rf node_modules package-lock.json
npm install

# Phase 5: Verification
npm run build  # ✅ Success!
npm test       # ✅ All tests pass
```

### Documentation Generated
```markdown
## Fix: Module Not Found - react-router-dom

**Root Cause:** Corrupted node_modules cache
**Solution:** Clean reinstall of dependencies
**Time to Resolve:** 8 minutes
**Success:** ✅

### Commands Used:
- rm -rf node_modules package-lock.json
- npm install
- npm run build

### Prevention:
- Use npm ci in CI/CD (uses package-lock.json strictly)
- Consider using pnpm or yarn for better caching
- Add .gitignore rule for node_modules
```

---

## Example 2: API Endpoint Failing

### Problem
```
User: "API is returning 500 errors on /api/properties endpoint"
Error log: "TypeError: Cannot read property 'map' of undefined"
```

### Clawdbot Response (Phase 1 & 2)
```
🚨 This is a runtime error affecting production API

Running diagnostics...
✅ Server is running
✅ Database is connected
⚠️ Error in properties controller

Stack trace analysis:
File: controllers/properties.js:45
Line: const results = data.properties.map(...)

This looks like a null/undefined data issue.
Likely cause: Database query returning unexpected structure
```

### Investigation Process
```bash
# Phase 2: Root Cause Analysis

# Check database
psql -U user -d koopprijs -c "SELECT COUNT(*) FROM properties;"
# Result: 1250 rows (data exists)

# Check API response structure
curl http://localhost:3001/api/properties | jq '.'
# Response: {"success": true, "data": {...}} 
# BUT: data.properties is undefined!

# Found it! Database query returns 'data.results' not 'data.properties'
```

### Solution Applied
```javascript
// Phase 4: Implementation

// BEFORE (controllers/properties.js:45)
const results = data.properties.map(p => ({
  id: p.id,
  title: p.title
}));

// AFTER (Fixed)
const results = (data.results || []).map(p => ({
  id: p.id,
  title: p.title
}));

// Added null check for safety
```

### Verification
```bash
# Phase 5: Testing

# Unit test added
npm test -- properties.controller.test.js
# ✅ All tests pass

# Integration test
curl http://localhost:3001/api/properties
# ✅ Returns 200 with correct data

# Load test
ab -n 100 -c 10 http://localhost:3001/api/properties
# ✅ All requests successful

# Check production
curl https://api.koopprijs.com/api/properties
# ✅ Working in production
```

### Learning Recorded
```json
{
  "pattern": "undefined_property_access",
  "context": "Database query response structure mismatch",
  "solution": "Add null checks and use optional chaining",
  "prevention": "Add TypeScript for type safety",
  "success_rate": 1.0,
  "occurrences": 1
}
```

---

## Example 3: Deployment Failure

### Problem
```
User: "Deployment to production failed. Works fine locally."
Error: "Environment variable DATABASE_URL not found"
```

### Clawdbot Response
```
🔍 Classic "works on my machine" scenario

Checking environment differences...

LOCAL ENV:
- DATABASE_URL=postgresql://localhost/koopprijs_dev ✅
- NODE_ENV=development ✅
- API_KEY=test_key ✅

PRODUCTION ENV:
- DATABASE_URL=??? ❌ MISSING!
- NODE_ENV=production ✅
- API_KEY=[redacted] ✅

Found the issue: DATABASE_URL not set in production
```

### Solution Applied
```bash
# Phase 4: Implementation

# SSH into production server
ssh user@production-server

# Add environment variable
echo 'DATABASE_URL=postgresql://prod-db.example.com/koopprijs_prod' >> /etc/environment

# Or add to .env file
echo 'DATABASE_URL=postgresql://prod-db.example.com/koopprijs_prod' >> /var/www/app/.env

# Restart service
sudo systemctl restart koopprijs-api

# Phase 5: Verification
curl https://api.koopprijs.com/health
# ✅ {"status": "healthy", "database": "connected"}
```

### Documentation & Prevention
```markdown
## Deployment Checklist Created

Before deploying to new environment:

- [ ] All environment variables documented in .env.example
- [ ] Production .env file created and populated
- [ ] Database connection tested
- [ ] API keys configured
- [ ] File permissions correct
- [ ] Services configured to auto-start
- [ ] Monitoring alerts set up
- [ ] Rollback plan documented

## Added to CI/CD:
- Environment variable validation script
- Fails build if required vars are missing
```

---

## Example 4: Performance Issue (Slow Response)

### Problem
```
User: "The properties listing page is really slow. Takes 15+ seconds to load."
```

### Investigation (Phase 1 & 2)
```bash
# Check response time
time curl http://localhost:3001/api/properties
# real: 16.234s ⚠️ WAY TOO SLOW

# Check database query
EXPLAIN ANALYZE SELECT * FROM properties 
LEFT JOIN images ON properties.id = images.property_id;

# Result: Sequential Scan on properties (15.2s)
# Missing index!

# Check server resources
htop
# CPU: 98% on one core
# Memory: Fine
# Database is the bottleneck
```

### Solution (Phase 3 & 4)
```sql
-- Add missing indexes
CREATE INDEX idx_properties_created_at ON properties(created_at);
CREATE INDEX idx_images_property_id ON images(property_id);

-- Optimize query
-- BEFORE: Get all properties, then join all images
SELECT * FROM properties 
LEFT JOIN images ON properties.id = images.property_id;

-- AFTER: Paginate and limit images
SELECT p.*, 
  (SELECT json_agg(i) FROM (
    SELECT id, url FROM images 
    WHERE property_id = p.id 
    LIMIT 5
  ) i) as images
FROM properties p
ORDER BY created_at DESC
LIMIT 20 OFFSET 0;
```

### Results (Phase 5)
```bash
# Test after optimization
time curl http://localhost:3001/api/properties
# real: 0.234s ✅ 69x FASTER!

# Load test
ab -n 1000 -c 50 http://localhost:3001/api/properties
# Requests per second: 215 (was: 3)
# All requests successful ✅

# Database query performance
EXPLAIN ANALYZE [optimized query]
# Execution time: 180ms (was: 15,200ms)
```

### Learning & Prevention
```json
{
  "pattern": "slow_database_query",
  "symptoms": ["Response time > 5s", "High database CPU"],
  "solutions": [
    "Add database indexes",
    "Optimize query (limit, pagination)",
    "Add caching layer"
  ],
  "prevention": [
    "Always EXPLAIN ANALYZE queries",
    "Add indexes during migration",
    "Implement query monitoring"
  ]
}
```

---

## Example 5: Memory Leak

### Problem
```
User: "Server crashes after running for a few hours. Out of memory error."
```

### Investigation (Phase 1 & 2)
```bash
# Monitor memory over time
watch -n 10 'ps aux | grep node'
# Memory increasing: 500MB -> 1GB -> 2GB -> CRASH

# Use Node memory profiler
node --inspect app.js
# Chrome DevTools -> Memory -> Take heap snapshot

# Analysis shows:
# - Event listeners: 15,000+ (growing)
# - Array size growing: 100,000+ items
# - Database connections: 500+ (not closed)
```

### Root Cause Found
```javascript
// Problem code (controllers/websocket.js)

io.on('connection', (socket) => {
  // Event listener added but NEVER removed!
  eventEmitter.on('update', (data) => {
    socket.emit('update', data);
  });
  
  // Database query creates new connection but never closes
  const db = await createConnection();
  // Missing: db.close()
  
  // Array keeps growing
  globalCache.push(socket.id);
  // Missing: cleanup on disconnect
});
```

### Solution (Phase 4)
```javascript
// Fixed code

io.on('connection', (socket) => {
  const updateHandler = (data) => {
    socket.emit('update', data);
  };
  
  // Add listener
  eventEmitter.on('update', updateHandler);
  
  // CLEANUP on disconnect
  socket.on('disconnect', () => {
    // Remove event listener
    eventEmitter.removeListener('update', updateHandler);
    
    // Remove from cache
    const index = globalCache.indexOf(socket.id);
    if (index > -1) {
      globalCache.splice(index, 1);
    }
    
    console.log('Cleaned up socket:', socket.id);
  });
  
  // Use connection pool instead
  const result = await pool.query('SELECT * FROM users');
  // Pool handles connection lifecycle
});
```

### Verification (Phase 5)
```bash
# Run server and monitor memory for 24 hours
node app.js &
PID=$!

# Monitor script
while true; do
  MEM=$(ps -p $PID -o rss= | awk '{print $1/1024 "MB"}')
  echo "$(date): Memory usage: $MEM"
  sleep 600  # Check every 10 minutes
done

# Results after 24 hours:
# Memory stable at ~300MB ✅
# No crashes ✅
# Event listeners count: constant at ~50 ✅
```

### Prevention Added
```javascript
// Add monitoring alert
if (eventEmitter.listenerCount('update') > 100) {
  logger.error('Potential memory leak: Too many listeners');
  alerting.notify('Memory leak detected');
}

// Add automated cleanup
setInterval(() => {
  const activeConnections = io.sockets.sockets.size;
  const cacheSize = globalCache.length;
  
  if (cacheSize > activeConnections * 1.5) {
    logger.warn('Cache cleanup needed');
    cleanupStaleCache();
  }
}, 60000); // Every minute
```

---

## Example 6: Intermittent Test Failure

### Problem
```
User: "Tests fail randomly. Sometimes pass, sometimes fail. CI is unreliable."
Failing test: "User authentication flow"
```

### Investigation (Phase 2)
```bash
# Run test 100 times to see pattern
for i in {1..100}; do
  npm test -- auth.test.js > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Failed on iteration $i"
  fi
done

# Results:
# Failed on iterations: 15, 31, 47, 68, 83
# Pattern: Roughly every 15-20 runs
# Hypothesis: Race condition or timing issue
```

### Root Cause
```javascript
// Test code (auth.test.js)

test('User login returns token', async () => {
  // Create user
  await createUser({ email: 'test@example.com' });
  
  // Try to login IMMEDIATELY
  const response = await login({ email: 'test@example.com' });
  // ❌ Sometimes fails because database write isn't complete yet
  
  expect(response.token).toBeDefined();
});
```

### Solution (Phase 4)
```javascript
// Fixed test

test('User login returns token', async () => {
  // Create user and WAIT for completion
  const user = await createUser({ email: 'test@example.com' });
  
  // Verify user exists before testing login
  const userExists = await findUser(user.id);
  expect(userExists).toBeTruthy();
  
  // NOW login
  const response = await login({ email: 'test@example.com' });
  
  expect(response.token).toBeDefined();
});

// Also added to global test setup
beforeEach(async () => {
  // Clear database
  await clearDatabase();
  
  // WAIT for database to be ready
  await waitForDatabase();
});
```

### Verification (Phase 5)
```bash
# Run test 1000 times
for i in {1..1000}; do
  npm test -- auth.test.js > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "❌ Failed on iteration $i"
    exit 1
  fi
  if [ $((i % 100)) -eq 0 ]; then
    echo "✅ $i tests passed"
  fi
done

# Result: 1000/1000 passed ✅
```

---

## 🎓 Key Lessons from Examples

### Common Patterns

1. **Dependency Issues** → Clean reinstall (87% success rate)
2. **Undefined Errors** → Add null checks and proper error handling
3. **Environment Issues** → Document all env vars, use .env.example
4. **Performance Issues** → Profile first, optimize based on data
5. **Memory Leaks** → Always cleanup (listeners, connections, timers)
6. **Intermittent Failures** → Race conditions - add proper waits

### Debugging Principles Demonstrated

✅ **Always reproduce first** - Can't fix what you can't see
✅ **Use data to guide decisions** - Profile, measure, then optimize
✅ **One change at a time** - Know what actually fixed it
✅ **Verify thoroughly** - Tests, load testing, monitoring
✅ **Document everything** - Help future you (and Clawdbot)
✅ **Think prevention** - How to avoid this next time?

---

## 🤖 How Clawdbot Uses These Examples

When you report an error, Clawdbot:

1. **Matches against patterns** from these examples
2. **Suggests similar solutions** that worked before
3. **Estimates success rate** based on past outcomes
4. **Guides through same methodology** that solved it before
5. **Updates learning database** with new outcome

**This makes debugging faster every time!**

---

*These examples are real debugging scenarios. Your own debugging sessions will be added to the learning database automatically.*
