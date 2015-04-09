@matchKeywords = (item_keywords, category_keywords) ->
    max_mismatches = 1 + Math.max(0, item_keywords?.length - category_keywords?.length) #edge cases of category keywords being short
    
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


@checkFor = (entry, keywords) ->
    for key in keywords
        if entry.domain.toLowerCase().indexOf(key.toLowerCase()) != -1 or 
        entry.url.toLowerCase().indexOf(key.toLowerCase()) != -1 or 
        entry.title.toLowerCase().indexOf(key.toLowerCase()) != -1
            return true
    return false

invalidPatterns = [
    "ftp://",
    "file://",
    "localhost:",
]

@invalidURL = (url) ->
    return not _.every(invalidPatterns, (pattern) -> url.indexOf(pattern) == -1)