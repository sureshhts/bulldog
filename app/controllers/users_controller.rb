class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.account_type = params[:user][:account_type]
  
    @user.time_created = Time.now.to_i
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      @user.update_attributes(:time_created => Time.now.to_i)
      self.current_user = @user # !! now logged in
     #redirect_back_or_default('/users/profile/<%= @user.id%>')
     puts "******User id ******"
     puts @id = @user.id
    redirect_to :action => 'profile', :controller => 'users', :id => @id
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
    
    render :layout => 'default'
  end
  
  def profile
  
    render :layout => 'default'
  end
  
  def create_profile
  
     if params['commit']  == 'Cancel'
	   redirect_to :action => 'new'
	   return
     else
     end
     
    @profile = AccountProfile.create(params[:profile])
 	@id = @profile.account_id
  	if @profile.save
	   flash[:notice] =  'Account Profile Created Successfully'
	   redirect_to :action => 'acc_playing_details', :controller => 'users', :id => @id
	else
	   render :action => 'new'
	end
  
   render :layout => 'default'
  end
  
  
  def acc_playing_details
    @facilties = Facility.find(:all)
    @level = PlayerLevel.find(:all)
  
   render :layout => 'default'
  end
  
  def create_playing_details
  	if params['commit']  == 'Cancel'
	   redirect_to :action => 'new'
	   return
     else
     end

    @playing_details = AccountPlayingDetail.create(:level_id => params[:account][:level_id], :facility_id => params[:account][:facility_id], :user_id  => params[:playing_details][:user_id])
 	
  	if @playing_details.save
	   flash[:notice] =  'Account Playing Details Created Successfully'
	   redirect_to :action => 'users', :controller => 'home'
	else
	   render :action => 'new'
	end
  end
  
  def home
  	
  	render :layout => 'home'
  end
  
end
