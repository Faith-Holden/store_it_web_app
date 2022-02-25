module AccessGroups
  class AccessGroupsController < ApplicationController
    before_action :crud_authorization, except: :index
     def new
       @access_group = AccessGroup.new
       @current_user = current_user
       @access_groups = @current_user.groups_user_can_crud_subgroup
     end
 
     def create
       @access_group = AccessGroup.new(group_params)
       if @access_group.save
         redirect_to @access_group
       else
        redirect_to new_access_group_path
       end
     end
 
     def show
       @access_group = AccessGroup.find(params[:id])
       if @current_user.can_see_locations_in_group?(@access_group)
         @locations = @access_group.locations
       end
     end
 
     def destroy
       access_group =  AccessGroup.find(params[:id])
       unless @current_user.can_crud_group?(access_group)
         flash[:danger]= "You are not allowed to delete that group!"
         redirect_to root_url
         return
       end
       access_group.destroy
       flash[:success] = "Group sucessfully deleted"
       redirect_to access_groups_path
     end
 
     def index
       @access_groups = current_user.access_groups
     end

     def edit
      @access_group = AccessGroup.find_by(id: params[:id])
      @access_groups = @current_user.groups_user_can_crud_subgroup
     end

     def update
      @access_group = AccessGroup.find_by(id: params[:id])
      if @access_group.update(group_params)
        flash[:success]= "Group updated"
        redirect_to @access_group
      else
        redirect_to access_groups_path(@access_group)
      end

    end


     private 
      def group_params
        params.require(:access_group).permit(:name, :parent_id, :description)
      end

      def crud_authorization
        unless current_user.is_sys_admin?
          flash[:danger]= "At this time, only sys admins are allowed to create, update, or destroy access groups."
          redirect_to access_groups_path
        end
      end
 
   end
 end