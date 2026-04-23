#!/usr/bin/env node

/**
 * Preference Manager for Learning & Adaptation System
 * Manages user preferences, context, and learning data
 */

const fs = require('fs');
const path = require('path');

class PreferenceManager {
  constructor() {
    this.memoryDir = path.join(process.env.HOME || process.cwd(), '.clawdbot/memory');
    this.preferencesFile = path.join(this.memoryDir, 'preferences.json');
    this.contextFile = path.join(this.memoryDir, 'context.json');
    this.historyFile = path.join(this.memoryDir, 'interaction_history.json');
    
    this.ensureMemoryDir();
    this.loadData();
  }

  /**
   * Ensure memory directory exists
   */
  ensureMemoryDir() {
    if (!fs.existsSync(this.memoryDir)) {
      fs.mkdirSync(this.memoryDir, { recursive: true });
    }
  }

  /**
   * Load all data
   */
  loadData() {
    this.preferences = this.loadJSON(this.preferencesFile, this.getDefaultPreferences());
    this.context = this.loadJSON(this.contextFile, this.getDefaultContext());
    this.history = this.loadJSON(this.historyFile, this.getDefaultHistory());
  }

  /**
   * Load JSON file with fallback
   */
  loadJSON(file, defaultData) {
    try {
      if (fs.existsSync(file)) {
        return JSON.parse(fs.readFileSync(file, 'utf8'));
      }
    } catch (error) {
      console.error(`Error loading ${file}:`, error.message);
    }
    return defaultData;
  }

  /**
   * Save JSON file
   */
  saveJSON(file, data) {
    try {
      fs.writeFileSync(file, JSON.stringify(data, null, 2));
      return true;
    } catch (error) {
      console.error(`Error saving ${file}:`, error.message);
      return false;
    }
  }

  /**
   * Get default preferences structure
   */
  getDefaultPreferences() {
    return {
      code_style: {
        indentation: '2 spaces',
        quotes: 'single',
        semicolons: true,
        async_style: 'async/await',
        naming_convention: 'camelCase',
        max_line_length: 80,
        max_function_lines: 50
      },
      tech_stack: {
        frontend: [],
        backend: [],
        database: [],
        testing: [],
        devops: []
      },
      communication: {
        verbosity: 'balanced',
        show_explanations: true,
        code_comments: 'moderate',
        suggest_improvements: true
      },
      development: {
        test_first: false,
        auto_format: true,
        strict_types: true,
        error_handling: 'explicit'
      },
      learned_patterns: [],
      custom_preferences: {}
    };
  }

  /**
   * Get default context structure
   */
  getDefaultContext() {
    return {
      current_project: null,
      projects: {},
      recent_topics: [],
      active_features: [],
      decisions: []
    };
  }

  /**
   * Get default history structure
   */
  getDefaultHistory() {
    return {
      interactions: [],
      successful_suggestions: [],
      rejected_suggestions: [],
      common_tasks: {},
      feedback_received: []
    };
  }

  /**
   * Learn a new preference
   */
  learnPreference(category, key, value) {
    if (!this.preferences[category]) {
      this.preferences[category] = {};
    }
    
    this.preferences[category][key] = value;
    this.saveJSON(this.preferencesFile, this.preferences);
    
    console.log(`✅ Learned: ${category}.${key} = ${value}`);
    return true;
  }

  /**
   * Remember context
   */
  rememberContext(type, data) {
    const timestamp = new Date().toISOString();
    
    switch (type) {
      case 'project':
        this.context.current_project = data;
        if (!this.context.projects[data.name]) {
          this.context.projects[data.name] = {
            ...data,
            first_seen: timestamp,
            last_updated: timestamp
          };
        }
        break;
        
      case 'decision':
        this.context.decisions.push({
          timestamp,
          ...data
        });
        break;
        
      case 'topic':
        this.context.recent_topics.unshift({
          timestamp,
          topic: data
        });
        // Keep only last 50 topics
        this.context.recent_topics = this.context.recent_topics.slice(0, 50);
        break;
    }
    
    this.saveJSON(this.contextFile, this.context);
    console.log(`✅ Remembered: ${type}`);
    return true;
  }

  /**
   * Record interaction
   */
  recordInteraction(interaction) {
    const timestamp = new Date().toISOString();
    
    this.history.interactions.push({
      timestamp,
      ...interaction
    });
    
    // Keep only last 1000 interactions
    if (this.history.interactions.length > 1000) {
      this.history.interactions = this.history.interactions.slice(-1000);
    }
    
    // Update common tasks
    if (interaction.task) {
      if (!this.history.common_tasks[interaction.task]) {
        this.history.common_tasks[interaction.task] = 0;
      }
      this.history.common_tasks[interaction.task]++;
    }
    
    this.saveJSON(this.historyFile, this.history);
  }

  /**
   * Record suggestion feedback
   */
  recordFeedback(suggestion, accepted) {
    const timestamp = new Date().toISOString();
    const record = {
      timestamp,
      suggestion,
      accepted
    };
    
    if (accepted) {
      this.history.successful_suggestions.push(record);
    } else {
      this.history.rejected_suggestions.push(record);
    }
    
    this.saveJSON(this.historyFile, this.history);
  }

  /**
   * Add feedback
   */
  addFeedback(feedback) {
    const timestamp = new Date().toISOString();
    
    this.history.feedback_received.push({
      timestamp,
      feedback
    });
    
    // Analyze feedback for learning
    this.analyzeFeedback(feedback);
    
    this.saveJSON(this.historyFile, this.history);
    console.log(`✅ Feedback recorded`);
  }

  /**
   * Analyze feedback for learning opportunities
   */
  analyzeFeedback(feedback) {
    const lower = feedback.toLowerCase();
    
    // Check for verbosity preferences
    if (lower.includes('too verbose') || lower.includes('too long')) {
      this.learnPreference('communication', 'verbosity', 'concise');
    } else if (lower.includes('too short') || lower.includes('more detail')) {
      this.learnPreference('communication', 'verbosity', 'detailed');
    }
    
    // Check for explanation preferences
    if (lower.includes('no explanation') || lower.includes('just code')) {
      this.learnPreference('communication', 'show_explanations', false);
    }
    
    // Check for code style feedback
    if (lower.includes('tabs')) {
      this.learnPreference('code_style', 'indentation', 'tabs');
    } else if (lower.includes('4 spaces')) {
      this.learnPreference('code_style', 'indentation', '4 spaces');
    }
  }

  /**
   * Get most common tasks
   */
  getMostCommonTasks(limit = 10) {
    const tasks = Object.entries(this.history.common_tasks)
      .sort((a, b) => b[1] - a[1])
      .slice(0, limit)
      .map(([task, count]) => ({ task, count }));
    
    return tasks;
  }

  /**
   * Get adaptation recommendations
   */
  getAdaptationRecommendations() {
    const recommendations = [];
    
    // Check success rate of suggestions
    const totalSuggestions = 
      this.history.successful_suggestions.length + 
      this.history.rejected_suggestions.length;
    
    if (totalSuggestions > 10) {
      const successRate = 
        (this.history.successful_suggestions.length / totalSuggestions) * 100;
      
      recommendations.push({
        area: 'suggestion_quality',
        current_rate: `${successRate.toFixed(1)}%`,
        status: successRate > 70 ? 'good' : 'needs_improvement'
      });
    }
    
    // Check common tasks
    const commonTasks = this.getMostCommonTasks(5);
    if (commonTasks.length > 0) {
      recommendations.push({
        area: 'task_automation',
        message: 'Consider creating shortcuts for common tasks',
        tasks: commonTasks
      });
    }
    
    return recommendations;
  }

  /**
   * Export preferences summary
   */
  exportSummary() {
    return {
      preferences: this.preferences,
      context: {
        current_project: this.context.current_project,
        total_projects: Object.keys(this.context.projects).length,
        recent_topics: this.context.recent_topics.slice(0, 10)
      },
      statistics: {
        total_interactions: this.history.interactions.length,
        successful_suggestions: this.history.successful_suggestions.length,
        rejected_suggestions: this.history.rejected_suggestions.length,
        feedback_count: this.history.feedback_received.length,
        common_tasks: this.getMostCommonTasks(10)
      },
      recommendations: this.getAdaptationRecommendations()
    };
  }

  /**
   * Display current learning status
   */
  displayStatus() {
    const summary = this.exportSummary();
    
    console.log('\n' + '='.repeat(60));
    console.log('🧠 LEARNING & ADAPTATION STATUS');
    console.log('='.repeat(60) + '\n');
    
    console.log('📋 Preferences:');
    console.log(`  Code Style: ${summary.preferences.code_style.indentation}, ${summary.preferences.code_style.quotes} quotes`);
    console.log(`  Communication: ${summary.preferences.communication.verbosity}`);
    console.log(`  Tech Stack: ${Object.values(summary.preferences.tech_stack).flat().join(', ') || 'Not yet learned'}`);
    console.log('');
    
    console.log('📊 Statistics:');
    console.log(`  Total Interactions: ${summary.statistics.total_interactions}`);
    console.log(`  Successful Suggestions: ${summary.statistics.successful_suggestions}`);
    console.log(`  Feedback Received: ${summary.statistics.feedback_count}`);
    console.log('');
    
    if (summary.statistics.common_tasks.length > 0) {
      console.log('🎯 Most Common Tasks:');
      summary.statistics.common_tasks.slice(0, 5).forEach((task, i) => {
        console.log(`  ${i + 1}. ${task.task} (${task.count}x)`);
      });
      console.log('');
    }
    
    if (summary.recommendations.length > 0) {
      console.log('💡 Recommendations:');
      summary.recommendations.forEach(rec => {
        console.log(`  • ${rec.message || rec.area}: ${rec.status || ''}`);
      });
      console.log('');
    }
    
    console.log('='.repeat(60) + '\n');
  }

  /**
   * Reset learning data
   */
  reset(category = 'all') {
    switch (category) {
      case 'preferences':
        this.preferences = this.getDefaultPreferences();
        this.saveJSON(this.preferencesFile, this.preferences);
        console.log('✅ Preferences reset');
        break;
        
      case 'context':
        this.context = this.getDefaultContext();
        this.saveJSON(this.contextFile, this.context);
        console.log('✅ Context reset');
        break;
        
      case 'history':
        this.history = this.getDefaultHistory();
        this.saveJSON(this.historyFile, this.history);
        console.log('✅ History reset');
        break;
        
      case 'all':
        this.preferences = this.getDefaultPreferences();
        this.context = this.getDefaultContext();
        this.history = this.getDefaultHistory();
        this.saveJSON(this.preferencesFile, this.preferences);
        this.saveJSON(this.contextFile, this.context);
        this.saveJSON(this.historyFile, this.history);
        console.log('✅ All learning data reset');
        break;
    }
  }
}

// CLI interface
if (require.main === module) {
  const manager = new PreferenceManager();
  const command = process.argv[2];
  
  switch (command) {
    case 'status':
      manager.displayStatus();
      break;
      
    case 'learn':
      const category = process.argv[3];
      const key = process.argv[4];
      const value = process.argv.slice(5).join(' ');
      if (category && key && value) {
        manager.learnPreference(category, key, value);
      } else {
        console.log('Usage: preference-manager.js learn <category> <key> <value>');
      }
      break;
      
    case 'reset':
      const resetCategory = process.argv[3] || 'all';
      manager.reset(resetCategory);
      break;
      
    default:
      console.log('Usage: preference-manager.js <command>');
      console.log('Commands:');
      console.log('  status              - Show learning status');
      console.log('  learn <cat> <k> <v> - Learn a preference');
      console.log('  reset [category]    - Reset learning data');
  }
}

module.exports = PreferenceManager;
