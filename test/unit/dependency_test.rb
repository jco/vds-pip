#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

require 'test_helper'

class DependencyTest < ActiveSupport::TestCase

  test "simple legal case" do
    a = stub_document()
    b = stub_document()
    assert(a.save && b.save)

    assert(Dependency.is_legal?(:from => a, :to => b), "False positive")
  end
  
  test "smallest loop" do
    a = stub_document()
    assert(a.save)

    assert(!Dependency.is_legal?(:from => a, :to => a), "Uncaught illegal dependency")
  end

  test "second-smallest loop" do
    a = stub_document()
    b = stub_document()
    assert(a.save && b.save)

    dep = Dependency.from(a, :to => b)
    assert(dep.save)

    assert(!Dependency.is_legal?(:from => b, :to => a), "Uncaught illegal dependency.")
  end

  test "something more complicated" do
    f = stub_folder()
    d = stub_document(f)
    assert(f.save)
    
    assert(!Dependency.is_legal?(:from => d, :to => f))
    assert(!Dependency.is_legal?(:from => f, :to => d))
  end

  test "something else complicated" do
    f = stub_folder()
    df = stub_document(f)
    assert(f.save)

    d = stub_document()
    assert(d.save)

    dep = Dependency.from(f, :to => d)
    assert(dep.save)

    assert(!Dependency.is_legal?(:from => d, :to => f), "uncaught")
  end

  def stub_document(folder = nil)
    document = Document.new(:name => "blah", :versions => [Version.new(:external_url => "http://google.com/")])
    if folder
      document.folder = folder
    else
      document.project = Project.first
    end
    document
  end

  def stub_folder()
    Project.first.folders.new(:name => "blah")
  end

end
