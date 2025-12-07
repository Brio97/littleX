export interface TweetNode {
  id: string; // Tweet ID
  username: string;
  content: string;
  embedding: number[];
  likes: string[]; // or array of user IDs
  comments: Comment[]; // or array of comment IDs
  retweets?: string[]; // array of retweet IDs
  created_at?: "";
  type?: "tweet"; // To distinguish from retweets
}

export interface RetweetNode extends Omit<TweetNode, "type"> {
  type: "retweet";
  original_tweet_id: string;
  retweeted_at: string;
  retweet_count: number;
}

export interface QuoteRetweetNode extends Omit<TweetNode, "type"> {
  type: "quote-retweet";
  original_tweet_id: string;
  quote_content: string;
  quoted_at: string;
  quote_count: number;
}

export type FeedItem = TweetNode | RetweetNode | QuoteRetweetNode;

export interface Comment {
  id: string;
  username: string;
  content: string;
}
