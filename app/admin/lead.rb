ActiveAdmin.register Lead do
  scope :unsent

  scope :template_1 do |scope|
    scope.with_template('template1')
  end

  scope :template_2 do |scope|
    scope.with_template('template2')
  end
end
