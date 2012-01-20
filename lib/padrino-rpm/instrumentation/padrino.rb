require 'new_relic/agent/instrumentation/controller_instrumentation'

DependencyDetection.defer do
  depends_on do
    defined?(::Padrino)
  end
  
  executes do
    Padrino::Application.class_eval do
      include PadrinoRpm::Instrumentation::Padrino
    end
  end
end

module PadrinoRpm
  module Instrumentation
    module Padrino
      include NewRelic::Agent::Instrumentation::ControllerInstrumentation
      
      def route_eval(&block)
        
        perform_action_with_newrelic_trace(:category => :controller, :path => request.path, :params => request.params)  do
          route_eval_without_newrelic(&block) # RPM loads the sinatra plugin too eagerly
        end
      end

    end #PadrinoRpm::Instrumentation::Padrino
  end
end

DependencyDetection.detect!
