module StripeMock
  module RequestHandlers
    module Refunds

      def Refunds.included(klass)
        klass.add_handler 'post /v1/charges/(.*)/refunds', :new_refund
        klass.add_handler 'get /v1/refunds',               :get_refunds
        klass.add_handler 'get /v1/refunds/(.*)',          :get_refund
        klass.add_handler 'post /v1/refunds/(.*)',         :update_refund
      end

      def new_refund(route, method_url, params, headers)
      end

      def get_refund(route, method_url, params, headers)
      end

      def update_refund(route, method_url, params, headers)
      end

      def get_refunds(route, method_url, params, headers)
        params[:limit] ||= 10

        refunds = charges.map { |_, charge| charge[:refunds][:data] }
        refunds = refunds.flatten.sort_by { |charge| charge[:created] }

        Data.mock_list_object(refunds.reverse, params)
      end
    end
  end
end
