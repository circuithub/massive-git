_     = require "underscore"
utils = exports

# Method for finding appropriate link `key` by tag name.
# Return `null` if link wasn't found.
utils.getLink = (links, tagName) =>
  link =_.detect links, (link) -> tagName == link.tag
  if(link)
    return link.key
  else
    return null

