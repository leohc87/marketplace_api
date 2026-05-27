<<<<<<< HEAD
# frozen_string_literal: true

class ApiConstraints
  attr_accessor :version, :default

  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers[:Accept]&.include?("application/vnd.marketplace.v#{@version}")
  end
end
=======
class ApiConstraints
  attr_accessor :version, :default

  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
  @default || req.headers[:Accept]&.include?("application/vnd.marketplace.v#{@version}")
end
end
>>>>>>> 3d51741 (Adiciona constraints and manager to version api)
