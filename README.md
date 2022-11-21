# rocketmq-client-ruby

A Ruby FFI binding to [librocketmq](https://github.com/apache/rocketmq-client-cpp).


## Prerequisites

### Install `librocketmq`
rocketmq-client-python is a lightweight wrapper around [rocketmq-client-cpp](https://github.com/apache/rocketmq-client-cpp), so you need install 
`librocketmq` first.

#### Download by binary release.
download specific release according you OS: [rocketmq-client-cpp-2.0.0](https://github.com/apache/rocketmq-client-cpp/releases/tag/2.0.0)
- centos
    
    take centos7 as example, you can install the library in centos6 by the same method.
    ```bash
        wget https://github.com/apache/rocketmq-client-cpp/releases/download/2.0.0/rocketmq-client-cpp-2.0.0-centos7.x86_64.rpm
        sudo rpm -ivh rocketmq-client-cpp-2.0.0-centos7.x86_64.rpm
    ```
- debian
    ```bash
        wget https://github.com/apache/rocketmq-client-cpp/releases/download/2.0.0/rocketmq-client-cpp-2.0.0.amd64.deb
        sudo dpkg -i rocketmq-client-cpp-2.0.0.amd64.deb
    ```
- macOS
    ```bash
        wget https://github.com/apache/rocketmq-client-cpp/releases/download/2.0.0/rocketmq-client-cpp-2.0.0-bin-release.darwin.tar.gz
        tar -xzf rocketmq-client-cpp-2.0.0-bin-release.darwin.tar.gz
        cd rocketmq-client-cpp
        mkdir /usr/local/include/rocketmq
        cp include/* /usr/local/include/rocketmq
        cp lib/* /usr/local/lib
        install_name_tool -id "@rpath/librocketmq.dylib" /usr/local/lib/librocketmq.dylib
    ```
#### Build from source
you can also build it manually from source according to [Build and Install](https://github.com/apache/rocketmq-client-cpp/tree/master#build-and-install)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rocketmq-client-ruby'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install rocketmq-client-ruby
```

## Usage

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/edmondfrank/rocketmq-client-ruby>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Community Guidelines](https://docs.chef.io/community_guidelines.html) code of conduct.

## License

- License::Apache License, Version 2.0
