module NyoiboHelper
  def ws_form_for(model, options={}, &block)
    options[:html] ||= {}
    options[:html][:id] ||= 'ws-form'
    form_for(model, options, &block) + content_tag(:div, '', :id => 'ws-progress')
  end
end
