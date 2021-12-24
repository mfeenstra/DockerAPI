# lib/docker_api.rb

require 'json'

# set the host environment variable 'DOCKER_REGISTRY', or constant:
DOCKER_REGISTRY = 'dcr.feenstra.io:5000'
API = 'v2'

################################################################################
# DockerApi - A Ruby interface for the Docker Container Registry.              #
#   matt.a.feenstra@gmail.com                                                  #
#   licensed under GPLv3, copyright 2022, all rights reserved.                 #
################################################################################
# Parameter: Nil or String -> 1 Repo (image) Name

# Methods (DockerApi.new):
#   tags(repo)
#   history(repo, tag)
#   id(repo, tag
#   created_at(repo, tag)
#   parent(repo, tag)
#   digest(repo, tag)
#   perform -> creates @struct
#
# -> Use perform to create @struct (
#  ->  try Dockerdump_struct to print it out
#
# Data is transformed like the following (in dockerapi.struct):
#   @struct = { Image_1_Name =>
#               [
#                 [ tag1_name, created_at_time, id, digest, parent ],
#                 [ tag2_name, created_at_time, id, digest, parent ],
#                 ...
#                 [ latest, created_at, image ID, digest hex, parent hex ]
#               ],
#
#               Image_2_name =>
#               [
#                 [..],
#                 ...
#               ],
#               ...
#             }
#
# Reccommended Usage:
#   - dockerapi.perform
#   - dockerapi.struct.to_yaml
# Or:
#   - new_data = DockerApi.new.perform
#   - puts new_data.to_yaml
################################################################################

class DockerApi

  attr_reader :struct, :repos, :catalog, :registry_host, :tagdata

  def initialize(repo = nil)
    @registry_host = DOCKER_REGISTRY
    @registry_host = ENV['DOCKER_REGISTRY'] if ENV['DOCKER_REGISTRY']
    @repos = []
    @struct = {}
    @tagdata = {}
    @catalog = get_catalog
    if repo.nil?
      @repos = @catalog['repositories']
    else
      @repos << repo
    end
    @repos.each { |r| @struct[r] = {} }
  end

  def perform
    begin
      @repos.each do |image|
        mytags = tags(image)
        @struct[image] = []

        mytags.each do |tag|
          @struct[image] << [ tag,
                              created_at(image, tag),
                              digest(image, tag),
                              parent(image, tag)
                            ]
        end
      end
      return @struct
    rescue => e
      puts e.full_message
      return false
    end
  end

  # each registry has many repositories (images),
  # each repository has many tags (latest, 1.0, etc..),
  # each tag is a layer with a digest / ID and creation time.

  def tags(repo)
    @tagdata[repo] = curl(repo, 'tags/list')['tags']
  end

  def history(repo, tag)
    if ( output = curl(repo, "manifests/#{tag}") ) &&
         !output['history'].nil?
      return JSON.parse((output['history'].first)['v1Compatibility'])
    else
      return 'none'
    end
  end

  def id(repo, tag)
    history(repo, tag)['id']
  end

  def created_at(repo, tag)
    history(repo, tag)['created']
  end

  def parent(repo, tag)
    begin
      return history(repo, tag)['parent']
    rescue
      return 'none'
    end
  end

  def digest(repo, tag)
    begin
      mydigest = history(repo, tag)['config']['Image']
      unless mydigest.nil? then return mydigest else return 'none' end
    rescue
      return 'none'
    end
  end

  ##############################################################################
  private

  def curl(repo, path)
    loc = "#{@registry_host}/#{API}/#{repo}/#{path}"
    begin
      JSON.parse(`curl -s -k #{loc}`)
    rescue => e
      puts e.message
      return 'none'
    end
  end

  def get_catalog(path = '_catalog')
    loc = "#{@registry_host}/#{API}/#{path}"
    # puts loc
    begin
      JSON.parse(`curl -s -k #{loc}`)
    rescue => e
      puts e.message
      return 'none'
    end
  end

end
