class Admin::CustomerDocumentsController < Admin::ApplicationController
  before_action :set_customer
  before_action :set_document, only: [:show, :destroy]

  # GET /admin/customers/:customer_id/documents
  def index
    @documents = @customer.documents.order(:created_at)
  end

  # POST /admin/customers/:customer_id/documents
  def create
    @document = @customer.documents.build(document_type: document_params[:document_type])

    if @document.save
      # Handle file upload to R2
      if params[:customer_document][:document_file].present?
        result = @document.upload_to_r2(params[:customer_document][:document_file])

        if result.is_a?(Hash) && result[:success]
          render json: {
            success: true,
            message: 'Document uploaded successfully!',
            document: {
              id: @document.id,
              name: @document.document_name,
              type: @document.document_type,
              size: @document.document_size,
              url: @document.document_url
            }
          }
        else
          @document.destroy
          error_message = result.is_a?(Hash) ? result[:error] : 'Upload failed'
          render json: {
            success: false,
            message: "Upload failed: #{error_message}",
            errors: @document.errors.full_messages
          }, status: :unprocessable_entity
        end
      else
        @document.destroy
        render json: {
          success: false,
          message: 'No file provided',
          errors: ['Document file is required']
        }, status: :unprocessable_entity
      end
    else
      render json: {
        success: false,
        message: 'Failed to create document record',
        errors: @document.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # DELETE /admin/customers/:customer_id/documents/:id
  def destroy
    # Delete from R2 first
    @document.delete_from_r2 if @document.has_file?

    if @document.destroy
      render json: {
        success: true,
        message: 'Document deleted successfully!'
      }
    else
      render json: {
        success: false,
        message: 'Failed to delete document'
      }, status: :unprocessable_entity
    end
  end

  # GET /admin/customers/:customer_id/documents/:id/download
  def download
    document = @customer.documents.find(params[:id])
    if document.has_file?
      redirect_to document.document_url, allow_other_host: true
    else
      redirect_to admin_customer_path(@customer), alert: 'Document not found'
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_document
    @document = @customer.documents.find(params[:id])
  end

  def document_params
    params.require(:customer_document).permit(:document_type, :document_file)
  end
end