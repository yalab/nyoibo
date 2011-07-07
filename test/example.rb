require File.expand_path('../test_helper', __FILE__)
require File.expand_path('../../app/helpers/nyoibo_helper', __FILE__)
require 'sinatra'
require 'sinatra/reloader'
require 'action_view'
require 'active_model'
require 'coffee-script'
include ActionView::Helpers::FormHelper
extend NyoiboHelper

class Post
  extend ActiveModel::Naming
  attr_accessor :file

  include Nyoibo::Callback
  after_upload "/" do |params, binary|
    File.open('/tmp/test.jpg', 'w:binary') do |f|
      f.write(binary)
    end

    File.open('/tmp/test.json', 'w:binary') do |f|
      f.write(params)
    end
  end
  before_upload "/" do |params|
    params['name'] == "yalab"
  end
end
Nyoibo.configure do
  host 'localhost'
  port 3030
end
Process.fork do
  Nyoibo.run
end


set :public, File.expand_path('../../vendor/web-socket-js', __FILE__)

get '/' do
  @post = Post.new
  erubis <<EOS
<!DOCTYPE html>
<html>
<head>
<title>nyoibo</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
<script src="/swfobject.js"></script>
<script src="/web_socket.js"></script>
<script>
#{File.read File.open(File.expand_path("../../vendor/html5jp/progress.js", __FILE__))}
</script>

<script>
#{CoffeeScript.compile(File.read(File.expand_path('../../lib/generators/nyoibo/templates/nyoibo.js.coffee', __FILE__)))}
</script>
</head>
<body>


<form id="ws-form">
  <input type="file">
  <input type="submit">
  <input type="text" name="name" value="yalab">
</form>
<div id="ws-progress"></div>
</body>
EOS

end
