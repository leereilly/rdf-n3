RDF::N3 reader/writer
=====================
Notation-3 and Turtle reader/writer for RDF.rb.

Description
-----------
RDF::N3 is an Notation-3 parser for Ruby using the RDF.rb library suite.

Reader inspired from TimBL predictiveParser and Python librdf implementation.

Features
--------
RDF::N3 parses Notation-3, Turtle and N-Triples into statements or triples. It also serializes to Turtle.

* Fully compliant N3-rdf parser
* Also parses Turtle and N-Triples
* Turtle serializer

Install with 'gem install rdf-n3'

Limitations
-----------
* Full support of Unicode input requires Ruby version 1.9 or greater.
* Support for Variables in Formulae dependent on underlying repository. Existential variables are quantified to RDF::Node instances, Universals to RDF::Query::Variable, with the URI of the variable target used as the variable name.
* No support for N3 Reification. If there were, it would be through a :reify option to the reader.

Usage
-----
Instantiate a reader from a local file:

    RDF::N3::Reader.open("etc/foaf.n3") do |reader|
       reader.each_statement do |statement|
         puts statement.inspect
       end
    end

Define @base and @prefix definitions, and use for serialization using :base_uri an :prefixes options

Write a graph to a file:

    RDF::N3::Writer.open("etc/test.n3") do |writer|
       writer << graph
    end

Formulae
--------
N3 Formulae are introduced with the { statmenent-list } syntax. A given formula is assigned an RDF::Node instance, which is also used as the context for RDF::Statement instances provided to RDF::N3::Reader#each_statement. For example, the following N3 generates the associated statements:

    { [ x:firstname  "Ora" ] dc:wrote [ dc:title  "Moby Dick" ] } a n3:falsehood .
  
results in

    f = RDF::Node.new
    s = RDF::Node.new
    o = RDF::Node.new
    RDF::Statement(f, rdf:type n3:falsehood)
    RDF::Statement(s, x:firstname, "Ora", :context => f)
    RDF::Statement(s, dc:wrote, o, :context => f)
    RDF::Statement(o, dc:title, "Moby Dick", :context => f)

Variables
---------
N3 Variables are introduced with @forAll, @forEach, or ?x. Variables reference URIs described in formulae, typically defined in the default vocabulary (e.g., ":x"). Existential variables are replaced with an allocated RDF::Node instance. Universal variables are replaced with a RDF::Query::Variable instance. For example, the following N3 generates the associated statements:

    @forAll <#h>. @forSome <#g>. <#g> <#loves> <#h> .

results in:

    h = RDF::Query::Variable.new(<#h>)
    g = RDF::Node.new()
    RDF::Statement.new(f, <#loves>, h)

Implementation Notes
--------------------
The parser is driven through a rules table contained in lib/rdf/n3/reader/meta.rb. This includes
branch rules to indicate productions to be taken based on a current production. Terminals are denoted
through a set of regular expressions used to match each type of terminal.

The meta.rb file is generated from lib/rdf/n3/reader/n3-selectors.n3
(taken from http://www.w3.org/2000/10/swap/grammar/n3-selectors.n3) which is the result of parsing
http://www.w3.org/2000/10/swap/grammar/n3.n3 (along with bnf-rules.n3) using cwm using the following command sequence:

    cwm n3.n3 bnf-rules.n3 --think --purge --data > n3-selectors.n3

n3-selectors.n3 is itself used to generate meta.rb using script/build_meta.

Dependencies
------------
* [RDF.rb](http://rubygems.org/gems/rdf) (>= 0.3.0)

Resources
---------
* Distiller[http://kellogg-assoc/distiller]
* RDoc[http://rdoc.info/projects/gkellogg/rdf-n3]
* History[http://github.com/gkellogg/rdf-n3/blob/master/History.txt]
* "N3 Specification"[http://www.w3.org/DesignIssues/Notation3.html]
* "N3 Primer"[http://www.w3.org/2000/10/swap/Primer.html]
* "N3 Reification"[http://www.w3.org/DesignIssues/Reify.html]
* Turtle[http://www.w3.org/TeamSubmission/turtle/]
* "RDF Tests"[http://www.w3.org/2000/10/rdf-tests/rdfcore/allTestCases.html]
* "W3C Turtle Test suite"[http://www.w3.org/2000/10/swap/test/regression.n3]

License
-------
(The MIT License)

Copyright (c) 2009-2010 Gregg Kellogg

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

Feedback
--------
* gregg@kellogg-assoc.com
* rubygems.org/rdf-n3
* github.com/gkellogg/rdf-n3
* gkellogg.lighthouseapp.com for bug reports
* public-rdf-ruby mailing list on w3.org