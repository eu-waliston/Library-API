# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  include Roleable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum role: { member: 0, librarian: 1, admin: 2 }

  has_many :loans, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  validates :role, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def active_loans
    loans.where(returned_at: nil)
  end

  def overdue_loans
    active_loans.where('due_date < ?', Date.current)
  end

  def can_borrow?
    active_loans.count < 5 && overdue_loans.empty?
  end

  def librarian?
    role.to_sym == :librarian || admin?
  end

  def admin?
    role.to_sym == :admin
  end
end