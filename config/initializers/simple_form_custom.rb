# Customized BS3 markup for symantic responsive forms
SimpleForm.setup do |config|
  config.default_wrapper = :basic
  config.label_class = "control-label"
  config.error_notification_class = nil

  config.wrappers :basic, tag: 'div', class: 'form-group', error_class: 'warning' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :input_group, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: "controls" do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |append|
        append.use :input, class: 'form-control'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  # Control group for display of a record without controls
  config.wrappers :text_only_more_info, :tag => 'div', :class => 'form-group' do |b|
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |ba|
      ba.use :input
      ba.use :hint, :wrap_with => { :tag => 'div', :class => 'help-block more-info' }
    end
  end
end
