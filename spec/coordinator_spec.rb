require 'helper'

describe Coordinator do
  it 'should not allow empty graphs' do
    lambda { Coordinator.new([]) }.should raise_error
  end

  let(:graph) do
    [
      AddVertex.new(:igvita,     1,  :wikipedia),
      AddVertex.new(:wikipedia,  2,  :google),
      AddVertex.new(:google,     1,  :wikipedia)
    ]
  end

  it 'should partition graphs with variable worker sizes' do
    c = Coordinator.new(graph)
    c.workers.size.should == 1

    c = Coordinator.new(graph, partitions: 2)
    c.workers.size.should == 2
  end

  it 'should schedule workers to run until there are no active vertices' do
    c = Coordinator.new(graph)
    c.run

    c.workers.each do |w|
      w.vertices.each do |v|
        v.value.should == 5
      end
    end
  end

  it 'should parition nodes by hashing the node id'
  it 'should allow scheduling multiple partitions to a single worker'
end