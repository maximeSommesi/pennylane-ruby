module Pennylane
  class SupplierInvoice < Resources::Base

    class << self

      def object_name
        'supplier_invoice'
      end

      def list filters = {}, opts = {}
        normalize_filters(filters)
        request_pennylane_object(method: :get, path: "/supplier_invoices", params: { query: filters }, opts: opts, with: { invoice: 'supplier_invoice' })
      end

      def retrieve id, opts = {}
        request_pennylane_object(method: :get, path: "/supplier_invoices/#{id}", params: {}, opts: opts, with: { invoice: 'supplier_invoice' })
      end

      def import params, opts={}
        request_pennylane_object(method: :post, path: "/supplier_invoices/import", params: { body: params }, opts: opts, with: { invoice: 'supplier_invoice' })
      end

      def update(id, attributes)
        resp, opts = self.class.request_pennylane_object(method: :put,
                                                         path: "/supplier_invoices/#{id}",
                                                       params: { body: { 'invoice' => attributes } },
                                                       opts: {}, with: { invoice: 'supplier_invoice' })
      @values = resp.instance_variable_get :@values
        self
      end

    end

    # since object name is different from the class name, we need to override the object_name method
    def object
      @values[:invoice]
    end

    # doesnt have a `source_id` so we override it
    def id
      object.id
    end

    # API CALLS

    # since object name is different from the class name, we need to override the method




    private

    # When API returns an empty body
    # so we need to skip values assignment from the response
    # GET /supplier_invoices/:id again to get the updated values
    def request_and_retrieve(method:, path:, action:)
      self.class.request_pennylane_object(method: method,
                                          path: "#{path}/#{action}",
                                          params: {},
                                          opts: {}, with: { invoice: 'supplier_invoice' })
      resp, opts = self.class.request_pennylane_object(method: :get,
                                                       path: path,
                                                       params: {},
                                                       opts: {}, with: { invoice: 'supplier_invoice' })
      @values = resp.instance_variable_get :@values
      self
    end
  end
end
