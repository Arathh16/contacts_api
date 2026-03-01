module Api
  module V1
    class ContactsController < ApplicationController
      def index
        page = (params[:page] || 1).to_i
        per_page = [[(params[:per_page] || 10).to_i, 1].max, 100].min

        total = ::Contact.count
        total_pages = [(total.to_f / per_page).ceil, 1].max

        contacts = ::Contact.order(id: :desc)
                            .offset((page - 1) * per_page)
                            .limit(per_page)

        meta = { page: page, per_page: per_page, total_pages: total_pages, total_count: total }
        render_ok(data: contacts.as_json, meta: meta)
      end

      def create
        contact = ::Contact.new(contact_params)
        if contact.save
          render_ok(data: contact.as_json, message: "Contact created", status: :created)
        else
          render_error(message: "Validation failed", status: :unprocessable_entity, errors: contact.errors)
        end
      end

      def update
        return render_error(message: "Missing id", status: :bad_request) if params[:id].blank?

        contact = ::Contact.find_by(id: params[:id])
        return render_error(message: "Contact not found", status: :not_found) if contact.nil?

        if contact.update(contact_params)
          render_ok(data: contact.as_json, message: "Contact updated")
        else
          render_error(message: "Validation failed", status: :unprocessable_entity, errors: contact.errors)
        end
      end

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
    end
  end
end
