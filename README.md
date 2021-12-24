# DockerApi - A Ruby Class as an interface to Docker Container Registry.

matt.a.feenstra@gmail.com                                                  #

copyright 2022, all rights reserved.      

-----

### Note that the terms "repo", "repository", and "image" are synonymous for the container images held by the REGISTRY.  The idioms used by Docker can be confusing and interchangeable.

## Configuration:

   - 'DOCKER_REGISTRY' environment variable

   - hard code the constant 'DOCKER_REGISTRY'

## Parameter(s):

   - none or 1 image name (String)

## Methods (DockerApi.new):

   - tags(repo) -> get all versions for an image (repo)

   - history(repo, tag) -> data dump for an image

   - id(repo, tag) -> ID for the image

   - created_at(repo, tag) -> Timestamp of creation for the version of an image

   - parent(repo, tag) -> gives the ID for the parent image

   - digest(repo, tag) -> gives the unique digest hash for configuration json describing image

   - perform -> creates @struct with all the above data (easier to work with than the OEM)


### Do this: ->`perform` to create `@struct`

#### Data is transformed like the following in @struct:

```ruby

   @struct = { 
               Image_1_Name =>

                 [
                   [ tag1_name, created_at_time, id, digest, parent ],
                   [ tag2_name, created_at_time, id, digest, parent ],
                   ...
                   [ latest, created_at, image ID, digest hex, parent hex ]
                 ],

               Image_2_name =>

                 [
                   [..],
                   ..
                 ],
               ...
             }
```

## Recommended Usage:

Get the Docker data in the above Hash

```ruby

>> new_data = DockerApi.new.perform

```

### Gives me:

```ruby

{"app_a"=>
  [["latest",
    "2021-09-17T22:26:08.6965245Z",
    "sha256:7b64f2e2d0e4893141dae2a0c9c30316cf02a3c2ddff32e2b9f725941fedd6f9",
    "70827fc54528b712dfee872734db3ab62c6a7c8ba9ee88c086838af698bbc74f"]],
 "app_b"=>
  [["latest",
    "2021-09-17T22:31:09.708856703Z",
    "sha256:1c6326fd96ff3e5ed94c78ddf40f243f60608a8be931a9e0fb22d517498bacd3",
    "524e86d0e8413199ea80eb7593b166d3fbabb725da9d527dc8611f1e54f6055f"]],
 "appserver"=>
  [["0.01", "2021-10-02T10:10:05.00999523Z", "dcr.feenstra.io:5000/base:0.10", "90024c617502c10c6fc53ab6924be496193858bc4089562484939a723ef34870"],
   ["1.1", "2021-10-02T13:01:12.45416866Z", "dcr.feenstra.io:5000/base:0.10", "90024c617502c10c6fc53ab6924be496193858bc4089562484939a723ef34870"],
   ["1.2", "2021-10-02T22:11:42.278711997Z", "dcr.feenstra.io:5000/appserver:1.1", "5a3ddcc730a38c6d256547aa518fac0714df0827f38232fc60af56af123bd322"]],
 "base"=>
  [["0.01", "2021-10-01T01:38:34.275517947Z", "marketmath:0.11", "020b25a2b9d4b3424b945c321f68bf0ab781cd6a252a29091cdd5bbc8aabab12"],
   ["0.03", "2021-10-01T07:52:55.180931746Z", "cfa83f56d978", "668acd2443212738e8f923e113915793131cbb92809248d60d227e02252589bd"],
   ["0.29",
    "2021-10-24T09:45:41.764262356Z",
    "sha256:e1df959c2f4ebf6518af9c95aeb13bac64f679ad1fe769c4ad6b1621eb266815",
    "c66ebc226e27f963ea89613993c2e45e13f7e51e303234b9d08f6e209c4fabfb"],
   ["latest",
    "2021-11-05T12:11:35.398547848Z",
    "sha256:65e0b495d07151e9fbeae51e1a3b43efdfe5414949aa444c953ea14e841f7a78",
    "4c40127e6d396b67a7389282b8638a10bc710ac28a07788c9a5fa1ae5f993a53"],
   ["0.30",
    "2021-10-24T10:08:25.256876108Z",
    "sha256:ac6e77062b9a8cdd185180551ce808f4fc08589c737228aa0835dd76757d6696",
    "668cba372a378c03f5fe3aff64942ab3de48bbd6a5b7c0823d57e6f24c42bda7"],
   ["2.02",
    "2021-11-04T00:27:01.478615551Z",
    "sha256:760a1066c371733a6768f0b049b7b4283001e0ce17d5b79c5a5a46639050a973",
    "91b0664b002f16e6508944344c3dbc0d5a3fde7d14218e9858d8c92dcd835d07"],
   ["2.07",
    "2021-11-05T12:11:35.398547848Z",
    "sha256:65e0b495d07151e9fbeae51e1a3b43efdfe5414949aa444c953ea14e841f7a78",
    "4c40127e6d396b67a7389282b8638a10bc710ac28a07788c9a5fa1ae5f993a53"]],
 "base-systemd"=>
...to be continued.

```

### and as YAML:


```ruby

>> puts new_data.to_yaml

```

```yaml

---
app_a:
- - latest
  - '2021-09-17T22:26:08.6965245Z'
  - sha256:7b64f2e2d0e4893141dae2a0c9c30316cf02a3c2ddff32e2b9f725941fedd6f9
  - 70827fc54528b712dfee872734db3ab62c6a7c8ba9ee88c086838af698bbc74f
app_b:
- - latest
  - '2021-09-17T22:31:09.708856703Z'
  - sha256:1c6326fd96ff3e5ed94c78ddf40f243f60608a8be931a9e0fb22d517498bacd3
  - 524e86d0e8413199ea80eb7593b166d3fbabb725da9d527dc8611f1e54f6055f
appserver:
- - '0.01'
  - '2021-10-02T10:10:05.00999523Z'
  - dcr.feenstra.io:5000/base:0.10
  - 90024c617502c10c6fc53ab6924be496193858bc4089562484939a723ef34870
- - '1.1'
  - '2021-10-02T13:01:12.45416866Z'
  - dcr.feenstra.io:5000/base:0.10
  - 90024c617502c10c6fc53ab6924be496193858bc4089562484939a723ef34870
- - '1.2'
  - '2021-10-02T22:11:42.278711997Z'
  - dcr.feenstra.io:5000/appserver:1.1
  - 5a3ddcc730a38c6d256547aa518fac0714df0827f38232fc60af56af123bd322
base:
- - '0.01'
  - '2021-10-01T01:38:34.275517947Z'
  - marketmath:0.11
  - 020b25a2b9d4b3424b945c321f68bf0ab781cd6a252a29091cdd5bbc8aabab12
- - '0.03'
  - '2021-10-01T07:52:55.180931746Z'
  - cfa83f56d978
  - 668acd2443212738e8f923e113915793131cbb92809248d60d227e02252589bd
- - '0.29'
  - '2021-10-24T09:45:41.764262356Z'
  - sha256:e1df959c2f4ebf6518af9c95aeb13bac64f679ad1fe769c4ad6b1621eb266815
  - c66ebc226e27f963ea89613993c2e45e13f7e51e303234b9d08f6e209c4fabfb
- - latest
  - '2021-11-05T12:11:35.398547848Z'
  - sha256:65e0b495d07151e9fbeae51e1a3b43efdfe5414949aa444c953ea14e841f7a78
  - 4c40127e6d396b67a7389282b8638a10bc710ac28a07788c9a5fa1ae5f993a53
- - '0.30'
  - '2021-10-24T10:08:25.256876108Z'
  - sha256:ac6e77062b9a8cdd185180551ce808f4fc08589c737228aa0835dd76757d6696
  - 668cba372a378c03f5fe3aff64942ab3de48bbd6a5b7c0823d57e6f24c42bda7
- - '2.02'
  - '2021-11-04T00:27:01.478615551Z'
  - sha256:760a1066c371733a6768f0b049b7b4283001e0ce17d5b79c5a5a46639050a973
  - 91b0664b002f16e6508944344c3dbc0d5a3fde7d14218e9858d8c92dcd835d07
- - '2.07'
  - '2021-11-05T12:11:35.398547848Z'
  - sha256:65e0b495d07151e9fbeae51e1a3b43efdfe5414949aa444c953ea14e841f7a78
  - 4c40127e6d396b67a7389282b8638a10bc710ac28a07788c9a5fa1ae5f993a53
base-systemd:
- - '0.04'
  - '2021-09-30T04:29:53.99867694Z'
  - sha256:b7f70d3efb46b8e7865e65c20fad4cf5bbbdb67549849d0ceaf19d6e1006a2e8
  - 66ab6c384fe3d3f38792173b311a68e567ed0afe0d22ec45ad30713a66140e8c
- - latest
  - '2021-09-30T04:29:53.99867694Z'
  - sha256:b7f70d3efb46b8e7865e65c20fad4cf5bbbdb67549849d0ceaf19d6e1006a2e8
  - 66ab6c384fe3d3f38792173b311a68e567ed0afe0d22ec45ad30713a66140e8c
baseimage:
- - latest
  - '2021-09-29T04:41:46.521084644Z'
  - 73656f4683c5
  - 227953705d9676c3db10636668ec8edd9a22c432b5d4003074ef54f526eb059f
baseimage-appserver:
- - latest
  - '2021-09-29T02:57:19.007048713Z'
  - sha256:92ee6cecde2dc950e611d8c0122277da1591f688c0a4c0ccd89d75b401349109
  - 84b31c4f93460ff9f048d36d75dcf04e077ec7719c4536c919c0b292d175699f
basic-systemd:
- - centos8
  - '2021-10-21T09:12:03.056390352Z'
  - dcr.feenstra.io:5000/my-centos
  - ba1cc918537dd2958824a33ee53da0ee53b392a973e8b6a674f975abe3051fc0

...to be continued.

```

-----

### Another example:

```ruby

dockerapi = DockerApi.new

dockerapi.perform

puts dockerapi.struct.to_yaml

```
### Outputs something like:

```ruby

{"app_a"=>[["latest", "2021-09-17T22:26:08.6965245Z", "sha256:7b64f2e2d0e4893141dae2a0c9c30316cf02a3c2ddff32e2b9f725941fedd6f9", "70827fc54528b712dfee872734db3ab62c6a7c8ba9ee88c086838af698bbc74f"]],
 "app_b"=>[["latest", "2021-09-17T22:31:09.708856703Z", "sha256:1c6326fd96ff3e5ed94c78ddf40f243f60608a8be931a9e0fb22d517498bacd3", "524e86d0e8413199ea80eb7593b166d3fbabb725da9d527dc8611f1e54f6055f"]],
 "appserver"=>
  [["0.01", "2021-10-02T10:10:05.00999523Z", "dcr.feenstra.io:5000/base:0.10", "90024c617502c10c6fc53ab6924be496193858bc4089562484939a723ef34870"],
   ["1.1", "2021-10-02T13:01:12.45416866Z", "dcr.feenstra.io:5000/base:0.10", "90024c617502c10c6fc53ab6924be496193858bc4089562484939a723ef34870"],
   ["1.2", "2021-10-02T22:11:42.278711997Z", "dcr.feenstra.io:5000/appserver:1.1", "5a3ddcc730a38c6d256547aa518fac0714df0827f38232fc60af56af123bd322"]],
 "base"=>
  [["0.01", "2021-10-01T01:38:34.275517947Z", "marketmath:0.11", "020b25a2b9d4b3424b945c321f68bf0ab781cd6a252a29091cdd5bbc8aabab12"],
   ["0.03", "2021-10-01T07:52:55.180931746Z", "cfa83f56d978", "668acd2443212738e8f923e113915793131cbb92809248d60d227e02252589bd"],
   ["0.29", "2021-10-24T09:45:41.764262356Z", "sha256:e1df959c2f4ebf6518af9c95aeb13bac64f679ad1fe769c4ad6b1621eb266815", "c66ebc226e27f963ea89613993c2e45e13f7e51e303234b9d08f6e209c4fabfb"],
   ["latest", "2021-11-05T12:11:35.398547848Z", "sha256:65e0b495d07151e9fbeae51e1a3b43efdfe5414949aa444c953ea14e841f7a78", "4c40127e6d396b67a7389282b8638a10bc710ac28a07788c9a5fa1ae5f993a53"],
   ["0.30", "2021-10-24T10:08:25.256876108Z", "sha256:ac6e77062b9a8cdd185180551ce808f4fc08589c737228aa0835dd76757d6696", "668cba372a378c03f5fe3aff64942ab3de48bbd6a5b7c0823d57e6f24c42bda7"],
   ["2.02", "2021-11-04T00:27:01.478615551Z", "sha256:760a1066c371733a6768f0b049b7b4283001e0ce17d5b79c5a5a46639050a973", "91b0664b002f16e6508944344c3dbc0d5a3fde7d14218e9858d8c92dcd835d07"],
   ["2.07", "2021-11-05T12:11:35.398547848Z", "sha256:65e0b495d07151e9fbeae51e1a3b43efdfe5414949aa444c953ea14e841f7a78", "4c40127e6d396b67a7389282b8638a10bc710ac28a07788c9a5fa1ae5f993a53"]],

...to be continued.


```
