  module Pennylane
    class PlanItem < Resources::Base

      class << self

        def list filters = {}, opts = {}
          normalize_filters(filters)
          request_pennylane_object(method: :get, path: "/plan_items", params: { query: filters }, opts: opts)
        end

        def create params, opts = {}
          request_pennylane_object(method: :post, path: "/plan_items", params: { body: { plan_item: params } }, opts: opts)
        end

      end

    end
  end
