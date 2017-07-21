class DefaultPagesController < ApplicationController
  before_filter :require_admin
  
  def index
      @default_pages = DefaultPage.all
  end

  def show
    @default_page = DefaultPage.find(params[:id])
  end
  
  def new
    @default_page = DefaultPage.new
  end
  
  def create
    if params[:cancel_button]
      redirect_to default_pages_url
    else
      @default_page = DefaultPage.new(default_page_params)
      if @default_page.save
        flash_message :notice, "Default Page Created"
        redirect_to default_pages_url
      else
        flash_message :error, "Default Page Creation Failed"
        render :action => :new
      end
    end
  end
  
  def edit
    @default_page = DefaultPage.find(params[:id])
  end

  def update
    @default_page = DefaultPage.find(params[:id])
    if params[:cancel_button]
      redirect_to default_pages_url
    else
      if @default_page.update_attributes(default_page_params)
        flash_message :notice, "Default Page updated"
        redirect_to default_pages_url
      else
        render :action => :edit
      end
    end
  end
  
  private
    def default_page_params
      params.require(:default_page).permit(:site_name, :page_name, :page_head, 
        :page_subhead, :page_text1, :page_text2, :page_text3, :email_contact)
    end
end
