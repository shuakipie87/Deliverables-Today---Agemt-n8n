#!/usr/bin/env node

/**
 * Code Analyzer Tool for Full-Stack Development
 * Analyzes code quality, patterns, and suggests improvements
 */

const fs = require('fs');
const path = require('path');

class CodeAnalyzer {
  constructor(projectPath = process.cwd()) {
    this.projectPath = projectPath;
    this.issues = [];
    this.stats = {
      totalFiles: 0,
      linesOfCode: 0,
      complexity: 0,
      testCoverage: 0
    };
  }

  /**
   * Analyze the entire project
   */
  async analyzeProject() {
    console.log('🔍 Analyzing project...\n');
    
    // Detect tech stack
    const techStack = this.detectTechStack();
    console.log('📦 Tech Stack Detected:');
    console.log(JSON.stringify(techStack, null, 2));
    console.log('');

    // Find code files
    const codeFiles = this.findCodeFiles();
    this.stats.totalFiles = codeFiles.length;
    console.log(`📁 Found ${codeFiles.length} code files\n`);

    // Analyze each file
    for (const file of codeFiles) {
      this.analyzeFile(file);
    }

    // Generate report
    this.generateReport();
  }

  /**
   * Detect technology stack
   */
  detectTechStack() {
    const stack = {
      frontend: [],
      backend: [],
      database: [],
      testing: [],
      devops: []
    };

    try {
      const packageJson = JSON.parse(
        fs.readFileSync(path.join(this.projectPath, 'package.json'), 'utf8')
      );

      const deps = { ...packageJson.dependencies, ...packageJson.devDependencies };

      // Frontend
      if (deps.react) stack.frontend.push('React');
      if (deps.next) stack.frontend.push('Next.js');
      if (deps.vue) stack.frontend.push('Vue');
      if (deps.angular) stack.frontend.push('Angular');
      if (deps.svelte) stack.frontend.push('Svelte');
      if (deps.typescript) stack.frontend.push('TypeScript');

      // Backend
      if (deps.express) stack.backend.push('Express');
      if (deps['@nestjs/core']) stack.backend.push('NestJS');
      if (deps.fastify) stack.backend.push('Fastify');

      // Database
      if (deps.prisma) stack.database.push('Prisma');
      if (deps.mongoose) stack.database.push('MongoDB/Mongoose');
      if (deps.pg) stack.database.push('PostgreSQL');
      if (deps.mysql2) stack.database.push('MySQL');
      if (deps.redis) stack.database.push('Redis');

      // Testing
      if (deps.jest) stack.testing.push('Jest');
      if (deps.vitest) stack.testing.push('Vitest');
      if (deps.cypress) stack.testing.push('Cypress');
      if (deps.playwright) stack.testing.push('Playwright');

      // DevOps
      if (fs.existsSync(path.join(this.projectPath, 'Dockerfile'))) {
        stack.devops.push('Docker');
      }
      if (fs.existsSync(path.join(this.projectPath, '.github/workflows'))) {
        stack.devops.push('GitHub Actions');
      }
      if (fs.existsSync(path.join(this.projectPath, 'docker-compose.yml'))) {
        stack.devops.push('Docker Compose');
      }
    } catch (error) {
      // No package.json or error reading it
    }

    return stack;
  }

  /**
   * Find all code files in the project
   */
  findCodeFiles(dir = this.projectPath, files = []) {
    const entries = fs.readdirSync(dir, { withFileTypes: true });

    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      
      // Skip node_modules, .git, etc.
      if (entry.name === 'node_modules' || entry.name === '.git' || 
          entry.name === 'dist' || entry.name === 'build') {
        continue;
      }

      if (entry.isDirectory()) {
        this.findCodeFiles(fullPath, files);
      } else if (this.isCodeFile(entry.name)) {
        files.push(fullPath);
      }
    }

    return files;
  }

  /**
   * Check if file is a code file
   */
  isCodeFile(filename) {
    const codeExtensions = [
      '.js', '.jsx', '.ts', '.tsx',
      '.py', '.go', '.rs', '.php',
      '.vue', '.svelte'
    ];
    return codeExtensions.some(ext => filename.endsWith(ext));
  }

  /**
   * Analyze a single file
   */
  analyzeFile(filePath) {
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      const lines = content.split('\n');
      this.stats.linesOfCode += lines.length;

      // Check for common issues
      this.checkForIssues(filePath, content, lines);
    } catch (error) {
      console.error(`Error analyzing ${filePath}:`, error.message);
    }
  }

  /**
   * Check for common code issues
   */
  checkForIssues(filePath, content, lines) {
    const relPath = path.relative(this.projectPath, filePath);

    // TODO comments
    const todoMatches = content.match(/\/\/\s*TODO|#\s*TODO/gi);
    if (todoMatches) {
      this.issues.push({
        type: 'todo',
        severity: 'info',
        file: relPath,
        count: todoMatches.length,
        message: `${todoMatches.length} TODO comment(s) found`
      });
    }

    // FIXME comments
    const fixmeMatches = content.match(/\/\/\s*FIXME|#\s*FIXME/gi);
    if (fixmeMatches) {
      this.issues.push({
        type: 'fixme',
        severity: 'warning',
        file: relPath,
        count: fixmeMatches.length,
        message: `${fixmeMatches.length} FIXME comment(s) found`
      });
    }

    // console.log (should use proper logging)
    const consoleLogMatches = content.match(/console\.log/g);
    if (consoleLogMatches && consoleLogMatches.length > 3) {
      this.issues.push({
        type: 'console-log',
        severity: 'warning',
        file: relPath,
        count: consoleLogMatches.length,
        message: `${consoleLogMatches.length} console.log statements (consider using proper logging)`
      });
    }

    // Long functions (>50 lines)
    const functionMatches = content.match(/function\s+\w+\s*\([^)]*\)\s*{/g);
    if (functionMatches) {
      // Simple check - could be improved
      if (lines.length > 50) {
        this.issues.push({
          type: 'long-function',
          severity: 'warning',
          file: relPath,
          message: 'File contains potentially long functions (>50 lines)'
        });
      }
    }

    // Hardcoded credentials (basic check)
    const credentialPatterns = [
      /password\s*=\s*['"][^'"]+['"]/i,
      /api[_-]?key\s*=\s*['"][^'"]+['"]/i,
      /secret\s*=\s*['"][^'"]+['"]/i
    ];
    
    for (const pattern of credentialPatterns) {
      if (pattern.test(content) && !content.includes('process.env')) {
        this.issues.push({
          type: 'security',
          severity: 'critical',
          file: relPath,
          message: 'Potential hardcoded credential detected'
        });
        break;
      }
    }

    // Missing error handling in async functions
    if (content.includes('async ') && !content.includes('try') && !content.includes('catch')) {
      this.issues.push({
        type: 'error-handling',
        severity: 'warning',
        file: relPath,
        message: 'Async function without try-catch block'
      });
    }
  }

  /**
   * Generate analysis report
   */
  generateReport() {
    console.log('\n' + '='.repeat(60));
    console.log('📊 CODE ANALYSIS REPORT');
    console.log('='.repeat(60) + '\n');

    // Statistics
    console.log('📈 Statistics:');
    console.log(`  Total Files: ${this.stats.totalFiles}`);
    console.log(`  Lines of Code: ${this.stats.linesOfCode}`);
    console.log('');

    // Issues by severity
    const critical = this.issues.filter(i => i.severity === 'critical');
    const warnings = this.issues.filter(i => i.severity === 'warning');
    const info = this.issues.filter(i => i.severity === 'info');

    console.log('🚨 Issues Found:');
    console.log(`  Critical: ${critical.length}`);
    console.log(`  Warnings: ${warnings.length}`);
    console.log(`  Info: ${info.length}`);
    console.log('');

    // Show critical issues
    if (critical.length > 0) {
      console.log('❌ Critical Issues:');
      critical.forEach(issue => {
        console.log(`  • ${issue.file}: ${issue.message}`);
      });
      console.log('');
    }

    // Show warnings
    if (warnings.length > 0) {
      console.log('⚠️  Warnings:');
      warnings.slice(0, 10).forEach(issue => {
        console.log(`  • ${issue.file}: ${issue.message}`);
      });
      if (warnings.length > 10) {
        console.log(`  ... and ${warnings.length - 10} more`);
      }
      console.log('');
    }

    // Recommendations
    console.log('💡 Recommendations:');
    if (critical.length > 0) {
      console.log('  1. Fix critical security issues immediately');
    }
    if (warnings.filter(w => w.type === 'todo').length > 10) {
      console.log('  2. Address TODO comments - create issues for tracking');
    }
    if (warnings.filter(w => w.type === 'console-log').length > 0) {
      console.log('  3. Replace console.log with proper logging framework');
    }
    if (this.stats.linesOfCode / this.stats.totalFiles > 300) {
      console.log('  4. Consider breaking down large files');
    }
    console.log('');

    console.log('✅ Analysis complete!');
    console.log('='.repeat(60) + '\n');
  }
}

// Run if called directly
if (require.main === module) {
  const analyzer = new CodeAnalyzer();
  analyzer.analyzeProject().catch(console.error);
}

module.exports = CodeAnalyzer;
