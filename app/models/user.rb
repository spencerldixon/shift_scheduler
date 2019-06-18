class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :shifts

  def weekly_hours(date)
    shifts = self.shifts.where(start_time: (date.beginning_of_week..date.end_of_week))
    shifts.map(&:duration).sum
  end
end
