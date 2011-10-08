# id - SHA
# type
# size
# content
class GitObject

  constructor: (@repo, @type, @size) ->


class Blob extends GitObject


class Tree extends GitObject

class Commit extends GitObject

class Tag extends GitObject

