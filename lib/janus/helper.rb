module JanusHelper
  def janus_error_messages
    return "" if resource.errors.empty?
    
    content_tag :div, :id => 'error_explanation' do
      content_tag :ul do
        resource.errors.full_messages.map { |message| content_tag :li, message }.join.html_safe
      end
    end
  end
end
