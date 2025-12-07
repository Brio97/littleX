# LittleX Architecture & Multi-Agent Design

## System Overview

LittleX is an advanced social media platform built with Jaseci, featuring:
- **Object-Spatial Programming (OSP)** for graph-based data structures
- **Multi-Agent Architecture** with specialized walkers for different responsibilities
- **AI-Powered Features** using byLLM for intelligent content analysis and generation
- **Real-time Social Features** including tweets, retweets, quote retweets, likes, and comments

## Core Components

### 1. Data Layer (Nodes & Edges)

#### Primary Nodes
- **Profile**: User account information with username and relationships
- **Tweet**: User-generated content with embeddings for semantic search
- **Comment**: Replies to tweets
- **Retweet**: Share original content (native retweet functionality)
- **QuoteRetweet**: Retweet with additional commentary

#### Advanced Nodes
- **TrendingTopic**: Tracks trending hashtags and topics with frequency and sentiment
- **InterestGroup**: Groups of users with common interests
- **ConversationThread**: Organized discussion threads
- **ContentTheme**: Semantic grouping of content
- **EngagementPattern**: User engagement metrics and patterns

#### Edges
- **Follow**: User-to-user relationship
- **Like**: User-to-tweet interaction
- **Post**: User-to-tweet authorship
- **Retweets**: User-to-retweet sharing
- **QuoteRetweets**: User-to-quote retweet sharing
- **TopicAffinity**: User-to-topic relationship with weighted preference
- **GroupMembership**: User-to-interest-group membership
- **ConversationFlow**: Tweet-to-thread connection
- **Engagement**: Interaction tracking between users and content

## Multi-Agent Architecture

LittleX implements a multi-agent system with 3 primary agents:

### Agent 1: Content Curator
**Responsibility**: Feed generation, content filtering, and recommendations
**Key Walkers**:
- `load_feed`: Curates personalized feed from followed users
- `recommend_content`: Generates personalized content recommendations
- `generate_content_suggestions`: Creates topic-based content suggestions

**Generative byLLM Use**: Suggests relevant topics and optimal posting times based on user engagement patterns.

### Agent 2: Community Builder
**Responsibility**: Community detection, engagement analysis, and group building
**Key Walkers**:
- `discover_communities`: Identifies communities based on follow patterns
- `analyze_engagement`: Calculates engagement metrics (likes, comments, reach)
- `find_conversation_threads`: Organizes related tweets into discussion threads

**Analytical byLLM Use**: Scores community strength and identifies influential members.

### Agent 3: Trend Analyzer
**Responsibility**: Trend detection, hashtag analysis, and sentiment tracking
**Key Walkers**:
- `detect_trending_topics`: Identifies emerging trending hashtags
- `generate_hashtags`: Extracts and generates relevant hashtags for tweets
- `analyze_engagement`: Tracks engagement patterns over time

**Generative byLLM Use**: Creates summary descriptions for trending topics.
**Analytical byLLM Use**: Analyzes sentiment and extracts key themes from trends.

## Agent Interaction Flow

```
User Action
    ↓
Profile Agent (visit_profile) → Creates/visits user profile
    ↓
Content Creator (create_tweet) → Creates post with embedding
    ↓
Trend Analyzer → Detects #hashtags and trending topics
    ↓
Community Builder → Updates engagement patterns
    ↓
Content Curator → Updates feed recommendations
    ↓
User Feed Loaded → Personalized content displayed
```

## byLLM Integration

### Generative Functions (Content Creation)
1. **Content Suggestions** (generate_content_suggestions)
   - Prompt: "Based on user interests and engagement patterns, suggest relevant topics and content themes"
   - Role: Content Curator
   - Output: Topic suggestions, content types, optimal posting times

2. **Hashtag Generation** (generate_hashtags)
   - Prompt: "Extract important keywords and generate relevant hashtags from tweet content"
   - Role: Trend Analyzer
   - Output: Extracted and generated hashtags

3. **Conversation Starters** (find_conversation_threads)
   - Prompt: "Group related tweets into conversation threads and suggest discussion topics"
   - Role: Community Builder
   - Output: Organized conversation threads

### Analytical Functions (Data Analysis)
1. **Trend Detection** (detect_trending_topics)
   - Prompt: "Analyze tweet content to identify and rank emerging trends"
   - Role: Trend Analyzer
   - Output: Ranked trending topics with frequency scores

2. **Engagement Analysis** (analyze_engagement)
   - Prompt: "Calculate user engagement metrics and predict engagement potential"
   - Role: Community Builder
   - Output: Engagement scores and patterns

3. **Content Recommendation** (recommend_content)
   - Prompt: "Score content relevance to user interests using collaborative filtering"
   - Role: Content Curator
   - Output: Ranked content recommendations

## OSP Graph Usage

LittleX leverages Object-Spatial Programming for:

### Graph Traversal Examples
```jac
// Find all followers of a user
[user_profile -->:Follow:-->(`?Profile)]

// Get all tweets by followed users
[current_user -->:Follow:--> user_node --> (`?Tweet)]

// Find engagement patterns
[tweet -->:Like:--> (`?Profile)]

// Discover communities
[profile -->:Follow:--> profile2 -->:Follow:--> profile3]
```

### Graph-Based Algorithms
1. **Community Detection**: Uses Follow edges to identify clusters of interconnected users
2. **Collaborative Filtering**: Analyzes Like and Comment edges to predict preferences
3. **Trend Propagation**: Tracks engagement across graph to identify viral content
4. **User Influence**: Scores users based on follower count and engagement reach

## Key Features

### Social Features
- ✅ User Profiles with Follow/Unfollow
- ✅ Tweet Creation with Semantic Embeddings
- ✅ Like System
- ✅ Comments on Tweets
- ✅ **NEW**: Retweet Functionality
- ✅ **NEW**: Quote Retweet with Commentary
- ✅ Personalized Feed with Semantic Search

### AI Features
- ✅ Trending Topic Detection
- ✅ Content Suggestions
- ✅ Hashtag Generation & Analysis
- ✅ Engagement Metrics
- ✅ Community Discovery
- ✅ Conversation Threading
- ✅ Personalized Recommendations

## Data Flow

```
1. User Creates Tweet
   ↓ (create_tweet walker)
2. Tweet embedded via TF-IDF
   ↓
3. Trend Analyzer detects hashtags
   ↓
4. Engagement Patterns updated
   ↓
5. Content Curator updates recommendations
   ↓
6. Community Builder identifies clusters
   ↓
7. Users see updated feed with AI suggestions
```

## Testing Strategy

All features include comprehensive test coverage:
- Unit tests for each walker
- Integration tests for agent interactions
- End-to-end tests for complete workflows
- Seed data for demo and testing

## Deployment Architecture

```
Frontend (JAC-Client / React)
        ↓
Backend API (jac serve)
        ↓
OSP Graph Database (Jaseci Runtime)
        ↓
byLLM Services (OpenAI/Ollama)
```

## Performance Considerations

1. **Graph Indexing**: Frequently traversed paths are optimized
2. **Caching**: Popular feeds and trends are cached
3. **Batch Processing**: Trend detection runs periodically
4. **Lazy Loading**: Recommendations computed on-demand
