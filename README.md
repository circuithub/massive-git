# MassiveGit

MassiveGit - revision controlled database. 

## Implementation

MassiveGit implements Git Object Model  on top of Riak [http://basho.com/products/riak-overview/].
In future other backends may be implemented.

## Use cases

There are variety of use cases where it can be used:

1. GitHub
2. CircuitHub
3. WikiPedia
4. shapesmith (MCAD)

Basically any case where you need to store revisioned versions of your data. With MassiveGit you get nice abstraction layer which allows you to deal with data in terms of Git: Commit, Tree, Blob, Tag.

## Additional materials

We have video and slide from London Node.js User Group: http://lanyrd.com/2011/lnug-october/skgpw/.

Check them for initial introduction.

## Tips

Remove riak data from this directory:

`/var/lib/riak/leveldb`


## Configurations

Please updated `js_max_vm_mem` and `js_thread_stack` to 512 MB on your app.config.

See [http://wiki.basho.com/MapReduce.html] for details how to do this and why.

Since we are using secondary indexes please make following change in the riak app.config:
`change the storage backend to riak_kv_eleveldb_backend`.

## Contributions

MassiveGit is currently is under development. If you need any feature tell us or fork project and implement it by yourself.

We appreciate feedback!


## License

(The MIT License)

Copyright (c) 2011 CircuitHub., http://circuithub.com/

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

