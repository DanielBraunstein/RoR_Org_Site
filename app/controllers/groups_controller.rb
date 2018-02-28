class GroupsController < ApplicationController
  def main
    @user = User.find(session[:current_user])
    @groups = Group.all
    @member_count = []
    @groups.each do |group|
      puts group.user.id
      @member_count.push(group.members.count)
    end
    if session[:errors]
      @errors = []
      session[:errors].each do |error|
        @errors.push(error)
      end
      session[:errors] = []
    end
  end
  def show_one
    @group = Group.find(params[:group_id])
    if @group.user.id == session[:current_user]
      @owner_name = "YOU"
    else
      @owner_name = (@group.user.first_name.to_s) + ' ' + (@group.user.last_name.to_s)
    end
    puts "owner name"
    puts @owner_name
    user_group_link = Membership.where(["user_id=? and group_id=?", session[:current_user], @group.id]).at(0)
    puts 'user_group_link'
    puts user_group_link
    if user_group_link != nil
      @join_or_leave = "leave"
    else
      @join_or_leave = "join"
    end
    puts @is_member
  end
  def create
    new_group = Group.create(group_params)
    new_group.save
    if new_group.valid? == false
      session[:errors] = new_group.errors.to_a
    else
      owner = User.find(session[:current_user])
      Group.update(new_group.id, user: owner)
      new_members = [owner]
      Group.update(new_group.id, members: new_members)
    end
    redirect_to '/groups'
  end
  def join
    @group = Group.find(params[:group_id])
    user_group_link = Membership.where(["user_id=? and group_id=?", session[:current_user], @group.id]).at(0)
    if user_group_link == nil
      @group.members.push(User.find(session[:current_user]))
    end
    redirect_to '/groups/' + @group.id.to_s
  end
  def leave
    @group = Group.find(params[:group_id])
    user_group_link = Membership.where(["user_id=? and group_id=?", session[:current_user], @group.id]).at(0)
    if user_group_link != nil
      Membership.destroy(user_group_link.id)
    end
    redirect_to '/groups/' + @group.id.to_s
  end
  def destroy
    user = User.find(session[:current_user])
    group = Group.find(params[:group_id])
    if group.user == user
      mShips = Membership.where("group_id=?", params[:group_id])
      mShips.each do |mShip|
        Membership.destroy(mShip.id)
      end  
      Group.destroy(params[:group_id])
    end
    redirect_to '/groups/'
  end

  private
  def group_params
    params.require(:group).permit(:name, :desc)
  end
end