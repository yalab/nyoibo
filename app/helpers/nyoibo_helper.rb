module NyoiboHelper
  def ws_form_for(model, options={}, &block)
    options[:html] ||= {}
    options[:html][:id] ||= 'ws-form'
    output = ''
    output << javascript_tag(<<EOS)
  WEB_SOCKET_DEBUG = true;
  WEB_SOCKET_SWF_LOCATION = '/WebSocketMain.swf';
  var nyoibo =  #{I18n.t('nyoibo').to_json};
EOS
    output << form_for(model, options, &block)
    output << content_tag(:div, '', :id => 'ws-progress')
    output.html_safe
  end
end
