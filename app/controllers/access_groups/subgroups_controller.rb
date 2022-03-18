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
    @access_group.subgroups << AccessGroup.find_by(id: params[:subgroup_id])
    redirect_to @access_group
  end

  
  def destroy
    AccessGroup.find_by(id: params[:id])
            .update_attribute(:parent_id, nil)
    flash[:success]= "Subgroup removed"
    redirect_to access_group_subgroups_path(AccessGroup.find_by(id: params[:access_group_id]))
  end

  private
    def require_user_can_crud
      access_group = AccessGroup.find(params[:access_group_id])
      unless @current_user.can_crud_subgroup?(access_group)
        flash[:danger]= "You do not have permission to change which groups are in this group!"
        redirect_to access_group_subgroups_path(access_group)
      end
    end
end