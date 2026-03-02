module Api
  module V1
    class ContactsController < ApplicationController

      # GET /api/v1/contact
      def index
        page = (params[:page] || 1).to_i
        per_page = [[(params[:per_page] || 10).to_i, 1].max, 100].min

        total = ::Contact.count
        total_pages = (total.to_f / per_page).ceil

        contacts = ::Contact.order(id: :desc)
                            .offset((page - 1) * per_page)
                            .limit(per_page)

        meta = {
          page: page,
          per_page: per_page,
          total_pages: total_pages,
          total_count: total
        }

        render_ok(data: contacts.as_json, meta: meta)
      end

      # POST /api/v1/contact
      def create
        contact = ::Contact.new(contact_params)

        if contact.save
          render_ok(
            data: contact.as_json,
            message: "Contact created",
            status: :created
          )
        else
          render_error(
            message: "Validation failed",
            status: :unprocessable_entity,
            errors: contact.errors
          )
        end
      end

      # PUT /api/v1/contact
      def update
        return render_error(message: "Missing id", status: :bad_request) if params[:id].blank?

        contact = ::Contact.find_by(id: params[:id])
        return render_error(message: "Contact not found", status: :not_found) if contact.nil?

        if contact.update(contact_params)
          render_ok(data: contact.as_json, message: "Contact updated")
        else
          render_error(
            message: "Validation failed",
            status: :unprocessable_entity,
            errors: contact.errors
          )
        end
      end

      # DELETE /api/v1/contact
      def destroy
        return render_error(message: "Missing id", status: :bad_request) if params[:id].blank?

        contact = ::Contact.find_by(id: params[:id])
        return render_error(message: "Contact not found", status: :not_found) if contact.nil?

        contact.destroy
        render_ok(data: { id: params[:id].to_i }, message: "Contact deleted")
      end

      private

      def contact_params
        params.permit(:first_name, :last_name, :phone, :email)
      end

      # ---- Response helpers ----

      def render_ok(data: nil, message: "OK", meta: nil, status: :ok)
        render json: {
          success: true,
          code: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
          message: message,
          data: data,
          meta: meta
        }, status: status
      end

      def render_error(message:, status:, errors: nil)
        render json: {
          success: false,
          code: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
          message: message,
          errors: errors
        }, status: status
      end

    end
  end
end
