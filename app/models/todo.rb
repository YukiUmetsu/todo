class Todo < ActiveRecord::Base
  belongs_to :todo_list
  paginates_per 10
  
  # scope: :todo_list - todo_list内でTodoをリスト操作する
  # add_new_at: :top - 新規のTodoを一番上に追加する(defult: :bottom (一番下))
  acts_as_list scope: :todo_list, add_new_at: :top

  validates :todo_list_id, presence: true
  validates :description,  presence: true, length: { maximum: 255 }
  validates :completed, inclusion: { in: [true, false] }

  # AngularJSからtarget_postionとして値が送られてくるのでゲッターメソッドを定義する
  # 内部的には、acts_as_listのinsert_at(integer)メソッドを呼ぶ
  # insert_atメソッドはTodoをリスト内の特定の箇所に移動し、それ以外のTodoのpositionをいい感じに更新してくれる
  def target_position=(value)
    insert_at(value.to_i)
  end
end
