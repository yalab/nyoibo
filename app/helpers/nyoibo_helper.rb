module NyoiboHelper
  def ws_form_for(model, options={}, &block)
    options[:html] ||= {}
    options[:html][:id] ||= 'ws-form'
    output = ''
    output << javascript_tag("var nyoibo =  #{I18n.t('nyoibo').to_json}")
    output << form_for(model, options, &block)
    output << content_tag(:div, '', :id => 'ws-progress')
    output.html_safe
  end
end
