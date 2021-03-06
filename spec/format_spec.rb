$:.unshift "."
require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::N3::Format do
  context "discovery" do
    {
      "n3" => RDF::Format.for(:n3),
      "etc/foaf.n3" => RDF::Format.for("etc/foaf.n3"),
      "etc/foaf.ttl" => RDF::Format.for("etc/foaf.ttl"),
      "foaf.n3" => RDF::Format.for(:file_name      => "foaf.n3"),
      "foaf.ttl" => RDF::Format.for(:file_name      => "foaf.ttl"),
      ".n3" => RDF::Format.for(:file_extension => "n3"),
      ".ttl" => RDF::Format.for(:file_extension => "ttl"),
      "text/n3" => RDF::Format.for(:content_type   => "text/n3"),
      "text/rdf+n3" => RDF::Format.for(:content_type   => "text/rdf+n3"),
      "application/rdf+n3" => RDF::Format.for(:content_type   => "application/rdf+n3"),
      "text/turtle" => RDF::Format.for(:content_type   => "text/turtle"),
      "application/turtle" => RDF::Format.for(:content_type   => "application/turtle"),
      "application/x-turtle" => RDF::Format.for(:content_type   => "application/x-turtle"),
    }.each_pair do |label, format|
      it "should discover '#{label}'" do
        format.should == RDF::N3::Format
      end
    end
    
    it "should discover 'notation3'" do
      RDF::Format.for(:notation3).reader.should == RDF::N3::Reader
      RDF::Format.for(:notation3).writer.should == RDF::N3::Writer
    end
    
    it "should discover 'turtle'" do
      RDF::Format.for(:turtle).reader.should == RDF::N3::Reader
      RDF::Format.for(:turtle).writer.should == RDF::N3::Writer
    end
    
    it "should discover 'ttl'" do
      RDF::Format.for(:ttl).reader.should == RDF::N3::Reader
      RDF::Format.for(:ttl).writer.should == RDF::N3::Writer
    end
  end
end
