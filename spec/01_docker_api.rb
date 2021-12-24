require 'docker_api'

describe DockerApi do

  before(:context) do
    @d = DockerApi.new
  end

  after(:context) {}

  ##############################################################################

  it 'should do some stuff' do
    ret = 1 * 1
    expect(ret == 1).to be(true)
  end

  describe 'retrieval and data validation' do

    it 'should get the catalog of repositories' do
      expect(DockerApi.new.catalog.is_a? Hash).to be(true)
    end
  
    it 'should get the tags listing' do
      expect(DockerApi.new.tags('stocksignals').size > 0).to be(true)
    end
  
    # it 'should pull the manifests' do
    # end
  
    # it 'should get the image digests' do
    # end
  
    # it 'should get the created time for each layer digest' do
    # end
  
    # it 'should transform data into a better structure properly' do
    # end
  
    # it 'should sort the repositories by created_at time properly' do
    # end

  end
  
end
