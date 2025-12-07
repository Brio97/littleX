impl search_tweets{
    transformed = vectorizer.fit_transform([query, tweet]);
    similarity = cosine_similarity(transformed[0], transformed[1])[0];
    return similarity;
}

impl Profile.update{
    self.username = visitor.new_username;
    report self ;
}

impl Profile.get{
    follwers = [{"id": jid(i), "username": i.username} for i in [self-->(`?Profile)]];
    report {"user": self, "followers": follwers} ;
}

impl Profile.follow{
    current_profile = [root-->(`?Profile)];
    current_profile[0] +>: Follow() :+> self;
    report self ;
}

impl Profile.un_follow{
    current_profile = [root-->(`?Profile)];
    follow_edge = [edge current_profile[0]->:Follow:->self];
    del follow_edge[0] ;
    report self ;
}

impl Tweet.update{
    self.content = visitor.updated_content;
    report self ;
}

impl Tweet.delete{
    del self ;
    disengage;
}

impl Tweet.like_tweet{
    current_profile = [root-->(`?Profile)];
    self +>: Like() :+> current_profile[0];
    report self ;
}

impl Tweet.remove_like{
    current_profile = [root-->(`?Profile)];
    like_edge = [edge self->:Like:->current_profile[0]];
    del like_edge[0] ;
    report self ;
}

impl Tweet.comment{
    current_profile = [root-->(`?Profile)];
    comment_node = current_profile[0] +>: Post() :+> Comment(content=visitor.content);
    grant(comment_node[0], level=ConnectPerm);
    self ++> comment_node[0];
    report comment_node[0] ;
}

impl Tweet.get_info{
    return TweetInfo(
        username=[self<-:Post:<-][0].username,
        id=jid(self),
        content=self.content,
        embedding=self.embedding,
        likes=[i.username for i in [self->:Like:->]],
        comments=[
            {
                "username": [i<--(`?Profile)][0].username,
                "id": jid(i),
                "content": i.content
            } for i in [self-->(`?Comment)]
        ]
    );
}

impl Tweet.get{
    tweet_info = self.get_info();
    similarity = search_tweets(visitor.search_query, tweet_info.content);
    visitor.results.append({"Tweet_Info": tweet_info, "similarity": similarity});
}

impl Comment.update{
    self.content = visitor.updated_content;
    report self ;
}

impl Comment.delete{
    del self ;
    disengage;
}

impl visit_profile.visit_profile{
    visit [-->(`?Profile)] else {
        new_profile = here ++> Profile();
        grant(new_profile[0], level=ConnectPerm);
        visit new_profile;
    }
}

impl load_user_profiles.load_profiles{
    self.profiles: list = [];
    for each_root in allroots() {
        profile = [each_root-->(`?Profile)][0];
        self.profiles.append({"name": profile.username, "id": jid(profile)});
    }
}

impl load_user_profiles.report_profiles{
    report self.profiles ;
}

impl create_tweet.tweet{
    embedding = vectorizer.fit_transform([self.content]).toarray().tolist();
    tweet_node = here +>: Post() :+> Tweet(content=self.content, embedding=embedding);
    grant(tweet_node[0], level=ConnectPerm);
    report tweet_node ;
}

impl load_feed.load{
    visit [-->(`?Tweet)];
    visit [-->(`?Retweet)];
    visit [-->(`?QuoteRetweet)];
    for user_node in [->:Follow:->(`?Profile)] {
        visit [user_node-->(`?Tweet)];
        visit [user_node-->(`?Retweet)];
        visit [user_node-->(`?QuoteRetweet)];
    }
}

impl load_feed.report_feed{
    self.results.sort(key=lambda  x: dict: x['similarity'][0], reverse=True);
    report self.results ;
}

impl Profile.retweet {
    all_tweets = [self-->(`?Tweet)];
    original_tweet = None;
    target_tweet_id = str(visitor.tweet_id);
    
    for tweet in all_tweets {
        if str(jid(tweet)) == target_tweet_id {
            original_tweet = tweet;
            break;
        }
    }
    
    if original_tweet != None {
        retweet_node = self +>: Retweets() :+> Retweet(original_tweet_id=visitor.tweet_id);
        grant(retweet_node[0], level=ConnectPerm);
        report retweet_node ;
    } else {
        report "Tweet not found" ;
    }
}

impl Profile.remove_retweet {
    all_retweets = [self-->(`?Retweet)];
    target_retweet = None;
    
    for retweet in all_retweets {
        if str(jid(retweet)) == str(visitor.retweet_id) {
            target_retweet = retweet;
            break;
        }
    }
    
    if target_retweet != None {
        del target_retweet ;
        report "Retweet removed successfully" ;
    } else {
        report "Retweet not found" ;
    }
}

impl Profile.quote {
    all_tweets = [self-->(`?Tweet)];
    original_tweet = None;
    target_tweet_id = str(visitor.original_tweet_id);
    
    for tweet in all_tweets {
        if str(jid(tweet)) == target_tweet_id {
            original_tweet = tweet;
            break;
        }
    }
    
    if original_tweet != None {
        quote_tweet = self +>: QuoteRetweets() :+> QuoteRetweet(
            original_tweet_id=visitor.original_tweet_id,
            quote_content=visitor.quote_content
        );
        grant(quote_tweet[0], level=ConnectPerm);
        report quote_tweet ;
    } else {
        report "Original tweet not found" ;
    }
}

impl Profile.remove_quote {
    all_quotes = [self-->(`?QuoteRetweet)];
    target_quote = None;
    
    for quote in all_quotes {
        if str(jid(quote)) == str(visitor.quote_retweet_id) {
            target_quote = quote;
            break;
        }
    }
    
    if target_quote != None {
        del target_quote ;
        report "Quote retweet removed successfully" ;
    } else {
        report "Quote retweet not found" ;
    }
}