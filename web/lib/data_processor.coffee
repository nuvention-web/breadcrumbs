# invalid chars ~ ! @ $ % ^ & * ( ) + = , . / ' ; : " ? > < [ ] \ { } | ` #
@classify = (class_name) ->
    if class_name
        fix = class_name.replace(/\s/g, '-')
        fix = fix.replace(/&|@|,|'/g, '-') ## need to add others in
        return fix.toLowerCase() # to lower case
    else
        return 'undefined' #????

@matchKeywords = (item_keywords, category_keywords) ->
    max_mismatches = 1 + Math.max(0, item_keywords.length - category_keywords.length) #edge cases of category keywords being short
    
    mismatches = 0
    mismatched = []
    for keyword in item_keywords
        if !matchKeyword keyword, category_keywords
            mismatches += 1
            mismatched.push keyword

    if mismatches < max_mismatches
        return [true, mismatched]
    else
        return [false, mismatched]

matchKeyword = (keyword, category_keywords) ->
    return _.some(category_keywords, (category_keyword) ->
        match(keyword, category_keyword))

match = (word1, word2) ->
    return word1 == word2 #make this better!


@matchSingleName = (name, category_keywords) ->
    words = name.split ' '
    for word in words
        if word.toLowerCase() not in stopwords
            for keyword in category_keywords
                if keyword.toLowerCase().indexOf(word.toLowerCase()) != -1
                    return true
    return false

invalidPatterns = [
    "ftp://",
    "file://",
    "localhost:",
]

@invalidURL = (url) ->
    return not _.every(invalidPatterns, (pattern) -> url.indexOf(pattern) == -1)

stopwords = 
    [ "a", 
      "about", 
      "above", 
      "after", 
      "again", 
      "against", 
      "all", 
      "am", 
      "an", 
      "and", 
      "any", 
      "are", 
      "aren't", 
      "as", 
      "at", 
      "be", 
      "because", 
      "been", 
      "before", 
      "being", 
      "below", 
      "between", 
      "both", 
      "but", 
      "by", 
      "can't", 
      "cannot", 
      "could", 
      "couldn't", 
      "did", 
      "didn't", 
      "do", 
      "does", 
      "doesn't", 
      "doing", 
      "don't", 
      "down", 
      "during", 
      "each", 
      "few", 
      "for", 
      "from", 
      "further", 
      "had", 
      "hadn't", 
      "has", 
      "hasn't", 
      "have", 
      "haven't", 
      "having", 
      "he", 
      "he'd", 
      "he'll", 
      "he's", 
      "her", 
      "here", 
      "here's", 
      "hers", 
      "herself", 
      "him", 
      "himself", 
      "his", 
      "how", 
      "how's", 
      "i", 
      "i'd", 
      "i'll", 
      "i'm", 
      "i've", 
      "if", 
      "in", 
      "into", 
      "is", 
      "isn't", 
      "it", 
      "it's", 
      "its", 
      "itself", 
      "let's", 
      "me", 
      "more", 
      "most", 
      "mustn't", 
      "my", 
      "myself", 
      "no", 
      "nor", 
      "not", 
      "of", 
      "off", 
      "on", 
      "once", 
      "only", 
      "or", 
      "other", 
      "ought", 
      "our", 
      "ours", 
      "ourselves", 
      "out", 
      "over", 
      "own", 
      "same", 
      "shan't", 
      "she", 
      "she'd", 
      "she'll", 
      "she's", 
      "should", 
      "shouldn't", 
      "so", 
      "some", 
      "such", 
      "than", 
      "that", 
      "that's", 
      "the", 
      "their", 
      "theirs", 
      "them", 
      "themselves", 
      "then", 
      "there", 
      "there's", 
      "these", 
      "they", 
      "they'd", 
      "they'll", 
      "they're", 
      "they've", 
      "this", 
      "those", 
      "through", 
      "to", 
      "too", 
      "under", 
      "until", 
      "up", 
      "very", 
      "was", 
      "wasn't", 
      "we", 
      "we'd", 
      "we'll", 
      "we're", 
      "we've", 
      "were", 
      "weren't", 
      "what", 
      "what's", 
      "when", 
      "when's", 
      "where", 
      "where's", 
      "which", 
      "while", 
      "who", 
      "who's", 
      "whom", 
      "why", 
      "why's", 
      "with", 
      "won't", 
      "would", 
      "wouldn't", 
      "you", 
      "you'd", 
      "you'll", 
      "you're", 
      "you've", 
      "your", 
      "yours", 
      "yourself", 
      "yourselves"
]