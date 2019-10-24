class Task < ApplicationRecord

  validates :title, presence: true, length: { maximum: 30 }
  validates :description, presence: true
  #validates :limited_at, presence: true
  #validates :status, presence: true

  # scope method
  scope :recent, -> { order(created_at: :desc) }

  # status
  enum status: { '未着手': 0, '着手中': 1, '完了': 2 }

  def self.set_index(params)
    @q = Task.ransack(params[:q])
    @tasks = @q.result.recent
  end

  # ransack method
  def self.ransackable_attributes(auth_object = nil)
    %w[title status limited_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[]
  end

  private

  ransacker :status do
    Arel.sql("to_char(status, '9999999')")
  end

  def self.set_statuses
    Task.statuses_i18n.map{|key,value| [key, Task.statuses[value]]}
  end

  def self.set_status_key
    Task.statuses.keys
  end

end
