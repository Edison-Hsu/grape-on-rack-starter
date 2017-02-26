class Service
  def self.application
    @instance ||= Rack::Builder.new do
      use Rack::Cors do
        allow do
          origins '*'
          resource '*', headers: :any, methods: :get
        end
      end

      use Rack::MethodOverride

      run Root
    end
  end
end
