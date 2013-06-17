# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :bootstrap, :tag => 'div', :class => 'control-group', :error_class => 'warning' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |ba|
      ba.use :input
      ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
      ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help' }
    end
  end

  config.wrappers :prepend, :tag => 'div', :class => "control-group", :error_class => 'warning' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |input|
      input.wrapper :tag => 'div', :class => 'input-prepend' do |prepend|
        prepend.use :input
      end
      input.use :hint,  :wrap_with => { :tag => 'p', :class => 'help' }
      input.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
    end
  end

  config.wrappers :append, :tag => 'div', :class => "control-group", :error_class => 'warning' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |input|
      input.wrapper :tag => 'div', :class => 'input-append' do |append|
        append.use :input
      end
      input.use :hint,  :wrap_with => { :tag => 'p', :class => 'help' }
      input.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
    end
  end

  # Control group for display of a record without controls. Hint is optional.
  config.wrappers :readonly, :tag => 'div', :class => 'control-group readonly' do |b|
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |ba|
      ba.use :input
      ba.use :hint, :wrap_with => { :tag => 'div', :class => 'help change-info' }
    end
  end

  config.default_wrapper = :bootstrap
end
