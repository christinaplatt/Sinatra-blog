class CreateBlogs < ActiveRecord::Migration
  def change
  	create_table :blogs do |t|
  		t.string :body
  		t.references :user
	end
  end
end
