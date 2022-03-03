class AccessGroups::SubgroupsController < ApplicationController
  before_action :require_user_can_crud, only: [:create, :new, :destroy]

  def index
    @access_group = AccessGroup.find_by(id: params[:access_group_id])
    @subgroups = @access_group.subgroups
  end

  def new
    # debugger
    @access_group = AccessGroup.find(params[:access_group_id])
  end

  def create
    @access_group = AccessGroup.find(params[:access_group_id])
    unless @current_user.can_crud_subgroup?(@access_group)
      redirect_to root_url
      return
    end

    
    @subgroup = AccessGroup.new(subgroup_params)

    if @subgroup.save
      redirect_to access_group_subgroups_path(@access_group)
    else
      render 'new'
    end
  end

  
  def destroy
    AccessGroup.find_by(id: params[:id])
            .update_attribute(:parent_id, nil)
    flash[:success]= "Sublocation removed"
    redirect_to access_group_subgroups_path(AccessGroup.find_by(id: params[:access_group_id]))
  end

  private
    def subgroup_params
      sub_params = Hash.new
      sub_params = {parent_id: params[:parent_id], description: params[:description], name: params[:name]}
      return sub_params
    end

    def require_user_can_crud
      access_group = AccessGroup.find(params[:access_group_id])
      unless @current_user.can_crud_subgroup?(access_group)
        flash[:danger]= "You do not have permission to change which groups are in this group!"
        redirect_to access_group_subgroups_path(access_group)
      end
    end
end