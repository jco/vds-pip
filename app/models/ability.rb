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
    if user.role == "site_admin"
      # can [:create, :update, :destroy], User
      can :manage, User
      # can [:create, :update, :destroy], Document
      can :manage, Document
      # can [:create, :update, :destroy], Folder
      can :manage, Folder
      can :manage, Project
      can :manage, [Stage, Factor]
      cannot :destroy, [Stage, Factor]
    elsif user.role == "project_manager"
      # can only manage projects which he is a part of
      can :manage, Project do |project|
        (project.membership_ids & user.membership_ids).present?
      end
      # TODO: promote / demote?
      
      # can manage his own account; *cannot change his own role -> set in view
      can :manage, User, :id => user.id
      
      # can edit other users (except site admins) in the same project; limitation to change role set in view
      can :update, User do |other_user|
        (other_user.project_ids & user.project_ids).present? # This is working =].
      end
    elsif user.role == "normal_user"
      # can only view projects with he is a part of
      can :read, Project do |project|
        (project.membership_ids & user.membership_ids).present?
      end
      # can create, edit, delete docs in projects he belongs to
      can :manage, Document do |doc|
        (doc.project.membership_ids & user.membership_ids).present?
      end
      # can edit his own account only; *cannot change his own role -> set in view
      cannot :manage, User
      can :manage, User, :id => user.id
    end
  end
  
end
