#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

# This file manages user role abilities.
class Ability
  include CanCan::Ability

  # The first argument to `can` is the action you are giving the user permission to do.
  # If you pass :manage it will apply to every action. Other common actions here are
  # :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on. If you pass
  # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  def initialize(user)
    if user.role == "site admin"
      # can :manage, :all
      # # a superadmin cannot edit other superadmins
      # cannot [:update, :destroy], User, :role => "superadmin"
      # # a superadmin can only delete one superadmin account: his own
      # # can still manage non-superadmin accounts
      # can [:update, :destroy], User, :id => user.id
    elsif user.role == "project manager"
      # # an admin can only manage meals of restaurants he has access to
      # can :manage, Meal do |meal| 
      #   (meal.restaurant_ids & user.restaurant_ids).present?
      # end
      # # an admin can create meals (which initially have no restaurant)
      # can :create, Meal
      # # an admin can access his restaurants
      # can :manage, Restaurant do |restaurant|
      #   ([restaurant.id] & user.restaurant_ids).present?
      # end
      # # an admin can only edit himself
      # can :update, User, :id => user.id
    elsif user.role == "user"
      # a customer can edit his own account
      # can :update, User, :id => user.id
      # # a customer can manage his user_meals (i.e. his connections to actual meals from chomping)
      # can :manage, UserMeal, :user_id => user.id
      # a customer can view his meals (mainly the history of his marked meals)
      # change this to user meals...? it's only for the customer/meals/index right now...
      # can :manage, Meal do |meal|
      #   ([meal.id] & user.meal_ids).present?
      # end
    end
  end
  
end
