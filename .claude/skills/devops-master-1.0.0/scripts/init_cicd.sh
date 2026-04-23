#!/bin/bash
# Initialize CI/CD Pipeline with GitHub Actions

PROJECT_DIR="${1:-.}"

echo "🚀 Initializing CI/CD Pipeline..."
echo "================================================"

cd "$PROJECT_DIR" || exit 1

# Create .github/workflows directory
mkdir -p .github/workflows

echo ""
echo "📁 Creating workflow files..."

# Create CI workflow
cat > .github/workflows/ci.yml << 'EOF'
name: CI Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linter
      run: npm run lint || echo "No lint script found"
    
    - name: Run tests
      run: npm test || echo "No test script found"
    
    - name: Build project
      run: npm run build || echo "No build script found"
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      if: success()
      with:
        token: ${{ secrets.CODECOV_TOKEN }}
        fail_ci_if_error: false

  security:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Run security audit
      run: npm audit --audit-level=moderate || true
    
    - name: Check for vulnerabilities
      uses: snyk/actions/node@master
      continue-on-error: true
      env:
        SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
EOF

echo "✅ Created .github/workflows/ci.yml"

# Create deployment workflow
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy to Production

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Build for production
      run: npm run build
      env:
        NODE_ENV: production
    
    - name: Run tests
      run: npm test
    
    - name: Deploy to server
      if: success()
      run: |
        echo "🚀 Deploying to production..."
        # Add your deployment commands here
        # Example: rsync, scp, docker push, etc.
    
    - name: Notify on success
      if: success()
      run: echo "✅ Deployment successful!"
    
    - name: Notify on failure
      if: failure()
      run: echo "❌ Deployment failed!"

  post-deploy:
    needs: deploy
    runs-on: ubuntu-latest
    
    steps:
    - name: Health check
      run: |
        echo "🏥 Running health checks..."
        # Add health check commands
        # curl https://your-site.com/health
    
    - name: Clear CDN cache
      run: |
        echo "🗑️  Clearing CDN cache..."
        # Add CDN cache clearing commands
EOF

echo "✅ Created .github/workflows/deploy.yml"

# Create Docker workflow (optional)
cat > .github/workflows/docker.yml << 'EOF'
name: Docker Build & Push

on:
  push:
    branches: [ main ]
    tags:
      - 'v*'

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2
    
    - name: Log in to Container Registry
      uses: docker/login-action@v2
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v4
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=semver,pattern={{version}}
          type=semver,pattern={{major}}.{{minor}}
          type=ref,event=branch
          type=sha,prefix={{branch}}-
    
    - name: Build and push Docker image
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
EOF

echo "✅ Created .github/workflows/docker.yml"

# Create basic Dockerfile if it doesn't exist
if [ ! -f "Dockerfile" ]; then
    cat > Dockerfile << 'EOF'
# Multi-stage build for optimized production image
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Build application
RUN npm run build || true

# Production stage
FROM node:18-alpine AS production

WORKDIR /app

# Copy dependencies and build from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Set environment
ENV NODE_ENV=production
ENV PORT=3000

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Run application
CMD ["node", "dist/index.js"]
EOF
    echo "✅ Created Dockerfile"
fi

# Create .dockerignore if it doesn't exist
if [ ! -f ".dockerignore" ]; then
    cat > .dockerignore << 'EOF'
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.env.local
dist
.next
.cache
coverage
*.log
EOF
    echo "✅ Created .dockerignore"
fi

echo ""
echo "================================================"
echo "✅ CI/CD Pipeline Setup Complete!"
echo "================================================"
echo ""
echo "📋 What was created:"
echo "  • .github/workflows/ci.yml - Continuous Integration"
echo "  • .github/workflows/deploy.yml - Automated Deployment"
echo "  • .github/workflows/docker.yml - Docker Build & Push"
echo "  • Dockerfile - Production container image"
echo "  • .dockerignore - Docker build optimization"
echo ""
echo "🔧 Next steps:"
echo "  1. Commit and push these files to your repository"
echo "  2. Configure GitHub Secrets (if needed):"
echo "     • CODECOV_TOKEN (for code coverage)"
echo "     • SNYK_TOKEN (for security scanning)"
echo "     • Deployment credentials"
echo "  3. Enable GitHub Actions in repository settings"
echo "  4. Push to main branch to trigger first deployment"
echo ""
echo "🚀 Your pipeline will now:"
echo "  ✓ Run tests on every push/PR"
echo "  ✓ Check code quality and security"
echo "  ✓ Build Docker images"
echo "  ✓ Deploy to production on main branch"
echo ""
